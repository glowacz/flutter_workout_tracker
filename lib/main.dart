import 'package:flutter/material.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
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

  WidgetsFlutterBinding.ensureInitialized();

  await settingsController.loadSettings();
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.clear();
  var bodyPartListHelp = prefs.getString('body_parts') ?? "";
  if(bodyPartListHelp.isEmpty) {
    bodyParts.sort((a, b) => a.name.compareTo(b.name));
    await prefs.setString('body_parts', BodyPart.encode(bodyParts));
  }
  else {
    List<BodyPart> bodyPartList = bodyPartListHelp.isNotEmpty ? BodyPart.decode(bodyPartListHelp) : [];
    bodyParts = bodyPartList;
  }
  
  runApp(MyApp(settingsController: settingsController));
}
