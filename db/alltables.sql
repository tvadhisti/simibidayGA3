    CREATE TABLE User (
        UserID UUID NOT NULL,
        Password VARCHAR(20) NOT NULL,
        PhoneNumber VARCHAR(15) NOT NULL,
        FirstName VARCHAR(20) NOT NULL,
        LastName VARCHAR(20) NOT NULL,
        Gender VARCHAR(10) NOT NULL,
        Birthdate DATE NOT NULL,
        Address TEXT NOT NULL,
        PRIMARY KEY (UserID));

    CREATE TABLE CHILD (
        UserID UUID NOT NULL,
        DadName VARCHAR(50) NOT NULL,
        MomName VARCHAR(50) NOT NULL,
        DadJob VARCHAR(20) NOT NULL,
        MomJob VARCHAR(20) NOT NULL,
        PRIMARY KEY (UserID),
        FOREIGN KEY (UserID) REFERENCES Users(UserID));

    CREATE TABLE STAFF (
        UserID UUID NOT NULL,
        NIK VARCHAR(50) NOT NULL,
        NPWP VARCHAR(50) NOT NULL,
        BankAccount VARCHAR(50) NOT NULL,
        BankName VARCHAR(50) NOT NULL,
        PRIMARY KEY (UserID),
        FOREIGN KEY (UserID) REFERENCES Users(UserID));

    CREATE TABLE CAREGIVER (            
        UserID UUID NOT NULL,
        PRIMARY KEY (UserID),
        FOREIGN KEY (UserID) REFERENCES STAFF(UserID));

    CREATE TABLE CAREGIVER_CERTIFICATE (
        UserID UUID NOT NULL,
        CertificateNumber VARCHAR(20),
        CertificateName VARCHAR(20),  
        CertificateYear CHAR(4),
        CertificateOrganizer VARCHAR(20),
        PRIMARY KEY (UserID, CertificateNumber, CertificateName, CertificateYear, CertificateOrganizer),
        FOREIGN KEY (UserID) REFERENCES CAREGIVER(UserID));

    CREATE TABLE DRIVER (
        UserID UUID NOT NULL,
        DriverLicenseNumber VARCHAR(50) NOT NULL,
        PRIMARY KEY (UserID),     
        FOREIGN KEY (UserID) REFERENCES STAFF(UserID)
    );

    CREATE TABLE DRIVER_DAY (
        UserID UUID NOT NULL,
        Day VARCHAR(20) NOT NULL,
        PRIMARY KEY (UserID, Day),
        FOREIGN KEY (UserID) REFERENCES DRIVER(UserID)
    );

    CREATE TABLE PROGRAM (
        ProgramID UUID PRIMARY KEY,
        Name VARCHAR(20) NOT NULL,
        AgeMin INT NOT NULL,
        AgeMax INT NOT NULL
    );

    CREATE TABLE MENU (         
        ID UUID PRIMARY KEY,
        Name VARCHAR(50) NOT NULL,
        Type VARCHAR(50) NOT NULL
    );

    CREATE TABLE OFFERED_PROGRAM (
        ProgramID UUID NOT NULL,
        Year CHAR(4) NOT NULL,
        MonthlyFee VARCHAR(50) NOT NULL,
        DailyFee VARCHAR(50) NOT NULL,
        PRIMARY KEY (ProgramID, Year),
        CONSTRAINT UniqueProgramYear UNIQUE (ProgramID, Year)
    );

    CREATE TABLE MENU_SCHEDULE (
        ProgramID UUID NOT NULL,
        Year CHAR(4) NOT NULL,
        Day VARCHAR(20) NOT NULL,
        Hour VARCHAR(20) NOT NULL,
        MenuID UUID NOT NULL,
        PRIMARY KEY (ProgramID, Year, Day, Hour),
        FOREIGN KEY (ProgramID, Year) REFERENCES OFFERED_PROGRAM(ProgramID, Year),
        FOREIGN KEY (MenuID) REFERENCES MENU(ID)
    );

    CREATE TABLE ACTIVITY (         
        ID UUID PRIMARY KEY,
        Name VARCHAR(20) NOT NULL
    );

    CREATE TABLE ACTIVITY_SCHEDULE (             
        ProgramID UUID NOT NULL,
        Year CHAR(4) NOT NULL,
        Day VARCHAR(20) NOT NULL,
        StartHour INT NOT NULL,
        EndHour INT NOT NULL,
        ActivityID UUID NOT NULL,
        FOREIGN KEY (ProgramID, Year) REFERENCES OFFERED_PROGRAM(ProgramID, Year),
        FOREIGN KEY (ActivityID) REFERENCES ACTIVITY(ID)
    );

    CREATE TABLE ROOM (                                       
        RoomNo INT PRIMARY KEY,
        Area VARCHAR(50) NOT NULL
    );

    CREATE TABLE CLASS (                                       
        ProgramID UUID NOT NULL,
        Year CHAR(4) NOT NULL,
        ClassName VARCHAR(20) NOT NULL,
        TotalChildren INT NOT NULL,
        CGID UUID NOT NULL,
        RoomNo INT NOT NULL,
        PRIMARY KEY (ProgramID, Year, ClassName),
        FOREIGN KEY (ProgramID, Year) REFERENCES OFFERED_PROGRAM(ProgramID, Year),
        FOREIGN KEY (CGID) REFERENCES CAREGIVER(UserID),
        FOREIGN KEY (RoomNo) REFERENCES ROOM(RoomNo)
    );

    CREATE TABLE ENROLLMENT (                                       
        UserID UUID NOT NULL,
        ProgramID UUID NOT NULL,
        Year CHAR(4) NOT NULL,
        Class VARCHAR(20) NOT NULL,
        Date DATE NOT NULL,
        Type VARCHAR(30) NOT NULL,
        Amount INT NOT NULL,
        DriverID UUID NOT NULL,                                                             
        PickupHour INT NOT NULL,
        PRIMARY KEY (UserID, ProgramID, Year, Class),
        FOREIGN KEY (UserID) REFERENCES CHILD(UserID),
        FOREIGN KEY (ProgramID, Year, Class) REFERENCES CLASS(ProgramID, Year, ClassName),
        FOREIGN KEY (DriverID) REFERENCES DRIVER(UserID)
    );

    CREATE TABLE PAYMENT_HISTORY (       
        PaymentID UUID PRIMARY KEY,
        UserID UUID NOT NULL,
        ProgramID UUID NOT NULL,
        Year CHAR(4) NOT NULL,
        Class VARCHAR(20) NOT NULL,
        PaymentDate DATE NOT NULL,
        Type VARCHAR(10) NOT NULL,
        Fine INT NOT NULL,
        Amount INT NOT NULL,
        FOREIGN KEY (UserID, ProgramID, Year, Class) REFERENCES ENROLLMENT(UserID, ProgramID, Year, Class)
    );

    CREATE TABLE DAILY_REPORT (                                       
        UserID UUID NOT NULL,
        ProgramID UUID NOT NULL,
        Year CHAR(4) NOT NULL,
        Class VARCHAR(20) NOT NULL,
        Date DATE NOT NULL,
        ActivityReport VARCHAR(100) NOT NULL,
        EatingReport VARCHAR(100) NOT NULL,
        Link VARCHAR(50) NOT NULL,
        PRIMARY KEY (UserID, ProgramID, Year, Class, Date),
        FOREIGN KEY (UserID, ProgramID, Year, Class) REFERENCES ENROLLMENT(UserID, ProgramID, Year, Class)
    );

    CREATE TABLE EXTRACURRICULAR (                                       
        ExtracurricularID UUID PRIMARY KEY,
        Name VARCHAR(30) NOT NULL,
        Day VARCHAR(15) NOT NULL,
        Hour INT NOT NULL
    );

    CREATE TABLE EXTRACURRICULAR_TAKING (
        UserID UUID NOT NULL,
        ProgramID UUID NOT NULL,
        Year CHAR(4) NOT NULL,
        Class VARCHAR(20) NOT NULL,
        ExtracurricularID UUID NOT NULL,
        PRIMARY KEY (UserID, ProgramID, Year, Class, ExtracurricularID),
        FOREIGN KEY (UserID, ProgramID, Year, Class) REFERENCES ENROLLMENT(UserID, ProgramID, Year, Class),
        FOREIGN KEY (ExtracurricularID) REFERENCES EXTRACURRICULAR(ExtracurricularID)
    );

    ALTER TABLE ACTIVITY_SCHEDULE
    DROP COLUMN scheduleid;

    INSERT INTO users VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Password123', '08123456789', 'John', 'Smith', 'Male', '2020-07-01', '123 Sunset Blvd, Los Angeles, CA 90001'),
    ('f47ac10b-58cc-4372-a567-0e02b2c3d479', 'Secure456', '08234567891', 'Emily', 'Johnson', 'Female', '2019-01-18', '456 Hollywood Ave, Los Angeles, CA 90002'),
    ('8f14e45f-ceea-167a-5a36-de5b3d8e40a8', 'StrongP@ss', '08345678912', 'Jordan', 'Suh', 'Male', '2019-08-11', '789 Vine Street, Los Angeles, CA 90003'),
    ('31a35f6d-a9b8-211c-acf9-e9786e8415c3', 'Rainbow789', '08456789123', 'Sarah', 'Wilson', 'Female', '1997-08-23', '101 Melrose Ave, Los Angeles, CA 90004'),
    ('9b62eab0-f304-1baf-f50e-8ec33847f61e', 'Sunshine2023', '08567891234', 'Mark', 'Lee', 'Male', '1999-08-02', '222 Beverly Dr, Los Angeles, CA 90005'),
    ('f4ae5ac2-5df0-9712-34c8-d1541b0e57a8', '3xample$tring', '08678912345', 'Jennifer', 'Brown', 'Female', '1997-01-27', '333 Santa Monica Blvd, Los Angeles, CA 90006'),
    ('8c1038b9-9e7f-72c4-c3c1-310d14290ea4', 'Fireworks101', '08789123456', 'Daniel', 'Garcia', 'Male', '2020-05-22', '444 Wilshire Blvd, Los Angeles, CA 90007'),
    ('e1d83104-14fc-0f6c-595c-8b7a23942c12', 'BlueSkies22', '08891234567', 'Laura', 'Rodriguez', 'Female', '2019-05-10', '555 Sunset Ave, Los Angeles, CA 90008'),
    ('cec0a5d4-bb65-a3a2-45bc-62a11ea396da', 'GreenGrass2022', '08912345678', 'William', 'Martinez', 'Male', '1996-10-10', '666 Rodeo Dr, Los Angeles, CA 90009'),
    ('3f078370-f625-a6ab-56f1-68f0542a0c59', 'SilverMoon77', '081234567891', 'Jessica', 'Anderson', 'Female', '2018-11-20', '777 La Brea Ave, Los Angeles, CA 90010'),
    ('c60e57d6-9a8d-73e0-489d-1a295214be98', 'Chocolate88', '082345678912', 'Maria', 'Grizelda', 'Female', '2018-03-21', '888 Hollywood Blvd, Los Angeles, CA 90011'),
    ('edda72ed-65d2-3cc8-66be-75eb767e189a', 'HappyDay99', '083456789123', 'Lily', 'Turner', 'Female', '2021-03-13', '999 Westwood Dr, Los Angeles, CA 90012'),
    ('a30ed3df-08c9-eab1-d14d-caf42d9bbd19', 'Summer2023', '084567891234', 'Grace', 'Simmons', 'Female', '2018-02-14', '111 Downtown St, Los Angeles, CA 90013'),
    ('d09b05f8-534e-b29d-e19d-94604f0fb3ac', 'SpringFlowers55', '085678912345', 'Dan', 'Stewart', 'Male', '2022-06-15', '222 Echo Park Ave, Los Angeles, CA 90014'),
    ('a57ca5c6-eb6e-5bb9-a4e6-cc906c35f92a', 'D3epBlu3$ea', '086789123456', 'Emma', 'Nelson', 'Female', '1994-10-07', '333 Griffith Park Rd, Los Angeles, CA 90015'),
    ('963a9e8d-a119-2a96-f747-aa72e17a2324', 'W1ldC@rd2023', '087891234567', 'Samuel', 'Brooks', 'Male', '1995-05-01', '444 Silverlake Blvd, Los Angeles, CA 90016');

    INSERT INTO CHILD VALUES ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Michael Smith','Sarah Smith','Doctor','Nurse'),
            ('f47ac10b-58cc-4372-a567-0e02b2c3d479','Daniel Johnson','Laura Johnson','Lawyer','Teacher'),
            ('8f14e45fceea167a5a36de5b3d8e40a8','Johnny Suh','Michelle Suh','Doctor','Accountant'),
            ('8c1038b99e7f72c4c3c1310d14290ea4','Carlos Garcia','Maria Garcia','Architect','Chef'),
            ('e1d8310414fc0f6c595c8b7a23942c12','Javier Rodriguez','Sofia Rodriguez','Electrician','Psychologist'),
            ('3f078370f625a6ab56f168f0542a0c59','Ben Anderson','Amanda Anderson','Physician','Nurse'),
            ('c60e57d69a8d73e0489d1a295214be98','Antonio Grizelda','Isabella Grizelda','Police Officer','Financial Analyst'),
            ('edda72ed65d23cc866be75eb767e189a','William Turner','Elizabeth Turner','Graphic Designer','Pharmacist'),
            ('a30ed3df08c9eab1d14dcaf42d9bbd19','Charles Simmons','Olivia Simmons','Project Manager','Marketing Manager'),
            ('d09b05f8534eb29de19d94604f0fb3ac','Thomas Stewart','Rachel Stewart','Data Scientist','Social Worker');

    INSERT INTO STAFF VALUES ('31a35f6da9b8211cacf9e9786e8415c3',8905260321478900,'12.345.678.9-123.456','1234 5678 9012 3456','BNI'),
    ('9b62eab0f3041baff50e8ec33847f61e',7209134587123640,'23.456.789.0-234.567','9876 5432 1098 7654','Mandiri'),
    ('f4ae5ac25df0971234c8d1541b0e57a8',6212057890345610,'34.567.890.1-345.678','4567 8901 2345 6789','BCA'),
    ('cec0a5d4bb65a3a245bc62a11ea396da',4501283679012340,'45.678.901.2-456.789','5678 1234 3456 7890','Mandiri'),
    ('a57ca5c6eb6e5bb9a4e6cc906c35f92a',5607229045167890,'56.789.012.3-567.890','4321 8765 6789 0123','BRI'),
    ('963a9e8da1192a96f747aa72e17a2324',3506237890456120,'67.890.123.4-678.901','7890 2345 9012 3456','BCA');

    INSERT INTO CAREGIVER VALUES ('9b62eab0f3041baff50e8ec33847f61e'),
    ('f4ae5ac25df0971234c8d1541b0e57a8'),
    ('cec0a5d4bb65a3a245bc62a11ea396da');

    INSERT INTO CAREGIVER_CERTIFICATE VALUES ('9b62eab0-f304-1baf-f50e-8ec33847f61e','9876543210','Senior Care Expert','2020','Caregiver Training'),
    ('f4ae5ac2-5df0-9712-34c8-d1541b0e57a8','8675309123','Pediatric Specialist','2020','Child Services'),
    ('cec0a5d4-bb65-a3a2-45bc-62a11ea396da','9998887776','Child Dev Associate','2019','Child Care Training');

    INSERT INTO DRIVER VALUES ('31a35f6da9b8211cacf9e9786e8415c3',22381552900),
    ('a57ca5c6eb6e5bb9a4e6cc906c35f92a',22364829503),         
    ('963a9e8da1192a96f747aa72e17a2324',22491720029);

    INSERT INTO DRIVER_DAY VALUES ('31a35f6da9b8211cacf9e9786e8415c3','Monday'),
    ('a57ca5c6eb6e5bb9a4e6cc906c35f92a','Wednesday'),
    ('963a9e8da1192a96f747aa72e17a2324','Thursday');

    INSERT INTO PROGRAM VALUES ('42513af2-e8dd-4023-94cc-2d9d16e002c4','Baby',2,12),
    ('5f089b71-4e91-4bf6-a378-ad5fc5325376','Junior Toddler',12,24),
    ('ee7742c8-9537-44ef-a444-2d5a5e07459c','Toddler',24,36),
    ('3da95080-ec4a-4a08-9162-d0d9b070b34e','Pre Kindergarten',36,48),
    ('d0735ae6-e4a3-46e2-91b8-232857f17939','Kindergarten 1',48,60),
    ('5848a322-a504-4a0d-9863-349422142dd6','Kindergarten 2',60,72),
    ('59a3668e-2bae-4500-9fe4-2bd9f4c04736','Kindergarten 3',72,84);

    INSERT INTO menu VALUES ('a44b76c7-ca7d-4e21-bd10-3d58984542cb','Bento Rice','Lunch'),
            ('07ef9c84-1235-4417-abb4-8990d604c653','Tuna Sandwiches','Morning Snacks'),
            ('bc0a7f33-4c8c-4aa2-98d2-354b780e2201','Mango Fruit','Morning Snacks'),
            ('81a45208-9252-420f-9e1c-b5fa35552338','Pureed Fruits and Vegetables','Lunch'),
            ('aa962616-1bb7-433f-8704-1d1087270509','Oatmeal','Lunch'),
            ('cc548a78-6a8c-4f2c-a38a-71df06757509','Baby Crackers','Afternoon Snacks');

    INSERT INTO OFFERED_PROGRAM VALUES ('42513af2-e8dd-4023-94cc-2d9d16e002c4',2023,4000000,300),
    ('5f089b71-4e91-4bf6-a378-ad5fc5325376',2023,4500000,350000),
    ('ee7742c8-9537-44ef-a444-2d5a5e07459c',2023,5000000,400000),
    ('3da95080-ec4a-4a08-9162-d0d9b070b34e',2023,5500000,450000),
    ('d0735ae6-e4a3-46e2-91b8-232857f17939',2023,6000000,500000),
    ('5848a322-a504-4a0d-9863-349422142dd6',2023,6500000,550000);

    INSERT INTO MENU_SCHEDULE VALUES ('42513af2-e8dd-4023-94cc-2d9d16e002c4','2023','Monday','12 PM','81a45208-9252-420f-9e1c-b5fa35552338'),
            ('5f089b71-4e91-4bf6-a378-ad5fc5325376','2023','Tuesday','9 AM','bc0a7f33-4c8c-4aa2-98d2-354b780e2201'),
            ('ee7742c8-9537-44ef-a444-2d5a5e07459c','2023','Wednesday','2 PM','aa962616-1bb7-433f-8704-1d1087270509'),
            ('3da95080-ec4a-4a08-9162-d0d9b070b34e','2023','Tuesday','1 PM','a44b76c7-ca7d-4e21-bd10-3d58984542cb'),
            ('d0735ae6-e4a3-46e2-91b8-232857f17939','2023','Friday','1 PM','a44b76c7-ca7d-4e21-bd10-3d58984542cb'),
            ('5848a322-a504-4a0d-9863-349422142dd6','2023','Friday','1 PM','a44b76c7-ca7d-4e21-bd10-3d58984542cb');

    INSERT INTO ACTIVITY VALUES ('d8e4ae55-af2d-46df-aadb-cc6a167eded6','coloring'),
    ('ad548b5d-4c39-4cd0-b6a5-99d3c4dd3596','music and dance'),
    ('b1633ccf-1d6c-4e8e-9a07-3c31753e3653','sensory play');

    INSERT INTO ACTIVITY_SCHEDULE VALUES ('42513af2-e8dd-4023-94cc-2d9d16e002c4',2023,'Monday',7,8,'b1633ccf-1d6c-4e8e-9a07-3c31753e3653'),
    ('5f089b71-4e91-4bf6-a378-ad5fc5325376',2023,'Wednesday',9,10,'d8e4ae55-af2d-46df-aadb-cc6a167eded6'),
    ('ee7742c8-9537-44ef-a444-2d5a5e07459c',2023,'Friday',11,12,'ad548b5d-4c39-4cd0-b6a5-99d3c4dd3596'),
    ('3da95080-ec4a-4a08-9162-d0d9b070b34e',2023,'Thursday',8.0,9.0,'b1633ccf-1d6c-4e8e-9a07-3c31753e3653'),
    ('d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Tuesday',7,8,'d8e4ae55-af2d-46df-aadb-cc6a167eded6'),
    ('5848a322-a504-4a0d-9863-349422142dd6',2023,'Monday',9,10,'b1633ccf-1d6c-4e8e-9a07-3c31753e3653');

    INSERT INTO ROOM VALUES (17,'outdoor'),                                                                                             
    (18,'library'),                                                                                       
    (19,'sensory');

    INSERT INTO CLASS VALUES ('42513af2-e8dd-4023-94cc-2d9d16e002c4',2023,'Baby A',5,'9b62eab0f3041baff50e8ec33847f61e',19),
    ('5f089b71-4e91-4bf6-a378-ad5fc5325376',2023,'Junior A',6,'f4ae5ac25df0971234c8d1541b0e57a8',18),     
    ('ee7742c8-9537-44ef-a444-2d5a5e07459c',2023,'Toddler A',4,'cec0a5d4bb65a3a245bc62a11ea396da',18),
    ('3da95080-ec4a-4a08-9162-d0d9b070b34e',2023,'Pre Kindergarten A',5,'9b62eab0f3041baff50e8ec33847f61e',19),
    ('d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Kindergarten 1 A',5,'f4ae5ac25df0971234c8d1541b0e57a8',17),
    ('5848a322-a504-4a0d-9863-349422142dd6',2023,'Kindergarten 2 A',7,'cec0a5d4bb65a3a245bc62a11ea396da',17);

    INSERT INTO ENROLLMENT 
     VALUES (DEFAULT,'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','3da95080-ec4a-4a08-9162-d0d9b070b34e','2023','Pre Kindergarten A','2023-10-01 00:00:00','Monthly',5500000,'31a35f6da9b8211cacf9e9786e8415c3',7),
    (DEFAULT,'f47ac10b-58cc-4372-a567-0e02b2c3d479','d0735ae6-e4a3-46e2-91b8-232857f17939','2023','Kindergarten 1 A','2023-10-02 00:00:00','Monthly',6000000,'a57ca5c6eb6e5bb9a4e6cc906c35f92a',7),
    (DEFAULT,'8f14e45fceea167a5a36de5b3d8e40a8','d0735ae6-e4a3-46e2-91b8-232857f17939','2023','Kindergarten 1 A','2023-10-03 00:00:00','Monthly',6000000,'963a9e8da1192a96f747aa72e17a2324',7),
    (DEFAULT,'8c1038b99e7f72c4c3c1310d14290ea4','3da95080-ec4a-4a08-9162-d0d9b070b34e','2023','Pre Kindergarten A','2023-10-04 00:00:00','Monthly',5500000,'31a35f6da9b8211cacf9e9786e8415c3',7),
    (DEFAULT,'e1d8310414fc0f6c595c8b7a23942c12','d0735ae6-e4a3-46e2-91b8-232857f17939','2023','Kindergarten 1 A','2023-10-05 00:00:00','Daily',500000,'a57ca5c6eb6e5bb9a4e6cc906c35f92a',7),
    (DEFAULT,'3f078370f625a6ab56f168f0542a0c59','5848a322-a504-4a0d-9863-349422142dd6','2023','Kindergarten 2 A','2023-10-06 00:00:00','Daily',550000,'963a9e8da1192a96f747aa72e17a2324',7),
    (DEFAULT,'c60e57d69a8d73e0489d1a295214be98','5848a322-a504-4a0d-9863-349422142dd6','2023','Kindergarten 2 A','2023-10-07 00:00:00','Daily',550000,'31a35f6da9b8211cacf9e9786e8415c3',7),
    (DEFAULT,'edda72ed65d23cc866be75eb767e189a','ee7742c8-9537-44ef-a444-2d5a5e07459c','2023','Toddler A','2023-10-08 00:00:00','Daily',400000,'a57ca5c6eb6e5bb9a4e6cc906c35f92a',7),
    (DEFAULT,'a30ed3df08c9eab1d14dcaf42d9bbd19','5848a322-a504-4a0d-9863-349422142dd6','2023','Kindergarten 2 A','2023-10-09 00:00:00','Monthly',6500000,'963a9e8da1192a96f747aa72e17a2324',7),
    (DEFAULT,'d09b05f8534eb29de19d94604f0fb3ac','5f089b71-4e91-4bf6-a378-ad5fc5325376','2023','Junior A','2023-10-10 00:00:00','Daily',350000,'31a35f6da9b8211cacf9e9786e8415c3',7);

    INSERT INTO PAYMENT_HISTORY VALUES ('2f5db809-9f57-4d5f-8701-7968cb0a5163','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','3da95080-ec4a-4a08-9162-d0d9b070b34e',2023,'Pre Kindergarten A','2023-10-01 00:00:00','Monthly',0,5500000),                                                                                   
    ('1512ea5b-d27d-491a-9562-a95229c5f79d','f47ac10b-58cc-4372-a567-0e02b2c3d479','d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Kindergarten 1 A','2023-10-02 00:00:00','Monthly',0,6000000),
    ('102ab3b8-950a-4cef-bc1e-a6b4ddfb04a3','8f14e45fceea167a5a36de5b3d8e40a8','d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Kindergarten 1 A','2023-10-03 00:00:00','Monthly',0,6000000),
    ('30e3dfc3-0c1b-4ae5-b485-62faf01ac45c','8c1038b99e7f72c4c3c1310d14290ea4','3da95080-ec4a-4a08-9162-d0d9b070b34e',2023,'Pre Kindergarten A','2023-10-04 00:00:00','Monthly',0,5500000),
    ('0d449c1c-c8e1-4920-a749-81bca15b3c53','e1d8310414fc0f6c595c8b7a23942c12','d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Kindergarten 1 A','2023-10-05 00:00:00','Daily',0,500000),
    ('a3167bd4-93fb-4acb-8ced-c12de52683a4','3f078370f625a6ab56f168f0542a0c59','5848a322-a504-4a0d-9863-349422142dd6',2023,'Kindergarten 2 A','2023-10-06 00:00:00','Daily',0,550000),
    ('8397313a-a1eb-42dd-b62f-68e79ed7b7ee','c60e57d69a8d73e0489d1a295214be98','5848a322-a504-4a0d-9863-349422142dd6',2023,'Kindergarten 2 A','2023-10-07 00:00:00','Daily',0,550000),
    ('164c2231-f44e-43da-bfd0-5614706cc64e','edda72ed65d23cc866be75eb767e189a','ee7742c8-9537-44ef-a444-2d5a5e07459c',2023,'Toddler A','2023-10-08 00:00:00','Daily',0,400000),
    ('37a0661e-11ba-4c95-8b18-854afef5f001','a30ed3df08c9eab1d14dcaf42d9bbd19','5848a322-a504-4a0d-9863-349422142dd6',2023,'Kindergarten 2 A','2023-10-09 00:00:00','Monthly',0,6500000),
    ('6d68784f-89cf-41c6-848b-df807d420204','d09b05f8534eb29de19d94604f0fb3ac','5f089b71-4e91-4bf6-a378-ad5fc5325376',2023,'Junior A','2023-10-10 00:00:00','Daily',0,350000),
    ('a0ec8ebd-0145-4220-9f17-a804d5cc2870','d09b05f8534eb29de19d94604f0fb3ac','5f089b71-4e91-4bf6-a378-ad5fc5325376',2023,'Junior A','2023-10-11 00:00:00','Daily',0,350000),
    ('40ab82c5-f3e9-41d7-9c87-67f8d1a021fe','c60e57d69a8d73e0489d1a295214be98','5848a322-a504-4a0d-9863-349422142dd6',2023,'Kindergarten 2 A','2023-10-08 00:00:00','Daily',0,550000);

    INSERT INTO DAILY_REPORT VALUES 
    ('3b7d9847-de04-4ab2-951b-e7b196d2ff83','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','3da95080-ec4a-4a08-9162-d0d9b070b34e',2023,'Pre Kindergarten A','2023-10-03 00:00:00','John enjoys sensory play and loves exploring art projects with enthusiasm.','John ate only half of his bento lunch today.','com/John'),
    ('6bb7630b-9397-4149-aca5-3a30d85bc4e8','f47ac10b-58cc-4372-a567-0e02b2c3d479','d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Kindergarten 1 A','2023-10-06 00:00:00','Emily has a talent for coloring and a deep enthusiasm for our creative arts projects.','Emily finished all of her bento lunch portion today.','com/Emily'),
    ('b6a47afe-c77a-490b-ab8c-0cf58232d58c','8f14e45fceea167a5a36de5b3d8e40a8','d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Kindergarten 1 A','2023-10-06 00:00:00','Jordan excels at coloring within the lines.','Jordan finished all of his bento lunch portion today.','com/Jordan'),                                                                                               
    ('765d030c-704a-4a36-b76f-6eb839032a7f','8c1038b99e7f72c4c3c1310d14290ea4','3da95080-ec4a-4a08-9162-d0d9b070b34e',2023,'Pre Kindergarten A','2023-10-03 00:00:00','Daniel has a wonderful imagination for sensory play.','Daniel ate only half of his bento lunch today.','com/Daniel'),
    ('fb37f613-b5b8-41ce-9f7f-1299f20625bd','e1d8310414fc0f6c595c8b7a23942c12','d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Kindergarten 1 A','2023-10-06 00:00:00','Laura has a talent for coloring and a deep enthusiasm for our creative arts projects.','Laura ate only half of her bento lunch today.','com/Laura'),
    ('f0778400-0d4a-4dad-8062-1f2bb50aa391','3f078370f625a6ab56f168f0542a0c59','5848a322-a504-4a0d-9863-349422142dd6',2023,'Kindergarten 2 A','2023-10-06 00:00:00','Jessica enjoys sensory play and loves exploring art projects with enthusiasm.','Jessica finished all of her bento lunch portion today.','com/Jessica'),
    ('16f58f63-da3f-44b5-aa45-4c962d22978f','c60e57d69a8d73e0489d1a295214be98','5848a322-a504-4a0d-9863-349422142dd6',2023,'Kindergarten 2 A','2023-10-06 00:00:00','Maria has a wonderful imagination for sensory play.','Maria finished all of her bento lunch portion today.','com/Maria'),
    ('05052448-1bf3-4d27-9b5f-06972c82fe46','edda72ed65d23cc866be75eb767e189a','ee7742c8-9537-44ef-a444-2d5a5e07459c',2023,'Toddler A','2023-10-04 00:00:00','Lily has a strong sense of rhythm and is passionately engaged in music and dance activities.','Lily happily finished all of her oatmeal lunch today.','com/Lily'),
    ('39fcc80b-242c-42c1-9606-1601efe30b31','a30ed3df08c9eab1d14dcaf42d9bbd19','5848a322-a504-4a0d-9863-349422142dd6',2023,'Kindergarten 2 A','2023-10-06 00:00:00','Grace enjoys sensory play and loves exploring art projects with enthusiasm.','Grace finished all of her bento lunch portion today.','com/Grace'),
    ('dd0b1b21-a7df-44e2-bc0e-5ea117fde497','d09b05f8534eb29de19d94604f0fb3ac','5f089b71-4e91-4bf6-a378-ad5fc5325376',2023,'Junior A','2023-10-03 00:00:00','Dan excels at coloring within the lines.','Dan finished all of his mango snacks today.','com/Dan'),
    ('0055c9e9-ce30-4db5-8772-af1959796907','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','3da95080-ec4a-4a08-9162-d0d9b070b34e',2023,'Pre Kindergarten A','2023-10-04 00:00:00','John takes delight in sensory activities and eagerly explores art projects.','Today, John consumed all of his bento lunch.','com/John'),
    ('df0e10bf-54c5-4715-9a79-db01404735be','f47ac10b-58cc-4372-a567-0e02b2c3d479','d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Kindergarten 1 A','2023-10-13 00:00:00','Emily possesses a knack for coloring and exhibits great enthusiasm in our creative arts endeavors.','Emily finished all of her bento lunch portion today.','com/Emily'),
    ('ebd64add-3627-42d0-8791-ebc72e68f9a4','8f14e45fceea167a5a36de5b3d8e40a8','d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Kindergarten 1 A','2023-10-13 00:00:00','Jordan demonstrates a strong aptitude for coloring neatly.','For lunch, Jordan successfully finished all of his bento portion.','com/Jordan'),
    ('cff63587-ebcb-4b54-b129-31a147fdbcb1','8c1038b99e7f72c4c3c1310d14290ea4','3da95080-ec4a-4a08-9162-d0d9b070b34e',2023,'Pre Kindergarten A','2023-10-10 00:00:00','Daniel''s imagination shines in sensory play.','Daniel ate all of his bento lunch today.','com/Daniel'),
    ('a6c7c3fd-a007-4328-baef-bc462b1e089d','e1d8310414fc0f6c595c8b7a23942c12','d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Kindergarten 1 A','2023-10-13 00:00:00','Laura excels in coloring and brings immense enthusiasm to our creative arts projects.','Laura managed to eat all of her bento lunch today.','com/Laura'),
    ('7c3e29ed-8403-449e-9a9a-732d6c2382d1','3f078370f625a6ab56f168f0542a0c59','5848a322-a504-4a0d-9863-349422142dd6',2023,'Kindergarten 2 A','2023-10-13 00:00:00','Jessica enjoys sensory play and loves exploring art projects with enthusiasm.','Jessica finished all of her bento lunch portion today.','com/Jessica');

    INSERT INTO EXTRACURRICULAR VALUES ('8314593b-e6c1-4cf2-a913-02fa1ac3c28c','Baby Yoga','Monday',7),
    ('9f84c983-81b5-4b8a-8b61-f16694f283cb','Baby Massage','Tuesday',7),
    ('cd98bcfe-bf9e-4a7d-bc5b-a5a3ce320de1','Baby Swimming','Wednesday',7),('8981bf02-4306-4e30-9a21-36edfdbc85b4','Baby Sensory Activities','Thursday',7),
    ('63e5332a-8e40-4691-8f77-29070cd59e8f','Junior Toddler Gymnastics','Friday',8),
    ('a58a40c3-8cc8-4e9a-8866-27d207114bc7','Junior Toddler Arts & Crafts','Monday',8),
    ('7689bc29-0a01-4e47-b61d-15bded9a8c7f','Junior Toddler Storytime','Tuesday',8),
    ('486a0495-9c2e-4e8a-9bd6-b27949a85454','Pre-Sport Club','Wednesday',9),           
    ('134f8a5a-ffd1-4f5e-b237-79e006094733','Pre-Dance Classes','Thursday',9),
    ('3e2ff25f-61b5-48c5-b985-9d2aad2e2d88','Pre-Swimming Lessons','Friday',9),
    ('024694e5-75c6-4f18-abb7-451fd38526ba','Music Lessons','Monday',7),
    ('315e09f1-231e-45ac-a918-aee7f33367dd','Speech Therapy','Wednesday',8),
    ('ffa96725-c8f0-4929-ba7e-331572a1713c','Nature and Outdoor Exploration','Thurday',9),
    ('3d43a4a3-f262-4b23-9a72-f661a8f12327','Gardening','Tuesday',8),
    ('6e5fd98d-1ff9-4c96-8760-ae233eb76b58','Animal Care','Friday',8);

    INSERT INTO EXTRACURRICULAR_TAKING VALUES ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','3da95080-ec4a-4a08-9162-d0d9b070b34e',2023,'Pre Kindergarten A','8314593b-e6c1-4cf2-a913-02fa1ac3c28c'),
    ('f47ac10b-58cc-4372-a567-0e02b2c3d479','d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Kindergarten 1 A','9f84c983-81b5-4b8a-8b61-f16694f283cb'),
    ('8f14e45fceea167a5a36de5b3d8e40a8','d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Kindergarten 1 A','cd98bcfe-bf9e-4a7d-bc5b-a5a3ce320de1'),
    ('8c1038b99e7f72c4c3c1310d14290ea4','3da95080-ec4a-4a08-9162-d0d9b070b34e',2023,'Pre Kindergarten A','8981bf02-4306-4e30-9a21-36edfdbc85b4'),
    ('e1d8310414fc0f6c595c8b7a23942c12','d0735ae6-e4a3-46e2-91b8-232857f17939',2023,'Kindergarten 1 A','63e5332a-8e40-4691-8f77-29070cd59e8f'),
    ('3f078370f625a6ab56f168f0542a0c59','5848a322-a504-4a0d-9863-349422142dd6',2023,'Kindergarten 2 A','a58a40c3-8cc8-4e9a-8866-27d207114bc7'),
    ('c60e57d69a8d73e0489d1a295214be98','5848a322-a504-4a0d-9863-349422142dd6',2023,'Kindergarten 2 A','7689bc29-0a01-4e47-b61d-15bded9a8c7f'),
    ('edda72ed65d23cc866be75eb767e189a','ee7742c8-9537-44ef-a444-2d5a5e07459c',2023,'Toddler A','486a0495-9c2e-4e8a-9bd6-b27949a85454'),
    ('a30ed3df08c9eab1d14dcaf42d9bbd19','5848a322-a504-4a0d-9863-349422142dd6',2023,'Kindergarten 2 A','134f8a5a-ffd1-4f5e-b237-79e006094733'),
    ('d09b05f8534eb29de19d94604f0fb3ac','5f089b71-4e91-4bf6-a378-ad5fc5325376',2023,'Junior A','3e2ff25f-61b5-48c5-b985-9d2aad2e2d88');
