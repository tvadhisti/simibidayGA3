-- Password validation on sign-up:
-- When every SIMIBIDAY user wants to sign up, the system must validate the password they inputted beforehand. For security reasons, passwords are required to have at least 1 capital letter and 1 number.
CREATE OR REPLACE FUNCTION validate_password()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT (NEW.password ~ '[A-Z]' AND NEW.password ~ '[0-9]') THEN
        RAISE EXCEPTION 'Password must contain at least 1 capital letter and 1 number';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_user
BEFORE INSERT ON user
FOR EACH ROW
EXECUTE FUNCTION validate_password();

-- Updating total children in class:
-- After a child enrolls into a program, the system will then automatically increment the total number of children in that respective class. 
CREATE OR REPLACE FUNCTION update_total_children()
RETURNS TRIGGER AS $$
BEGIN

    IF TG_OP = 'INSERT' THEN
        UPDATE class
        SET totalchildren = totalchildren + 1
        WHERE programid = NEW.programid;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_enrollment_insert
AFTER INSERT
ON enrollment
FOR EACH ROW
EXECUTE FUNCTION update_total_children();

-- Validation of activities:
-- If any activity schedules have impossible start and end hours (the start hour is later than the end hour) and if any activity schedules have intersecting duration with another activity schedule with the same day and program, the system will return an error message.
CREATE OR REPLACE FUNCTION validate_activity()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.starthour > NEW.endhour THEN
        RAISE EXCEPTION 'Start hour cannot be later than end hour.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM activity_schedule
        WHERE day = NEW.day
          AND programid = NEW.programid
          AND (
              (NEW.starthour BETWEEN starthour AND endhour)
              OR (NEW.endhour BETWEEN starthour AND endhour)
              OR (NEW.starthour < starthour AND NEW.endhour > endhour)
          )
    ) THEN
        RAISE EXCEPTION 'Activity schedule intersects with another activity on the same day and program.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_activity_insert_update
BEFORE INSERT OR UPDATE
ON activity_schedule
FOR EACH ROW
EXECUTE FUNCTION validate_activity();

-- Automatically creating a new class:
-- After a child is successfully enrolled, the system will check the class capacity. If all classes in the same program and year are full (20 people), The system will create a new class so that the next child can choose an available class. The new class should have a caregiver and a room that isn’t being used in another class within the same year.
CREATE OR REPLACE FUNCTION create_new_class()
RETURNS TRIGGER AS $$
DECLARE
    available_room INT;
    new_class_name VARCHAR(20);
BEGIN
  
    SELECT COUNT(*)
    INTO available_room
    FROM CLASS
    WHERE ProgramID = NEW.ProgramID AND Year = NEW.Year AND TotalChildren < 20;

  
    IF available_room = 0 THEN
 
        SELECT RoomNo
        INTO available_room
        FROM ROOM
        WHERE RoomNo NOT IN (
            SELECT RoomNo
            FROM CLASS
            WHERE Year = NEW.Year
        )
        LIMIT 1;

      
        new_class_name := NEW.ProgramID || ' ' || NEW.Year || ' Class ' || available_room;
        INSERT INTO CLASS (ProgramID, Year, ClassName, TotalChildren, CGID, RoomNo)
        VALUES (NEW.ProgramID, NEW.Year, new_class_name, 0, NEW.CGID, available_room);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER enrollment_trigger
AFTER INSERT ON ENROLLMENT
FOR EACH ROW
EXECUTE FUNCTION create_new_class();

-- Validation of extracurriculars:
-- When a child wants to apply for an extracurricular, the system will check if in that program whether or not they have already participated in an extracurricular that shares the same day and hour. If the system finds conflicting schedules, it will cancel the application and return an error message.
CREATE OR REPLACE FUNCTION check_schedule_conflict() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Extracurriculars
        WHERE ChildID = NEW.ChildID
        AND Day = NEW.Day
        AND Hour = NEW.Hour
    ) THEN
        RAISE EXCEPTION 'Schedule conflict detected for activity % at % on %!', NEW.ActivityName, NEW.Hour, NEW.Day;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_schedule_conflict_trigger
BEFORE INSERT ON Extracurricular
FOR EACH ROW EXECUTE FUNCTION check_schedule_conflict();

-- Menu
-- When adding a new menu schedule, make sure that the gaps between each type of menu are at least 3 hours. On each day, a menu schedule in a program must contain a maximum of 1 morning snack, 1 lunch, and 1 afternoon snack.
CREATE OR REPLACE FUNCTION check_menu_constraints() RETURNS TRIGGER AS $$
DECLARE
    cnt_morning_snack INT;
    cnt_lunch INT;
    cnt_afternoon_snack INT;
    last_menu_time TIME;
BEGIN
    -- Count the occurrences of each menu type for the day
    SELECT
        COUNT(*) FILTER (WHERE MenuType = 'Morning Snack') INTO cnt_morning_snack
    FROM MenuSchedule
    WHERE Day = NEW.Day;

    SELECT
        COUNT(*) FILTER (WHERE MenuType = 'Lunch') INTO cnt_lunch
    FROM MenuSchedule
    WHERE Day = NEW.Day;

    SELECT
        COUNT(*) FILTER (WHERE MenuType = 'Afternoon Snack') INTO cnt_afternoon_snack
    FROM MenuSchedule
    WHERE Day = NEW.Day;

    -- Rest of your trigger code remains the same...
IF last_menu_time IS NOT NULL AND (NEW.Time - last_menu_time) < INTERVAL '3 hours' THEN
        RAISE EXCEPTION 'Minimum 3 hours gap required between menus!';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_menu
BEFORE INSERT ON Menu_Schedule
FOR EACH ROW
EXECUTE FUNCTION check_menu_constraints();

-- Monthly Fine:
-- When you want to pay for a program, make sure the user has paid the fine from the previous payment. If the fine from the previous payment has not been paid, the program payment cannot be made. Additionally, If you want to pay for a monthly program, payments must be made from the 1st to the 10th, otherwise there will be a 10% fine.
-- Create the uuid-ossp extension if not exists
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create or replace the stored procedure
CREATE OR REPLACE PROCEDURE MakeProgramPayment(
    IN p_user_id UUID,
    IN p_program_id UUID,
    IN p_year CHAR(4),
    IN p_class VARCHAR(20),
    IN p_payment_date DATE,
    IN p_payment_type VARCHAR(10),
    IN p_amount INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    previous_fine INT;
BEGIN
    -- Check if the user has paid the fine from the previous payment
    SELECT Fine INTO previous_fine
    FROM PAYMENT_HISTORY
    WHERE UserID = p_user_id
        AND ProgramID = p_program_id
        AND Year = p_year
        AND Class = p_class
    ORDER BY PaymentDate DESC
    LIMIT 1;

    IF previous_fine > 0 THEN
        RAISE EXCEPTION 'Previous fine has not been paid. Cannot make the program payment.';
    END IF;

    -- Check if it's a monthly program and payment date is between 1st and 10th
    IF p_payment_type = 'Monthly' AND EXTRACT(DAY FROM p_payment_date) NOT BETWEEN 1 AND 10 THEN
        -- Apply 10% fine
        p_amount := p_amount + (p_amount * 0.1)::INT;
    END IF;

    -- Insert payment record
    INSERT INTO PAYMENT_HISTORY (
        PaymentID, UserID, ProgramID, Year, Class, PaymentDate, Type, Fine, Amount
    )
    VALUES (
        uuid_generate_v4(), p_user_id, p_program_id, p_year, p_class, p_payment_date, p_payment_type, 0, p_amount
    );
END;
$$;