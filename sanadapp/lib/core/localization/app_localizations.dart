import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App
      'appName': 'Sanad',
      'appTagline': 'Your Therapy Companion',
      
      // Auth
      'login': 'Login',
      'logout': 'Logout',
      'phoneNumber': 'Phone Number',
      'password': 'Password',
      'forgotPassword': 'Forgot Password?',
      'welcomeBack': 'Welcome Back!',
      'loginSubtitle': 'Sign in to continue your therapy journey',
      'invalidCredentials': 'Invalid phone number or password',
      
      // Navigation
      'home': 'Home',
      'tasks': 'Tasks',
      'history': 'History',
      'settings': 'Settings',
      'patients': 'Patients',
      'profile': 'Profile',
      
      // Tasks
      'dailyTasks': 'Daily Tasks',
      'checkTasks': 'Check Tasks',
      'questionTasks': 'Question Tasks',
      'noTasks': 'No tasks assigned yet',
      'taskCompleted': 'Task completed!',
      'answerPlaceholder': 'Enter your answer...',
      'saveAnswer': 'Save',
      'todayProgress': "Today's Progress",
      'completed': 'Completed',
      'remaining': 'Remaining',
      
      // History
      'taskHistory': 'Task History',
      'noHistory': 'No history available',
      'date': 'Date',
      'viewDetails': 'View Details',
      
      // Patients (Doctor)
      'myPatients': 'My Patients',
      'addPatient': 'Add Patient',
      'patientName': 'Patient Name',
      'assignTable': 'Assign Table',
      'createTable': 'Create Table',
      'editTable': 'Edit Table',
      'tableName': 'Table Name',
      'addCheckTask': 'Add Check Task',
      'addQuestionTask': 'Add Question Task',
      'taskLabel': 'Task Label',
      'noPatients': 'No patients yet',
      'patientRegistered': 'Patient registered successfully',
      'editPatient': 'Edit Patient',
      'patientUpdated': 'Patient updated successfully',
      'deletePatient': 'Delete Patient',
      'deletePatientConfirm': 'Are you sure you want to delete this patient? This action cannot be undone.',
      'patientDeleted': 'Patient deleted successfully',
      'changePassword': 'Change Password',
      'newPassword': 'New Password',
      'searchPatients': 'Search by name or phone...',
      'noSearchResults': 'No patients found',
      
      // Settings
      'appearance': 'Appearance',
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
      'about': 'About',
      'version': 'Version',
      
      // Profile
      'myProfile': 'My Profile',
      'name': 'Name',
      'role': 'Role',
      'doctor': 'Doctor',
      'patient': 'Patient',
      'memberSince': 'Member Since',
      
      // Contact & About
      'contactUs': 'Contact Us',
      'aboutApp': 'About App',
      'backendDeveloper': 'Backend Developer',
      'flutterDeveloper': 'Flutter Developer',
      'contactOnWhatsApp': 'Contact on WhatsApp',
      'needHelp': 'Need Help?',
      'wantToSubscribe': 'Want to Subscribe?',
      'subscribeMessage': 'If you face any problem, please contact us for support!',
      'developedBy': 'Developed By',
      'contactNumber': 'Contact Number',
      'call': 'Call',
      'logoutConfirm': 'Are you sure you want to logout?',
      
      // Common
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'confirm': 'Confirm',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'retry': 'Retry',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'close': 'Close',
      'search': 'Search',
      'noData': 'No data available',
      'connectionError': 'Connection error. Please try again.',
    },
    'ar': {
      // App
      'appName': 'سند',
      'appTagline': 'رفيقك في رحلة العلاج',
      
      // Auth
      'login': 'تسجيل الدخول',
      'logout': 'تسجيل الخروج',
      'phoneNumber': 'رقم الهاتف',
      'password': 'كلمة المرور',
      'forgotPassword': 'نسيت كلمة المرور؟',
      'welcomeBack': 'مرحباً بعودتك!',
      'loginSubtitle': 'سجل دخولك لمتابعة رحلتك العلاجية',
      'invalidCredentials': 'رقم الهاتف أو كلمة المرور غير صحيحة',
      
      // Navigation
      'home': 'الرئيسية',
      'tasks': 'المهام',
      'history': 'السجل',
      'settings': 'الإعدادات',
      'patients': 'المرضى',
      'profile': 'الملف الشخصي',
      
      // Tasks
      'dailyTasks': 'المهام اليومية',
      'checkTasks': 'مهام التحقق',
      'questionTasks': 'مهام الأسئلة',
      'noTasks': 'لا توجد مهام معينة بعد',
      'taskCompleted': 'تم إكمال المهمة!',
      'answerPlaceholder': 'أدخل إجابتك...',
      'saveAnswer': 'حفظ',
      'todayProgress': 'تقدم اليوم',
      'completed': 'مكتمل',
      'remaining': 'متبقي',
      
      // History
      'taskHistory': 'سجل المهام',
      'noHistory': 'لا يوجد سجل متاح',
      'date': 'التاريخ',
      'viewDetails': 'عرض التفاصيل',
      
      // Patients (Doctor)
      'myPatients': 'مرضاي',
      'addPatient': 'إضافة مريض',
      'patientName': 'اسم المريض',
      'assignTable': 'تعيين جدول',
      'createTable': 'إنشاء جدول',
      'editTable': 'تعديل الجدول',
      'tableName': 'اسم الجدول',
      'addCheckTask': 'إضافة مهمة تحقق',
      'addQuestionTask': 'إضافة مهمة سؤال',
      'taskLabel': 'عنوان المهمة',
      'noPatients': 'لا يوجد مرضى بعد',
      'patientRegistered': 'تم تسجيل المريض بنجاح',
      'editPatient': 'تعديل المريض',
      'patientUpdated': 'تم تحديث بيانات المريض بنجاح',
      'deletePatient': 'حذف المريض',
      'deletePatientConfirm': 'هل أنت متأكد من حذف هذا المريض؟ لا يمكن التراجع عن هذا الإجراء.',
      'patientDeleted': 'تم حذف المريض بنجاح',
      'changePassword': 'تغيير كلمة المرور',
      'newPassword': 'كلمة المرور الجديدة',
      'searchPatients': 'البحث بالاسم أو رقم الهاتف...',
      'noSearchResults': 'لم يتم العثور على مرضى',
      
      // Settings
      'appearance': 'المظهر',
      'darkMode': 'الوضع الداكن',
      'language': 'اللغة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'about': 'حول',
      'version': 'الإصدار',
      
      // Profile
      'myProfile': 'ملفي الشخصي',
      'name': 'الاسم',
      'role': 'الدور',
      'doctor': 'طبيب',
      'patient': 'مريض',
      'memberSince': 'عضو منذ',
      
      // Contact & About
      'contactUs': 'تواصل معنا',
      'aboutApp': 'عن التطبيق',
      'backendDeveloper': 'مطور الباك اند',
      'flutterDeveloper': 'مطور الفلاتر',
      'contactOnWhatsApp': 'تواصل عبر واتساب',
      'needHelp': 'تحتاج مساعدة؟',
      'wantToSubscribe': 'تريد الاشتراك؟',
      'subscribeMessage': 'إذا واجهت أي مشكلة، يرجى التواصل معنا للحصول على الدعم!',
      'developedBy': 'تطوير',
      'contactNumber': 'رقم التواصل',
      'call': 'اتصال',
      'logoutConfirm': 'هل أنت متأكد من تسجيل الخروج؟',
      
      // Common
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'edit': 'تعديل',
      'add': 'إضافة',
      'confirm': 'تأكيد',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجاح',
      'retry': 'إعادة المحاولة',
      'yes': 'نعم',
      'no': 'لا',
      'ok': 'حسناً',
      'close': 'إغلاق',
      'search': 'بحث',
      'noData': 'لا توجد بيانات',
      'connectionError': 'خطأ في الاتصال. يرجى المحاولة مرة أخرى.',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  bool get isArabic => locale.languageCode == 'ar';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
