from django.db import models
import uuid

# Create your models here.
class MENU(models.Model):
    ID = models.UUIDField(default=uuid.uuid4, editable=False, unique=True, primary_key=True)
    Name = models.CharField(max_length=50)
    Type = models.CharField(max_length=50)
    class Meta:
        db_table="menu"

class ROOM(models.Model):
    RoomNo = models.IntegerField(primary_key=True)
    Area = models.CharField(max_length=50, null=False)
    class Meta:
        db_table="room"

class PROGRAM(models.Model):
    ProgramID = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False, unique=True)
    Name = models.CharField(max_length=20, null=False)
    AgeMin = models.IntegerField(null=False)
    AgeMax = models.IntegerField(null=False)
    class Meta:
        db_table="program"

class EXTRACURRICULAR(models.Model):
    ExtracurricularID = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    Name = models.CharField(max_length=30, null=False)
    Day = models.CharField(max_length=15, null=False)
    Hour = models.IntegerField(null=False)
    class Meta:
        db_table="extra_curricular"

class USERS(models.Model):
    UserID = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    Password = models.CharField(max_length=20, null=False)
    PhoneNumber = models.CharField(max_length=15, null=False)
    FirstName = models.CharField(max_length=20, null=True)
    LastName = models.CharField(max_length=20, null=True)
    Gender = models.CharField(max_length=10, null=True)
    Birthdate = models.DateField(null=True)
    Address = models.TextField(null=True)
    class Meta:
        db_table="users"

class CHILD(models.Model):
    UserID = models.OneToOneField(USERS, on_delete=models.CASCADE, primary_key=True)
    DadName = models.CharField(max_length=50)
    MomName = models.CharField(max_length=50)
    DadJob = models.CharField(max_length=20)
    MomJob = models.CharField(max_length=20)
    class Meta:
        db_table="child"

class STAFF(models.Model):
    UserID = models.OneToOneField(USERS, on_delete=models.CASCADE, primary_key=True)
    NIK = models.CharField(max_length=50)
    NPWP = models.CharField(max_length=50)
    BankAccount = models.CharField(max_length=50)
    BankName = models.CharField(max_length=50)
    class Meta:
        db_table="staff"

class CAREGIVER(models.Model):
    UserID = models.OneToOneField(STAFF, on_delete=models.CASCADE, primary_key=True)
    class Meta:
        db_table="caregiver"

class CAREGIVER_CERTIFICATE(models.Model):
    UserID = models.OneToOneField(USERS, on_delete=models.CASCADE, primary_key=True)
    CertificateNumber = models.CharField(max_length=20, null=True)
    CertificateName = models.CharField(max_length=20, null=True)
    CertificateYear = models.CharField(max_length=4, null=True)
    CertificateOrganizer = models.CharField(max_length=20, null=True)
    class Meta:
        unique_together = ('UserID', 'CertificateNumber', 'CertificateName', 'CertificateYear', 'CertificateOrganizer')
        db_table="caregiver_certificate"

class DRIVER(models.Model):
    # Assuming you have a custom user model, replace 'User' with your actual user model
    UserID = models.OneToOneField(USERS, on_delete=models.CASCADE, primary_key=True)
    driver_license_number = models.CharField(max_length=50)
    class Meta:
        db_table="driver"

class DRIVER_DAY(models.Model):
    # Assuming you have a custom user model, replace 'User' with your actual user model
    UserID = models.OneToOneField(DRIVER, on_delete=models.CASCADE, primary_key=True)
    Day = models.CharField(max_length=20)
    class Meta:
        unique_together = ('UserID', 'Day')
        db_table="driver_day"

class OFFERED_PROGRAM(models.Model):
    ProgramID = models.OneToOneField(PROGRAM, on_delete=models.CASCADE, primary_key=True)
    Year = models.CharField(max_length=4)
    MonthlyFee = models.CharField(max_length=50)
    DailyFee = models.CharField(max_length=50)
    class Meta:
        unique_together = ('ProgramID', 'Year')
        db_table="offered_program"
class MENU_SCHEDULE(models.Model):
    ProgramID = models.OneToOneField(OFFERED_PROGRAM, on_delete=models.CASCADE, primary_key=True)
    Year = models.CharField(max_length=4)
    Day = models.CharField(max_length=20)
    Hour = models.CharField(max_length=20)
    MenuID = models.ForeignKey(MENU, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('ProgramID', 'Year', 'Day', 'Hour')
        db_table="menu_schedule"


class ACTIVITY(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=20)
    class Meta:
        db_table="activity"

class ACTIVITY_SCHEDULE(models.Model):
    ProgramID = models.OneToOneField(OFFERED_PROGRAM, on_delete=models.CASCADE, primary_key=True)
    Year = models.CharField(max_length=4)
    Day = models.CharField(max_length=20)
    StartHour = models.IntegerField()
    EndHour = models.IntegerField()
    ActivityID = models.ForeignKey(ACTIVITY, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('ProgramID', 'Year', 'Day', 'StartHour', 'EndHour')
        db_table="activity_schedule"

class CLASS(models.Model):
    ProgramID = models.OneToOneField(OFFERED_PROGRAM, on_delete=models.CASCADE, primary_key=True)
    Year = models.CharField(max_length=4)
    ClassName = models.CharField(max_length=20)
    TotalChildren = models.IntegerField()
    CGID = models.ForeignKey(CAREGIVER, on_delete=models.CASCADE)
    RoomNo = models.ForeignKey(ROOM, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('ProgramID', 'Year', 'ClassName')
        db_table="class"

class ENROLLMENT(models.Model):
    EnrollmentID = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    UserID = models.ForeignKey(CHILD, on_delete=models.CASCADE)
    ProgramID = models.ForeignKey(OFFERED_PROGRAM, on_delete=models.CASCADE)
    Year = models.CharField(max_length=4)
    ClassName = models.CharField(max_length=20, default="Class Name")
    Date = models.DateField()
    Type = models.CharField(max_length=30)
    Amount = models.IntegerField()
    DriverID = models.ForeignKey(DRIVER, on_delete=models.CASCADE)
    PickupHour = models.IntegerField()

    class Meta:
        unique_together = ('UserID', 'ProgramID', 'Year', 'ClassName')
        db_table="enrollment"

class PAYMENT_HISTORY(models.Model):
    PaymentID = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    UserID = models.ForeignKey(CHILD, on_delete=models.CASCADE)
    ProgramID = models.UUIDField()
    Year = models.CharField(max_length=4)
    ClassName = models.CharField(max_length=20)
    PaymentDate = models.DateField()
    Type = models.CharField(max_length=10)
    Fine = models.IntegerField()
    Amount = models.IntegerField()
    EnrollmentID = models.ForeignKey(ENROLLMENT, on_delete=models.CASCADE, default=None, null= True)
    class Meta:
        db_table="payment_history"

class DAILY_REPORT(models.Model):
    DailyReportID = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    UserID = models.ForeignKey(CHILD, on_delete=models.CASCADE)
    ProgramID = models.ForeignKey(OFFERED_PROGRAM, on_delete=models.CASCADE)
    Year = models.CharField(max_length=4)
    ClassName = models.CharField(max_length=20)
    PaymentDate = models.DateField()
    ActivityReport = models.CharField(max_length=100)
    EatingReport = models.CharField(max_length=100)
    Link = models.CharField(max_length=50)
    class Meta:
        unique_together = ('UserID', 'ProgramID', 'Year', 'ClassName', 'PaymentDate')
        db_table='daily_report'

class EXTRACURRICULAR_TAKING(models.Model):
    ExtracurricularTakingID = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False, unique=True)
    UserID = models.ForeignKey(CHILD, on_delete=models.CASCADE)
    ProgramID = models.ForeignKey(OFFERED_PROGRAM, on_delete=models.CASCADE)
    Year = models.CharField(max_length=4)
    ClassName = models.CharField(max_length=20)
    ExtracurricularID = models.ForeignKey(
        EXTRACURRICULAR,
        on_delete=models.CASCADE,
        related_name='extracurricular_takings'
    )

    class Meta:
        unique_together = ('UserID', 'ProgramID', 'Year', 'ClassName', 'ExtracurricularID')
        db_table='extracurricular_taking'