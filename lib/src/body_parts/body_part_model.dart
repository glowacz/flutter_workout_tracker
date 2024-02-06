import 'dart:convert';

class BodyPart {
  String name;
  List<Exercise> exercises;

  BodyPart({required this.name, required this.exercises});

  factory BodyPart.fromJson(Map<String, dynamic> jsonData) {
    return BodyPart(
      name: jsonData['name'],
      exercises: Exercise.decode(jsonData['exercises']),
    );
  }

  static Map<String, dynamic> toMap(BodyPart bodyPart) => {
    'name': bodyPart.name,
    'exercises': Exercise.encode(bodyPart.exercises),
  };
  
  static String encode(List<BodyPart> bodyParts) => json.encode(
    bodyParts
        // .map<String>((set) => json.encode(set))
        .map<Map<String, dynamic>>((bodyPart) => toMap(bodyPart))
        .toList(),
  );

  static List<BodyPart> decode(String bodyParts) =>
      (json.decode(bodyParts) as List<dynamic>)
          .map<BodyPart>((item) => BodyPart.fromJson(item))
          .toList();
}

class Exercise {
  String name;

  Exercise({required this.name});

  factory Exercise.fromJson(Map<String, dynamic> jsonData) {
    return Exercise(
      name: jsonData['name'],
    );
  }

  static Map<String, dynamic> toMap(Exercise exercise) => {
    'name': exercise.name,
  };

  static String encode(List<Exercise> exercises) => json.encode(
    exercises
        // .map<String>((set) => json.encode(set))
        .map<Map<String, dynamic>>((exercise) => toMap(exercise))
        .toList(),
  );

  static List<Exercise> decode(String exercises) =>
      (json.decode(exercises) as List<dynamic>)
          .map<Exercise>((item) => Exercise.fromJson(item))
          .toList();
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
