import 'package:flutter/material.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/body_parts/excercise_list_view.dart';
import 'package:flutter_workout_tracker/src/settings/settings_view.dart';

class BodyPartListView extends StatelessWidget {
  const BodyPartListView({
    super.key,
    required this.bodyParts
  });

  static const routeName = '/';

  final List<BodyPart> bodyParts;

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
        title: const Text('Body Parts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),

        ],
      ),
        body: ListView.builder(
          itemCount: bodyParts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(bodyParts[index].name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseListView(bodyPart: bodyParts[index]),
                  ),
                );
              },
            );
          }
        ),
      );
  }
}