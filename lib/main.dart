import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

Future main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences prefs = await SharedPreferences.getInstance(); prefs.clear();

  // await Firebase.initializeApp();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  // runApp(MyApp2());
  runApp(MyApp(settingsController: settingsController));
}
