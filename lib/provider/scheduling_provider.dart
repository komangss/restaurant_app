import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/data/local/preferences_helper.dart';

import '../utils/background_service.dart';
import '../utils/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;
  late bool _isScheduled = false;
  bool get isScheduled => _isScheduled;
  Future<void> setIsScheduleState(value) async {
    preferencesHelper.setNotificationScheduleState(value);
    _isScheduled = value;
    await scheduledNews();
    notifyListeners();
  }

  SchedulingProvider({required this.preferencesHelper}) {
    updateCurrentState();
  }

  Future<void> updateCurrentState() async {
    _isScheduled = await preferencesHelper.notificationScheduleState;
    notifyListeners();
  }

  Future<bool> scheduledNews() async {
    if (isScheduled) {
      notifyListeners();
      return await AndroidAlarmManager.periodic(
          const Duration(hours: 24), 1, BackgroundService.callback,
          startAt: DateTimeHelper.format(), exact: true, wakeup: true);
    } else {
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
