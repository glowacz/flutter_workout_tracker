// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/exercise_set_recorder_builders.dart';
import 'package:flutter_workout_tracker/src/exercise_set_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class ExerciseSetRecorder extends StatefulWidget {
  final Exercise exercise;

  const ExerciseSetRecorder({super.key, required this.exercise});

  @override
  ExerciseSetRecorderState createState() => ExerciseSetRecorderState();
}

class ExerciseSetRecorderState extends State<ExerciseSetRecorder> {
  AudioPlayer? audioPlayer;
  int tmpRestTime = 1;
  int restTime = 1;
  String r = "";
  double weight = 0.0;
  int reps = 0;
  List<ExerciseSet> recordedSets1 = [];
  List<ExerciseSet> history = [];
  
  final style = const TextStyle(fontSize: 24.0);
  // const _ExerciseSetRecorderState({super.key, required this.exercise});

  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHistory();
    audioPlayer = AudioPlayer();
  }

 @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('${widget.exercise.name} - Recording'),
              const SizedBox(width: 80),
              buildIconButton(icon: Icons.timer_sharp, color: Colors.blue, 
                onPressed: ()  {
                  setState(() {
                    tmpRestTime = restTime;
                    timeController.text = '$tmpRestTime';
                  });
                  // tmpRestTime = restTime;
                      // setState(() {
                      //   tmpRestTime = restTime;
                      // });
                  showDialog(context: context, builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Edit'),
                      content: buildTimeInput(),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            setState(() {
                              tmpRestTime = restTime;
                              timeController.text = '$tmpRestTime';
                            });
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            _saveTime();
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  });
                }
              ),
            ],
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Record'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildRecordTab(),
            buildHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget buildRecordTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildWeightInput(),
          buildRepsInput(),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _saveSet,
            child: Text('Save'),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Recorded Sets:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          buildRecordedSets(),
        ],
      ),
    );
  }

  Future<void> playBeepSound() async {
    await Future.delayed(Duration(seconds: restTime));
    UrlSource src = UrlSource('assets/beep.mp3');
    await audioPlayer!.play(src);
  }

  void _saveSet() async{
    if (weight > 0 && reps > 0) {
      // String setInfo = 'Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}\n'
      //     'Weight: $weight kg, Reps: $reps';
      playBeepSound();
      ExerciseSet setInfo1 = ExerciseSet( //exercise: widget.exercise, 
      // weight: weight, reps: reps);
      weight: weight, reps: reps, dateTime: DateTime.now());
      
      // setState(() {
      //   recordedSets.add(setInfo);
      // });

      setState(() {
        recordedSets1.add(setInfo1);
      });

      // history.add(setInfo);
      history.add(setInfo1);
      await _saveHistory();
    }
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // history = prefs.getStringList('history') ?? [];
      var historyHelp = prefs.getString(widget.exercise.name) ?? "";
      history = historyHelp.isNotEmpty ? ExerciseSet.decode(historyHelp) : [];

      weight = history.isNotEmpty ? (history[0].weight) : 0;
      reps = history.isNotEmpty ? (history[0].reps) : 0;
      weightController.text = '$weight';
      repsController.text = '$reps';

      var savedTime = prefs.getInt("${widget.exercise.name}/time") ?? 1;
      restTime = savedTime;
      timeController.text = '$restTime';
    });
  }

  Future<void> _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.exercise.name, ExerciseSet.encode(history));

    // final docSet = FirebaseFirestore.instance.collection('RecordedSets').doc();

    // final jsonSet = {
    //   'weight': weight,
    //   'reps': reps,
    //   'exercise': widget.exercise.name,
    //   'date': DateTime.now(),
    // };

    // await docSet.set(jsonSet);
  }

  Future<void> _saveTime() async {
    setState(() {
      restTime = tmpRestTime;
    });
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("${widget.exercise.name}/time", restTime);
  }
}