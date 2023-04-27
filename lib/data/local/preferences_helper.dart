import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;
 
  PreferencesHelper({required this.sharedPreferences});
 
  static const notificationSchedule = 'NOTIFICATION_SCHEDULE';
 
  Future<bool> get notificationScheduleState async {
    final prefs = await sharedPreferences;
    return prefs.getBool(notificationSchedule) ?? false;
  }
 
  void setNotificationScheduleState(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(notificationSchedule, value);
  }
}