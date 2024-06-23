import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';

import '../database/local_database.dart';

class ThemeHandler {
  final log = Logger('ThemeHandler');
  final LocalDatabase _localDatabase = Get.find();
  final storageKey = "isDark";

  ThemeMode getThemeMode() {
    return isDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool isDarkMode() {
    bool? storeTheme = _localDatabase.read(storageKey);
    if (storeTheme == null) {
      return getDeviceDefaultTheme() == Brightness.dark;
    } else {
      return storeTheme;
    }
  }

  void saveThemeMode(bool isDark){
    log.info("save Theme Mode isDark $isDark");
    _localDatabase.write(storageKey, isDark);
  }

  Brightness getDeviceDefaultTheme() {
    return SchedulerBinding.instance.platformDispatcher.platformBrightness;
  }

  void changeThemeMode(bool isDark){
    Get.changeThemeMode((isDark)? ThemeMode.dark : ThemeMode.light);
    saveThemeMode(isDark);
  }

}

