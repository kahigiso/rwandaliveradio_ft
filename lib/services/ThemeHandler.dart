import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeHandler {
  final _getStorage = GetStorage();
  final storageKey = "theme";

  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool isSavedDarkMode() {
    String? storeTheme = _getStorage.read(storageKey);
    print("storeTheme : $storeTheme");
    if (storeTheme == null) {
      return getDeviceDefaultTheme() == Brightness.dark;
    } else if (storeTheme == Brightness.dark.name) {
      return true;
    } else {
      return false;
    }
  }

  void saveThemeMode(Brightness mode){
    _getStorage.write(storageKey, mode.name);
  }

  Brightness getDeviceDefaultTheme() {
    return SchedulerBinding.instance.platformDispatcher.platformBrightness;
  }

  void changeThemeMode(Brightness mode){
    Get.changeThemeMode((mode == Brightness.dark)? ThemeMode.dark : ThemeMode.light);
    saveThemeMode(mode);
  }

}

