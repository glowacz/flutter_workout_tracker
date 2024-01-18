import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';

class ExerciseSet{
  Exercise exercise;
  double weight;
  int reps;
  DateTime dateTime;

  ExerciseSet({required this.exercise, this.weight = 0, this.reps = 0, required this.dateTime});
}