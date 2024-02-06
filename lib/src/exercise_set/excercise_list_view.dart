import 'package:flutter/material.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/exercise_set/add_exercise_form.dart';
import 'package:flutter_workout_tracker/src/prefs.dart';
import 'package:flutter_workout_tracker/src/settings/settings_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './exercise_set_recorder.dart';
import 'package:collection/collection.dart';

class ExerciseListView extends StatefulWidget {
  BodyPart bodyPart;

  ExerciseListView({super.key, required this.bodyPart});

  @override
  State<ExerciseListView> createState() => _ExerciseListViewState();
}

class _ExerciseListViewState extends State<ExerciseListView> {
  @override
  Widget build(BuildContext context) {
    // print("rebuild");
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.bodyPart.name} - Exercises"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context) {
                return AddExerciseForm(bodyPartName: widget.bodyPart.name); 
              })
                .then((value) async {
                  // SharedPreferences prefs = await SharedPreferences.getInstance();
                  // var bodyPartListHelp = prefs.getString('body_parts') ?? "";
                  // List<BodyPart> bodyPartList = bodyPartListHelp.isNotEmpty ? BodyPart.decode(bodyPartListHelp) : [];
                  // BodyPart bodyPart = bodyPartList.firstWhere((element) => element.name == widget.bodyPart.name);
                  BodyPart bodyPart = await GetBodyPart(widget.bodyPart.name);
                  setState( () {
                    print(value);
                    widget.bodyPart = bodyPart; 
                  });
                });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children:
          widget.bodyPart.exercises.mapIndexed((index, element) => 
            ListTile(
              title: Text(widget.bodyPart.exercises[index].name),
              // Add more details or actions as needed
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseSetRecorder(exercise: widget.bodyPart.exercises[index])
                  )
                );
              },
            )
          ).toList(),
        )
      ),
    );
  }
}
