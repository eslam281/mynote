import 'dart:async';
import 'package:flutter/foundation.dart';
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
      'app_title': 'My Notes',
      'home': 'My Notes',
      'trash': 'Trash',
      'archive': 'Archive',
      'new_note': 'New Note',
      'search_hint': 'Search your notes...',
      'delete_all': 'Delete all notes',
      'delete_all_confirm': 'This action cannot be undone.',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'pin': 'Pin',
      'unpin': 'Unpin',
      'duplicate': 'Duplicate',
      'move_to_trash': 'Move to Trash',
      'unarchive': 'Unarchive',
      'restore': 'Restore Note',
      'delete_permanent': 'Delete Permanently',
      'manage_categories': 'Manage Categories',
      'settings': 'Settings',
      'about_me': 'About Me',
      'contact_us': 'Contact Us',
      'appearance': 'Appearance',
      'theme_mode': 'Theme Mode',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'localization': 'Localization',
      'app_language': 'App Language',
      'english': 'English',
      'arabic': 'Arabic',
      'about': 'About',
      'version': 'Version',
      'privacy_first': 'Privacy First',
      'privacy_desc': 'All data is stored locally on your device.',
      'unsaved_changes': 'Unsaved Changes',
      'save_confirm': 'Do you want to save your changes before leaving?',
      'save': 'Save',
      'discard': 'Discard',
      'stay': 'Stay',
      'note_info': 'Note Info',
      'characters': 'Characters',
      'words': 'Words',
      'created': 'Created',
      'export_pdf': 'Export to PDF',
      'lock_note': 'Lock Note',
      'title_hint': 'Title',
      'content_hint': 'Start typing...',
      'bg_color': 'Background Color',
      'add_item': 'Add Item',
      'add': 'Add',
      'all': 'All',
      'new_cat_hint': 'New category name...',
      'no_notes_found': 'No notes found',
      'trash_purge_msg': 'Notes in Trash will be permanently deleted after 30 days.',
      'technical_skills': 'Technical Skills',
      'key_projects': 'Key Projects',
      'personal_skills': 'Personal Skills',
      'contact_msg': 'We would love to hear from you',
      'contact_platform': 'You can reach us through these platforms',
      'email': 'Email',
      'locked_note_msg': 'This note is locked and protected by security.',
      'auth_reason': 'Please authenticate to view this locked note',
    },
    'ar': {
      'app_title': 'ملاحظاتي',
      'home': 'ملاحظاتي',
      'trash': 'سلة المهملات',
      'archive': 'الأرشيف',
      'new_note': 'ملاحظة جديدة',
      'search_hint': 'ابحث في ملاحظاتك...',
      'delete_all': 'حذف الكل',
      'delete_all_confirm': 'لا يمكن التراجع عن هذا الإجراء.',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'pin': 'تثبيت',
      'unpin': 'إلغاء التثبيت',
      'duplicate': 'تكرار',
      'move_to_trash': 'نقل للسلة',
      'unarchive': 'إلغاء الأرشفة',
      'restore': 'استعادة الملاحظة',
      'delete_permanent': 'حذف نهائي',
      'manage_categories': 'إدارة التصنيفات',
      'settings': 'الإعدادات',
      'about_me': 'من أنا',
      'contact_us': 'تواصل معنا',
      'appearance': 'المظهر',
      'theme_mode': 'وضع السمات',
      'system': 'تلقائي',
      'light': 'نهاري',
      'dark': 'ليلي',
      'localization': 'اللغة والمكان',
      'app_language': 'لغة التطبيق',
      'english': 'English',
      'arabic': 'العربية',
      'about': 'حول التطبيق',
      'version': 'الإصدار',
      'privacy_first': 'الخصوصية أولاً',
      'privacy_desc': 'يتم تخزين كافة البيانات محلياً على جهازك.',
      'unsaved_changes': 'تعديلات غير محفوظة',
      'save_confirm': 'هل تريد حفظ التعديلات قبل الخروج؟',
      'save': 'حفظ',
      'discard': 'تجاهل',
      'stay': 'بقاء',
      'note_info': 'معلومات الملاحظة',
      'characters': 'عدد الحروف',
      'words': 'عدد الكلمات',
      'created': 'تاريخ الإنشاء',
      'export_pdf': 'تصدير كـ PDF',
      'lock_note': 'قفل الملاحظة',
      'title_hint': 'العنوان',
      'content_hint': 'ابدأ الكتابة هنا...',
      'bg_color': 'لون الخلفية',
      'add_item': 'إضافة عنصر',
      'add': 'إضافة',
      'all': 'الكل',
      'new_cat_hint': 'اسم التصنيف الجديد...',
      'no_notes_found': 'لم يتم العثور على ملاحظات',
      'trash_purge_msg': 'سيتم حذف الملاحظات في السلة نهائياً بعد 30 يوماً.',
      'technical_skills': 'المهارات التقنية',
      'key_projects': 'أبرز المشاريع',
      'personal_skills': 'المهارات الشخصية',
      'contact_msg': 'يسعدنا تواصلك معنا',
      'contact_platform': 'يمكنك الوصول إلينا عبر المنصات التالية',
      'email': 'البريد الإلكتروني',
      'locked_note_msg': 'هذه الملاحظة مقفلة ومحمية بنظام الأمان.',
      'auth_reason': 'يرجى المصادقة لعرض هذه الملاحظة المقفلة',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
