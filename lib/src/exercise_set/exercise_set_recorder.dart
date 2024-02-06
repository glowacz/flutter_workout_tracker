// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/chart/chart_builders.dart';
import 'package:flutter_workout_tracker/src/exercise_set/exercise_set_recorder_builders.dart';
import 'package:flutter_workout_tracker/src/exercise_set/exercise_set_model.dart';
import 'package:flutter_workout_tracker/src/formatters.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void initState() {
    super.initState();
    _loadHistory();
    audioPlayer = AudioPlayer();
  }

 @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          selectedCardIndex = -1;
        });
      },
      child: DefaultTabController(
        length: 3, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  // flex: 1,
                  child: Text(
                    '${widget.exercise.name} - Recording',
                    overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                  ),
                ),
                // const SizedBox(width: 80),
                Row(
                  children: [
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

  Future<void> playBeepSound() async {
    await Future.delayed(Duration(seconds: restTime));
    AssetSource src = AssetSource('beep.mp3');
    await audioPlayer!.play(src);
  }

  void _saveSet() async{
    FocusScope.of(context).unfocus();
    if (reps > 0) {
      playBeepSound();

      ExerciseSet setInfo1 = ExerciseSet(weight: weight, reps: reps, dateTime: DateTime.now());

      setState(() {
        recordedSets1.add(setInfo1);
      });

      history.add(setInfo1);
      await _saveHistory();
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reps should be more than 0!')),
      );
    }
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var historyHelp = prefs.getString(widget.exercise.name) ?? "";
      history = historyHelp.isNotEmpty ? ExerciseSet.decode(historyHelp) : [];
      weight = history.isNotEmpty ? (history[history.length - 1].weight) : 0;
      reps = history.isNotEmpty ? (history[history.length - 1].reps) : 1;
      weightController.text = formatDouble(weight);
      repsController.text = '$reps';

      var savedTime = prefs.getInt("${widget.exercise.name}/time") ?? 1;
      restTime = savedTime;
      timeController.text = '$restTime';
      var savedIncrement = prefs.getDouble("${widget.exercise.name}/increment") ?? 2.5;
      increment = savedIncrement;
      incrementController.text = '$increment';
    });

    setState(() {
      for(var set in history) {
        if(set.dateTime.day == DateTime.now().day && set.dateTime.month == DateTime.now().month && set.dateTime.year == DateTime.now().year){
          recordedSets1.add(set);
        }
      }
    });
  }

  Future<void> _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.exercise.name, ExerciseSet.encode(history));
  }

  Future<void> _saveTime() async {
    setState(() {
      restTime = tmpRestTime;
    });
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("${widget.exercise.name}/time", restTime);
  }

  Future<void> _saveIncrement() async {
    setState(() {
      increment = tmpIncrement;
    });
  
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("${widget.exercise.name}/increment", increment);
  }

  Widget timerButton(BuildContext context) {
    return buildIconButton(icon: Icons.timer_sharp, color: Colors.blue, 
      onPressed: ()  {
        setState(() {
          tmpRestTime = restTime;
          timeController.text = '$tmpRestTime';
        });

        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: const Text('Edit rest time')),
            content: buildTimeInput(),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
              ),
            ],
          );
        });
      }
    );
  }

  Widget settingsButton(BuildContext context) {
    return buildIconButton(icon: Icons.settings, color: Colors.blue, 
      onPressed: ()  {
        setState(() {
          tmpIncrement = increment;
          incrementController.text = '$tmpIncrement';
        });
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: const Text('Edit increment')),
            content: buildIncrementInput(), //tmpIncrementtmpIncrementtmpIncrementtmpIncrementtmpIncrement
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        tmpIncrement = increment;
                        incrementController.text = '$tmpIncrement';
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _saveIncrement();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          );
        });
      }
    );
  }

  Widget buildWeightReps(){
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Center(child: buildWeightInput(),),
        // Center(child: buildRepsInput(),),
        buildWeightInput(),
        const SizedBox(height: 16.0),
        buildRepsInput(),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _saveSet,
          child: const Text('Save'),
        )
    ]);
  }

  Widget buildRecordTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // buildWeightReps(),
            buildWeightInput(),
            const SizedBox(height: 16.0),
            buildRepsInput(),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveSet,
              child: const Text('Save'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Recorded Sets:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            buildRecordedSets(),
          ],
        ),
      )
    );
  }

  Widget buildRecordedSets() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: recordedSets1
        .mapIndexed(
          (index, set) => Card(
            child: GestureDetector(
              onTap: () {
                // Toggle the tapped state of the card
                setState(() {
                  selectedCardIndex = index;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      "${index + 1}: ${DateFormat.Hm().format(set.dateTime)} | ${formatDouble(set.weight)} kg | ${set.reps.toString()} ${set.reps >= 2 ? 'reps' : 'rep'}",
                    ),
                  ),
                  // Render Save and Cancel buttons if the card is selected
                  if (selectedCardIndex == index)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle Save button action
                            print('Save');
                          },
                          child: Text('Save'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Handle Cancel button action
                            setState(() {
                              bool ret = history.remove(recordedSets1[selectedCardIndex]);
                              // print('Removed from history? ${ret}');
                              ret = recordedSets1.remove(recordedSets1[selectedCardIndex]);
                              // print('Removed from recordedSets1? ${ret}');
                              selectedCardIndex = -1; // Reset selected card
                            });
                            await _saveHistory();
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        )
        .toList(),
  );
}
}