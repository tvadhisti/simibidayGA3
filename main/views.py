from django.shortcuts import render, redirect, get_object_or_404
from .models import MENU, ROOM, PROGRAM, USERS, EXTRACURRICULAR, STAFF, CHILD, PAYMENT_HISTORY, OFFERED_PROGRAM, ACTIVITY, CAREGIVER_CERTIFICATE, DRIVER, DRIVER_DAY
from django.http import JsonResponse
from django.views.decorators.http import require_POST


def child_list(request):
    context = {
        'title' : 'Child List',
    }
    return render(request, 'childList.html', context)
def admin_staff(request):
    listData = STAFF.objects.all().order_by('UserID__FirstName')
    context = {
        'title' : 'Admin Staff',
        'listData': listData
    }
    return render(request, 'adminStaff.html', context)

def form_staff(request):
    if request.method == "POST":
        Name = request.POST['Name']
        AgeMin = request.POST['AgeMin']
        AgeMax = request.POST['AgeMax']
        data = PROGRAM(Name=Name, AgeMin=AgeMin, AgeMax=AgeMax)
        data.save()
        return redirect('admin_program')
    else:
        context = {
            'title': 'PROGRAM FORM',
        }
        return render(request, 'formProgram.html', context)
def update_staff(request,pk):
    data = PROGRAM.objects.get(ProgramID=pk)
    if request.method == "POST":
        data.Name = request.POST['Name']
        data.AgeMin = request.POST['AgeMin']
        data.AgeMax = request.POST['AgeMax']
        data.save()
        return redirect('admin_program')
    else:
        context = {
            'title': 'UPDATE {} MENU'.format(data.Name),
            'data': data
        }
        return render(request, 'updateProgram.html', context)
    
@require_POST
def delete_staff(request, id):
    data = get_object_or_404(PROGRAM, ProgramID=id)
    data.delete()
    return JsonResponse({'message': 'Data deleted successfully'})

def admin_program(request):
    programs = PROGRAM.objects.all().order_by('Name')
    context = {
        'title' : 'Admin Program',
        'programs': programs
    }
    return render(request, 'adminProgram.html', context)

def form_program(request):
    if request.method == "POST":
        Name = request.POST['Name']
        AgeMin = request.POST['AgeMin']
        AgeMax = request.POST['AgeMax']
        data = PROGRAM(Name=Name, AgeMin=AgeMin, AgeMax=AgeMax)
        data.save()
        return redirect('admin_program')
    else:
        context = {
            'title': 'PROGRAM FORM',
        }
        return render(request, 'formProgram.html', context)
def update_program(request,pk):
    data = PROGRAM.objects.get(ProgramID=pk)
    if request.method == "POST":
        data.Name = request.POST['Name']
        data.AgeMin = request.POST['AgeMin']
        data.AgeMax = request.POST['AgeMax']
        data.save()
        return redirect('admin_program')
    else:
        context = {
            'title': 'UPDATE {} MENU'.format(data.Name),
            'data': data
        }
        return render(request, 'updateProgram.html', context)
    
@require_POST
def delete_program(request, id):
    data = get_object_or_404(PROGRAM, ProgramID=id)
    data.delete()
    return JsonResponse({'message': 'Data deleted successfully'})

def admin_offered_program(request):
    listData = OFFERED_PROGRAM.objects.all().order_by('ProgramID__Name')
    context = {
        'title' : 'Admin Offered Program',
        'listData': listData
    }
    return render(request, 'adminOfferedProgram.html', context)

def form_offered_program(request):
    if request.method == "POST":
        programSave = PROGRAM.objects.get(ProgramID=request.POST['ProgramID'])
        ProgramID = programSave
        Year = request.POST['Year']
        MonthlyFee = request.POST['MonthlyFee']
        DailyFee = request.POST['DailyFee']
        data = OFFERED_PROGRAM(ProgramID=ProgramID, Year=Year, MonthlyFee=MonthlyFee, DailyFee=DailyFee)
        data.save()
        return redirect('admin_offered_program')
    else:
        dataProgram = PROGRAM.objects.all().order_by('Name')
        context = {
            'title': 'PROGRAM OFFERED FORM',
            'dataProgram': dataProgram
        }
        return render(request, 'formOfferedProgram.html', context)
def update_offered_program(request,pk):
    data = PROGRAM.objects.get(ProgramID=pk)
    if request.method == "POST":
        data.Name = request.POST['Name']
        data.AgeMin = request.POST['AgeMin']
        data.AgeMax = request.POST['AgeMax']
        data.save()
        return redirect('admin_program')
    else:
        context = {
            'title': 'UPDATE {} MENU'.format(data.Name),
            'data': data
        }
        return render(request, 'updateProgram.html', context)
@require_POST
def delete_offered_program(request, id):
    print(id)
    data = get_object_or_404(OFFERED_PROGRAM, ProgramID=id)
    data.delete()
    return JsonResponse({'message': 'Data deleted successfully'})

def crud_extracurricular(request):
    extraCurriculars = EXTRACURRICULAR.objects.all().order_by('Name')
    context = {
        'title' : 'Extracurricular',
        'extraCurriculars': extraCurriculars
    }
    return render(request, 'crudExtracurricular.html', context)

def extracurricular_form(request):
    if request.method == "POST":
        Name = request.POST['Name']
        Day = request.POST['Day']
        Hour = request.POST['Hour']
        data = EXTRACURRICULAR(Name=Name, Day=Day, Hour=Hour)
        data.save()
        return redirect('crud_extracurricular')
    else:
        context = {
            'title' : 'Extracurricular Form',
        }
        return render(request, 'extracurricularForm.html', context)

def extracurricular_detail(request, pk):
    extraCurricular = EXTRACURRICULAR.objects.get(ExtracurricularID=pk)
    context = {
        'title' : 'Extracurricular Detail',
        'extraCurricular': extraCurricular
    }
    return render(request, 'extracurricularDetail.html', context)

def update_extracurricular(request, pk):
    extraCurricular = EXTRACURRICULAR.objects.get(ExtracurricularID=pk)
    if request.method == "POST":
        extraCurricular.Name = request.POST['Name']
        extraCurricular.Day = request.POST['Day']
        extraCurricular.Hour = request.POST['Hour']
        extraCurricular.save()
        return redirect('crud_extracurricular')
    else:
        context = {
            'title' : 'Update Extracurricular',
            'extraCurricular': extraCurricular
        }
        return render(request, 'updateExtracurricular.html', context)
@require_POST
def delete_extracurricular(request, id):
    data = get_object_or_404(EXTRACURRICULAR, ExtracurricularID=id)
    data.delete()
    return JsonResponse({'message': 'Data deleted successfully'})

def crud_menu(request):
    menus = MENU.objects.all().order_by('Name')
    context = {
        'title': 'MENU',
        'menus': menus
    }
    return render(request, 'crudMenu.html', context)

def menu_form(request):
    if request.method == "POST":
        Name = request.POST['Name']
        Type = request.POST['Type']
        data = MENU(Name=Name, Type=Type)
        data.save()
        return redirect('crud_menu')
    else:
        context = {
            'title': 'MENU FORM',
        }
        return render(request, 'menuForm.html', context)

def update_menu(request,pk):
    menu = MENU.objects.get(ID=pk)
    if request.method == "POST":
        menu.Name = request.POST['Name']
        menu.Type = request.POST['Type']
        menu.save()
        return redirect('crud_menu')
    else:
        context = {
            'title': 'UPDATE {} MENU'.format(menu.Name),
            'menu': menu
        }
        return render(request, 'updateMenu.html', context)
@require_POST
def delete_menu(request, id):
    data = get_object_or_404(MENU, ID=id)
    data.delete()
    return JsonResponse({'message': 'Data deleted successfully'})

def room(request):
    rooms = ROOM.objects.all().order_by('RoomNo')
    context = {
        'title': 'ROOM',
        'rooms': rooms
    }
    return render(request, 'room.html', context)

def room_form(request):
    if request.method == "POST":
        RoomNo = request.POST['RoomNo']
        Area = request.POST['Area']
        data = ROOM(RoomNo=RoomNo, Area=Area)
        data.save()
        return redirect('room')
    else:
        context = {
            'title': 'ROOM FORM',
        }
        return render(request, 'roomForm.html', context)
    
@require_POST
def delete_room(request, room_id):
    room = get_object_or_404(ROOM, RoomNo=room_id)
    room.delete()
    return JsonResponse({'message': 'Room deleted successfully'})

def sclass(request):
    context = {
        'title': 'CLASS',
    }
    return render(request, 'class.html', context)

def child_in_class(request):
    context = {
        'title': 'CHILDREN IN CLASS',
    }
    return render(request, 'childInclass.html', context)

def daily_report(request):
    context = {
        'title': '[CHILD Name]’s DAILY REPORT',
    }
    return render(request, 'dailyReport.html', context)

def daily_report_form(request):
    context = {
        'title': 'DAILY REPORT FORM',
    }
    return render(request, 'dailyReportForm.html', context)

def admin_dashboard(request):
    context = {
        'title': 'ADMIN DASHBOARD',
    }
    return render(request, 'adminDashboard.html', context)

def login(request):
    context = {
        'title': 'SIMIBIDAY - GROUP CODE',
    }
    return render(request, 'login.html', context)

def login_form(request):
    context = {
        'title': 'LOGIN FORM',
    }
    return render(request, 'loginForm.html', context)

def register(request):
    context = {
        'title': 'REGISTER',
    }
    return render(request, 'register.html', context)

def child_register(request):
    if request.method == "POST":
        FirstName = request.POST['FirstName']
        LastName = request.POST['LastName']
        Password = request.POST['Password']
        PhoneNumber = request.POST['PhoneNumber']
        Birthdate = request.POST['Birthdate']
        Gender = request.POST['Gender']
        Address = request.POST['Address']
        data = USERS(Password=Password, PhoneNumber=PhoneNumber, Gender=Gender, FirstName=FirstName, LastName=LastName, Birthdate=Birthdate, Address=Address)
        
        DadName = request.POST['DadName']
        MomName = request.POST['MomName']
        DadJob = request.POST['DadJob']
        MomJob = request.POST['MomJob']
        try:
            data.save()
            UserID = data
            childData = CHILD(UserID=UserID, DadName=DadName, MomName=MomName, DadJob=DadJob, MomJob=MomJob)
            childData.save()
            return redirect('admin_dashboard')
        except Exception as e:
            error_message = str(e)
    else:
        context = {
            'title': 'CHILD REGISTRATION FORM',
        }
        return render(request, 'childRegist.html', context)

def admin_register(request):
    if request.method == "POST":
        Password = request.POST['Password']
        PhoneNumber = request.POST['PhoneNumber']
        data = USERS(Password=Password, PhoneNumber=PhoneNumber)
        try:
            data.save()
            return redirect('admin_dashboard')
        except Exception as e:
            print(e)
    else:
        context = {
            'title': 'ADMIN REGISTRATION FORM',
        }
        return render(request, 'adminRegist.html', context)


def caregiver_register(request):
    if request.method == "POST":
        FirstName = request.POST['FirstName']
        LastName = request.POST['LastName']
        Password = request.POST['Password']
        PhoneNumber = request.POST['PhoneNumber']
        Birthdate = request.POST['Birthdate']
        Gender = request.POST['Gender']
        Address = request.POST['Address']
        data = USERS(Password=Password, PhoneNumber=PhoneNumber, Gender=Gender, FirstName=FirstName, LastName=LastName, Birthdate=Birthdate, Address=Address)

        # Staff properties
        NIK = request.POST['NIK']
        NPWP = request.POST['NPWP']
        BankAccount = request.POST['BankAccount']
        BankName = request.POST['BankName']

        # caregiver certificate data
        CertificateNumber = request.POST['CertificateNumber']
        CertificateName = request.POST['CertificateName']
        CertificateYear = request.POST['CertificateYear']
        CertificateOrganizer = request.POST['CertificateOrganizer']
        try:
            data.save()
            UserID = data
            # save staff
            staffData = STAFF(UserID=UserID, NIK=NIK, NPWP=NPWP, BankAccount=BankAccount, BankName=BankName)
            staffData.save()

            # save caregiver certificate
            caregiverCertificateData = CAREGIVER_CERTIFICATE(UserID=UserID, CertificateNumber=CertificateNumber, CertificateName=CertificateName, CertificateYear=CertificateYear, CertificateOrganizer=CertificateOrganizer)
            caregiverCertificateData.save()


            return redirect('admin_dashboard')
        except Exception as e:
            error_message = str(e)
    else:
        context = {
            'title': 'CAREGIVER REGISTRATION FORM',
        }
        return render(request, 'caregiverRegist.html', context)

def driver_register(request):
    if request.method == "POST":
        FirstName = request.POST['FirstName']
        LastName = request.POST['LastName']
        Password = request.POST['Password']
        PhoneNumber = request.POST['PhoneNumber']
        Birthdate = request.POST['Birthdate']
        Gender = request.POST['Gender']
        Address = request.POST['Address']
        data = USERS(Password=Password, PhoneNumber=PhoneNumber, Gender=Gender, FirstName=FirstName, LastName=LastName, Birthdate=Birthdate, Address=Address)

        # Staff properties
        NIK = request.POST['NIK']
        NPWP = request.POST['NPWP']
        BankAccount = request.POST['BankAccount']
        BankName = request.POST['BankName']

        # driver data
        driver_license_number = request.POST['driver_license_number']

        # driver day data
        Day = request.POST['Day']
        try:
            data.save()
            # save staff
            staffData = STAFF(UserID=data, NIK=NIK, NPWP=NPWP, BankAccount=BankAccount, BankName=BankName)
            staffData.save()

            # save driver data
            driverData = DRIVER(UserID=data, driver_license_number=driver_license_number)
            driverData.save()

            # save driver day data
            driverDayData = DRIVER_DAY(UserID=driverData, Day=Day)
            driverDayData.save()

            return redirect('admin_dashboard')
        except Exception as e:
            error_message = str(e)
    else:
        context = {
            'title': 'DRIVER REGISTRATION FORM',
        }
        return render(request, 'driverRegist.html', context)

def user_dashboard(request):
    context = {
        'title': 'User Dashboard: [User’s Full Name]',
    }
    return render(request, 'userDashboard.html', context)

def child_program(request):
    context = {
        'title': 'CHILD PROGRAM DATA',
    }
    return render(request, 'childProgramExt.html', context)

def admin_activity(request):
    listData = ACTIVITY.objects.all().order_by('name')
    context = {
        'title': 'ACTIVITY DATA',
        'listData': listData
    }
    return render(request, 'adminActivity.html', context)


def form_activity(request):
    if request.method == "POST":
        name = request.POST['name']
        data = ACTIVITY(name=name)
        data.save()
        return redirect('admin_activity')
    else:
        context = {
            'title': 'ACTIVITY FORM',
        }
        return render(request, 'formActivity.html', context)
def update_activity(request,pk):
    data = ACTIVITY.objects.get(id=pk)
    if request.method == "POST":
        data.name = request.POST['name']
        data.save()
        return redirect('admin_activity')
    else:
        context = {
            'title': 'UPDATE {} MENU'.format(data.name),
            'data': data
        }
        return render(request, 'updateActivity.html', context)
    
@require_POST
def delete_activity(request, id):
    data = get_object_or_404(ACTIVITY, id=id)
    data.delete()
    return JsonResponse({'message': 'Data deleted successfully'})

def crd_program(request):
    context = {
        'title': 'MANAGE EXTRACURRICULAR',
    }
    return render(request, 'crdProgramExt.html', context)

def driver_pickup(request):
    context = {
        'title': 'PICKUP SCHEDULE',
    }
    return render(request, 'driverPickupSchedule.html', context)

def payment_history_admin(request):
    listData = PAYMENT_HISTORY.objects.all().order_by('PaymentDate')
    context = {
        'title' : 'Payment History',
        'listData': listData
    }
    return render(request, 'paymentHistoryAdmin.html', context)

def payment_history_child(request):
    context = {
        'title' : 'Payment History',
    }
    return render(request, 'paymentHistoryChild.html', context)

def payment_form(request):
    context = {
        'title' : 'Payment Form',
    }
    return render(request, 'paymentForm.html', context)

