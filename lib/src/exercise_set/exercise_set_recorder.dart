import 'dart:async';

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
  Timer? timer;
  int tmpRestTime = 1, restTime = 1;
  int elapsedRestTime = 1;
  bool timerWorking = false;
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
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    // print('rebuild');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        // FocusManager.instance.primaryFocus?.unfocus();
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
                    if(elapsedRestTimeGlobal != 0)
                      Text('|$elapsedRestTime')
                    else
                      timerButton(context),
                    const SizedBox(width: 4,),
                    // timerButton(context),
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
                            "${index + 1}: ${DateFormat.Hm().format(set.dateTime)} " 
                            "| ${formatDouble(set.weight)} kg | ${set.reps.toString()} ${repsOrRep(set)}"
                             "${selectedCardIndex == index ? '\nDelete or edit this set' : ''}",
                          ),
                        ),
                        // if (selectedCardIndex == index)
                        //   ListTile(
                        //     title: Text(
                        //       'Delete or edit this set',
                        //     ),
                        //   ),
                          // const Row(
                          //   // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: [
                          //     Padding(
                          //       padding: EdgeInsets.only(bottom: 20),
                          //       child: 
                          //         Text(
                          //           'Delete or edit this set', 
                          //           style: TextStyle(fontSize: 16),
                          //         ),
                          //     ),
                          //   ],
                          // ),
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