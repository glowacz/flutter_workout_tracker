class BodyPart {
  String name;
  List<Exercise> exercises;

  BodyPart({required this.name, required this.exercises});
}

class Exercise {
  String name;

  Exercise({required this.name});
}

List<BodyPart> bodyParts = [
  BodyPart(
    name: 'Chest',
    exercises: [
      Exercise(name: 'Bench Press'),
      Exercise(name: 'Incline Press'),
      // Add more exercises for chest
    ],
  ),
  BodyPart(
    name: 'Back',
    exercises: [
      Exercise(name: 'Deadlift'),
      Exercise(name: 'Pull-ups'),
      // Add more exercises for back
    ],
  ),
  // Add more body parts and exercises as needed
];
