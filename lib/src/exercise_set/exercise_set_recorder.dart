import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/chart/chart_builders.dart';
import 'package:flutter_workout_tracker/src/exercise_set/other_widget_builders.dart';
import 'package:flutter_workout_tracker/src/exercise_set/exercise_set_model.dart';
import 'package:flutter_workout_tracker/src/exercise_set/worker_methods.dart';
import 'package:flutter_workout_tracker/src/formatters.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class ExerciseSetRecorder extends StatefulWidget {
  final Exercise exercise;

  const ExerciseSetRecorder({super.key, required this.exercise});

  @override
  ExerciseSetRecorderState createState() => ExerciseSetRecorderState();
}

class ExerciseSetRecorderState extends State<ExerciseSetRecorder> {
  int selectedCardIndex = -1;
  AudioPlayer? audioPlayer;
  int tmpRestTime = 1, restTime = 1;
  double tmpIncrement = 2.5, increment = 2.5;
  String r = "";
  double weight = 0.0;
  int reps = 1;
  List<ExerciseSet> recordedSets1 = [];
  List<ExerciseSet> history = [];
  
  final style = const TextStyle(fontSize: 24.0);
  // const _ExerciseSetRecorderState({super.key, required this.exercise});

  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController incrementController = TextEditingController();

  final FocusNode weightFocusNode = FocusNode();
  final FocusNode repsFocusNode = FocusNode();
  final FocusNode timeFocusNode = FocusNode();
  final FocusNode incrementFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initFocusNodes();
    loadHistory();
    weightFocusNode.requestFocus();
    audioPlayer = AudioPlayer();
  }

 @override
  Widget build(BuildContext context) {
    // print('rebuild');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          selectedCardIndex = -1;
        });
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    '${widget.exercise.name} - Recording',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // const SizedBox(width: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 4,),
                    timerButton(context),
                    const SizedBox(width: 4,),
                    settingsButton(context),
                    // const SizedBox(width: 30,),
                  ],
                )
              ],
            ),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Record'),
                Tab(text: 'History'),
                Tab(text: 'Graph'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              buildRecordTab(),
              buildHistoryTab(),
              buildGraphTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecordedSets() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: recordedSets1
              .mapIndexed(
                (index, set) => Card(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCardIndex = index;
                        weight = recordedSets1[selectedCardIndex].weight;
                        reps = recordedSets1[selectedCardIndex].reps;
                        weightController.text = formatDouble(weight);
                        repsController.text = reps.toString();
                      });
                      weightFocusNode.requestFocus();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            "${index + 1}: ${DateFormat.Hm().format(set.dateTime)} | ${formatDouble(set.weight)} kg | ${set.reps.toString()} ${set.reps >= 2 ? 'reps' : 'rep'}",
                          ),
                        ),
                        if (selectedCardIndex == index)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    history.remove(recordedSets1[selectedCardIndex]);
                                    recordedSets1.remove(recordedSets1[selectedCardIndex]);
                                    selectedCardIndex = -1;
                                  });
                                  FocusScope.of(context).unfocus();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Set deleted')),
                                  );
                                  await saveHistory();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 100, 0, 0)
                                ),
                                child: 
                                  const Text('Delete set', 
                                    style: TextStyle(color: Colors.white 
                                  )),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 0, 100, 0),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    saveSetEdit();
                                    selectedCardIndex = -1;
                                  });
                                  await saveHistory();
                                },
                                child: 
                                  const Text('Save changes', 
                                    style: TextStyle(color: Colors.white 
                                  )),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}