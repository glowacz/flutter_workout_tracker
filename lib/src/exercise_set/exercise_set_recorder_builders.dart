import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/formatters.dart';
import 'package:intl/intl.dart';
import 'package:flutter_workout_tracker/src/exercise_set/exercise_set_recorder.dart';
import 'package:collection/collection.dart';

extension ExerciseSetRecorderStateExtensions on ExerciseSetRecorderState {
  Widget buildHistoryTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
            // const Text(
              'History:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            buildHistory(),
          ],
        ),
      )
    );
  }

  Widget buildHistory() {
    return Column(
      children:
      history.reversed.map(
            (set) => Card(
          child: ListTile(
            title: Text("${DateFormat('yyyy-MM-dd').format(set.dateTime)}:\n${formatDouble(set.weight)} kg | ${set.reps} ${set.reps >= 2 ? 'reps' : 'rep'}"),
          ),
        ),
      ).toList(),
    );
  }

  Widget buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}