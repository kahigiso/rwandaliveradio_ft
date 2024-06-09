import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeHandler {
  final _getStorage = GetStorage();
  final storageKey = "isDark";

  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool isSavedDarkMode() {
    bool? storeTheme = _getStorage.read(storageKey);
    if (storeTheme == null) {
      return getDeviceDefaultTheme() == Brightness.dark;
    } else {
      return storeTheme;
    }
  }

  void saveThemeMode(bool isDark){
    _getStorage.write(storageKey, isDark);
  }

  Brightness getDeviceDefaultTheme() {
    return SchedulerBinding.instance.platformDispatcher.platformBrightness;
  }

  void changeThemeMode(bool isDark){
    Get.changeThemeMode((isDark)? ThemeMode.dark : ThemeMode.light);
    saveThemeMode(isDark);
  }

}

