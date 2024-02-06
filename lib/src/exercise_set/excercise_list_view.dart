import 'package:flutter/material.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import './exercise_set_recorder.dart';

class ExerciseListView extends StatelessWidget {
  final BodyPart bodyPart;

  const ExerciseListView({super.key, required this.bodyPart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${bodyPart.name} - Exercises"),
      ),
      body: ListView.builder(
        itemCount: bodyPart.exercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(bodyPart.exercises[index].name),
            // Add more details or actions as needed
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseSetRecorder(exercise: bodyPart.exercises[index])
                )
              );
            },
          );
        },
      ),
    );
  }
}
