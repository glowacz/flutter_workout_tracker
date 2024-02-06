import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  
  Future<ThemeMode> themeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var theme = prefs.getString('/theme') ?? '';
    switch(theme){
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = '';
    switch(theme){
      case ThemeMode.light:
        str = 'light'; break;
      case ThemeMode.dark:
        str = 'dark'; break;
      default:
        str = ''; break;
    }
    await prefs.setString('/theme', str);
  }
}
