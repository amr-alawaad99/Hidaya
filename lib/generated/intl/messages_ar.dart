// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Asr": MessageLookupByLibrary.simpleMessage("العصر"),
        "AsrMethod":
            MessageLookupByLibrary.simpleMessage("طريقة حساب توقيت العصر"),
        "AsrMethodDescription": MessageLookupByLibrary.simpleMessage(
            "حساب وقت صلاة العصر:\n\nهناك اختلاف بسيط في حساب وقت صلاة العصر بين المذاهب الأربعة.\nففي المذهب الشافعي، والمالكي، والحنبلي فيدخل وقت صلاة العصر عندما يصبح طول ظل كل شيء مِثلَه.\nأما في المذهب الحنفي فيدخل وقت صلاة العصر عندما يصبح ظل كل شيء مِثلَيه."),
        "CalculationMethod":
            MessageLookupByLibrary.simpleMessage("طريقة حساب مواقيت الصلاة"),
        "CalculationMethodDescription": MessageLookupByLibrary.simpleMessage(
            "هناك عدة مراجع لحساب أوقات الصلاة، والاختلاف الأساسي بين طرق حساب أوقات الصلاة هو في صلاة الفجر والعشاء، وذلك لأن الشمس لا تُرى عند الفجر والعشاء فيعتمد حسابهما على ظهور الشفق الأحمر وغيابه وعلى زاوية الشمس تحت الأفق.\nهناك العديد من الطرق التي تم اعتمادها بشكل رسمي في معظم دول العالم، نذكر منها:\n\n•\tرابطة العالم الإسلامي: تعتمد زاوية 18° للفجر و17° للعشاء.\n\n•\tالهيئة المصرية العامة للمساحة: تعتمد زاوية 19.5° للفجر و17.5° للعشاء.\n\n•\tجامعة العلوم الإسلامية، كراتشي: تعتمد زاوية 18° لكل من الفجر والعشاء.\n\n•\tجامعة أم القرى، مكة: تعتمد زاوية 18° للفجر وفترة زمنية ثابتة 90 دقيقة للعشاء (مع إضافة 30 دقيقة إضافية في رمضان).\n\n•\tطريقة الإمارات العربية المتحدة: تعتمد زاوية 18.2° للفجر والعشاء.\n\n•\tقطر: نسخة معدلة من طريقة أم القرى، تعتمد زاوية 18° للفجر وفترة زمنية ثابتة 90 دقيقة للعشاء.\n\n•\tالكويت: تعتمد زاوية 18° للفجر و17.5° للعشاء.\n\n•\tلجنة مراقبة الهلال: تعتمد زاوية 18° لكل من الفجر والعشاء مع تعديلات موسمية.\n\n•\tطريقة سنغافورة: تعتمد زاوية 20° للفجر و18° للعشاء.\n\n•\tطريقة أمريكا الشمالية (ISNA): تعتمد زاوية 15° لكل من الفجر والعشاء.\n\n•\tتركيا: تعتمد زاوية 18° للفجر و17° للعشاء.\n\n•\tطهران: تعتمد زاوية 17.7° للفجر و14° للعشاء و4.5° للمغرب.\n\nوكل من هذه الطرق تعتمد على حساب زاوية مختلفة للشمس تحت الأفق لتحديد صلاتي الفجر والعشاء.\n"),
        "CompassCalibration":
            MessageLookupByLibrary.simpleMessage("طريقة إعادة معايرة البوصلة"),
        "DarkMode": MessageLookupByLibrary.simpleMessage("الوضع الليلي"),
        "Dhuhr": MessageLookupByLibrary.simpleMessage("الظهر"),
        "EgyptianGeneralAuthorityOfSurvey":
            MessageLookupByLibrary.simpleMessage(
                "الهيئة المصرية العامة للمساحة"),
        "Fajr": MessageLookupByLibrary.simpleMessage("الفجر"),
        "Hanafi": MessageLookupByLibrary.simpleMessage("المذهب الحنفي"),
        "Hijri": MessageLookupByLibrary.simpleMessage("هـ"),
        "Home": MessageLookupByLibrary.simpleMessage("الرئيسية"),
        "Hour": MessageLookupByLibrary.simpleMessage("ساعة"),
        "HourlyNotification":
            MessageLookupByLibrary.simpleMessage("الإشعارات التذكيرية"),
        "HourlyNotificationDescription":
            MessageLookupByLibrary.simpleMessage("إشعار الصلاة على النبي ﷺ"),
        "Isha": MessageLookupByLibrary.simpleMessage("العشاء"),
        "IslamicSocietyOfNorthAmerica": MessageLookupByLibrary.simpleMessage(
            "الجمعية الإسلامية لأمريكا الشمالية"),
        "Kuwait": MessageLookupByLibrary.simpleMessage("الكويت"),
        "Language": MessageLookupByLibrary.simpleMessage("ar"),
        "LocationDisabled":
            MessageLookupByLibrary.simpleMessage("خدمات الموقع غير مفعلة."),
        "Maghrib": MessageLookupByLibrary.simpleMessage("المغرب"),
        "Minute": MessageLookupByLibrary.simpleMessage("دقيقة"),
        "MoonsightingCommittee":
            MessageLookupByLibrary.simpleMessage("لجنة تحري الهلال"),
        "MuslimWorldLeague":
            MessageLookupByLibrary.simpleMessage("رابطة العالم الإسلامي"),
        "NotificationsDisabled": MessageLookupByLibrary.simpleMessage(
            "تم منع الإشعارات, براجاء منح إذن الإشعارات من إعدادات التطبيق."),
        "PermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
            "تم منع الوصول إلى الموقع, برجاء منح إذن الوصول من إعدادات التطبيق."),
        "PrayerNotification": MessageLookupByLibrary.simpleMessage("الإشعارات"),
        "Qatar": MessageLookupByLibrary.simpleMessage("قطر"),
        "Qibla": MessageLookupByLibrary.simpleMessage("القِبلة"),
        "RecommendedSettings":
            MessageLookupByLibrary.simpleMessage("الإعدادات الموصى بها"),
        "Second": MessageLookupByLibrary.simpleMessage("ثانية"),
        "Settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
        "Shafi": MessageLookupByLibrary.simpleMessage(
            "المذهب الشافعي، المالكي، الحنبلي"),
        "Singapore": MessageLookupByLibrary.simpleMessage("سنغافورة"),
        "SoundOnSilent": MessageLookupByLibrary.simpleMessage(
            "تشغيل صوت الأذان حتى في وضع الصامت"),
        "Sunrise": MessageLookupByLibrary.simpleMessage("الشروق"),
        "Tehran": MessageLookupByLibrary.simpleMessage("طهران"),
        "TimeLeft": MessageLookupByLibrary.simpleMessage("متبقي"),
        "Turkey": MessageLookupByLibrary.simpleMessage("تركيا"),
        "UAE": MessageLookupByLibrary.simpleMessage("الإمارات العربية المتحدة"),
        "UmmAlQuraUniversityMakkah":
            MessageLookupByLibrary.simpleMessage("جامعة أم القرى، مكة المكرمة"),
        "UniversityOfIslamicSciencesKarachi":
            MessageLookupByLibrary.simpleMessage(
                "جامعة العلوم الإسلامية، كراتشي"),
        "isFullAzanOn": MessageLookupByLibrary.simpleMessage(
            "تشغيل الأذان كاملاً لهذه الصلاة")
      };
}
