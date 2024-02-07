// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final FocusNode _weightFocusNode = FocusNode();
  final FocusNode _repsFocusNode = FocusNode();
  final FocusNode _timeFocusNode = FocusNode();
  final FocusNode _incrementFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initFocusNodes();
    _loadHistory();
    _weightFocusNode.requestFocus();
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

  Future<void> playBeepSound() async {
    await Future.delayed(Duration(seconds: restTime));
    AssetSource src = AssetSource('beep.mp3');
    await audioPlayer!.play(src);
  }

  void _saveSet() async{
    FocusScope.of(context).unfocus();
    if (reps > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Set saved')),
      );

      // if(selectedCardIndex == -1) 
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

  void _saveSetEdit() async{
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved')),
    );
    FocusScope.of(context).unfocus();
    // selectedCardIndex = -1;
    if (reps > 0) {
      var oldSet = recordedSets1[selectedCardIndex];
      ExerciseSet setInfo1 = ExerciseSet(weight: weight, reps: reps, dateTime: oldSet.dateTime);
      int indexInHistory = history.indexWhere((element) => element == oldSet);
      // ExerciseSet setInHistory = history.firstWhere((element) => element == oldSet);
      history[indexInHistory] = setInfo1;
      setState(() {
        recordedSets1[selectedCardIndex] = setInfo1;
      });

      await _saveHistory();
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reps should be more than 0!')),
      );
    }
  }

  void _initFocusNodes(){
    _weightFocusNode.addListener(() {
      if (_weightFocusNode.hasFocus) {
        weightController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: weightController.text.length,
        );
      }
    });

    _repsFocusNode.addListener(() {
      if (_repsFocusNode.hasFocus) {
        repsController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: repsController.text.length,
        );
      }
    });

    _timeFocusNode.addListener(() {
      if (_timeFocusNode.hasFocus) {
        timeController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: timeController.text.length,
        );
      }
    });

    _incrementFocusNode.addListener(() {
      if (_incrementFocusNode.hasFocus) {
        incrementController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: incrementController.text.length,
        );
      }
    });
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
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _saveTime();
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

  Widget buildRecordTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // buildWeightReps(),
          buildWeightInput(),
          const SizedBox(height: 16.0),
          buildRepsInput(),
          const SizedBox(height: 16.0),
          if(selectedCardIndex == -1)
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
      )
    );
  }

  Widget buildWeightInput() {
    return Column(
      children: [
        Text('Weight (kg):', style: style),
        // const SizedBox(width: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          children: [
            buildIconButton(
              icon: Icons.remove,
              onPressed: () {
                setState(() {
                  weight -= increment;
                  weightController.text = formatDouble(weight);
                  // weightController.text = '$weight';
                });
              },
              color: Colors.red,
            ),
            const SizedBox(width: 8.0),
            SizedBox(
              width: 95,
              child: TextFormField(
                focusNode: _weightFocusNode,
                textInputAction: TextInputAction.go,
                // autofocus: true,
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}$'))],
                inputFormatters: [DoubleTextFormatterInput()],
                onChanged: (value) {
                  setState(() {
                    weight = double.tryParse(value) ?? 0.0;
                  });
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) {
                  // print('submitted');
                  _repsFocusNode.requestFocus();
                },
              ),
            ),
            const SizedBox(width: 8.0),
            buildIconButton(
              icon: Icons.add,
              onPressed: () {
                setState(() {
                  weight += increment;
                  weightController.text = formatDouble(weight);
                  // weightController.text = '$weight';
                });
              },
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRepsInput() {
    return Column(
      children: [
        Text('Reps:', style: style),
        // const SizedBox(width: 48.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildIconButton(
              icon: Icons.remove,
              onPressed: () {
                setState(() {
                  reps = reps >= 2 ? reps - 1 : reps;
                  repsController.text = '$reps';
                });
              },
              color: Colors.red,
            ),
            const SizedBox(width: 8.0),
            SizedBox(
              width: 80.0, // Adjust the width as needed
              child: TextFormField(
                controller: repsController,
                focusNode: _repsFocusNode,
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  setState(() {
                    reps = int.tryParse(value) ?? 0;
                  });
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) {
                  selectedCardIndex == -1 ? _saveSet() : _saveSetEdit();
                  setState(() {
                    selectedCardIndex = -1;
                  });
                },
              ),
            ),
            const SizedBox(width: 8.0),
            buildIconButton(
              icon: Icons.add,
              onPressed: () {
                setState(() {
                  reps += 1;
                  repsController.text = '$reps';
                });
              },
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTimeInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text('Rest time:', style: style),
        // const SizedBox(width: 48.0),
        buildIconButton(
          icon: Icons.remove,
          onPressed: () {
            if(tmpRestTime - 10 > 0){
              setState(() {
                tmpRestTime -= 10;
                timeController.text = '$tmpRestTime';
              });
            }
          },
          color: Colors.red,
        ),
        const SizedBox(width: 16.0),
        SizedBox(
          width: 80.0,
          child: TextFormField(
            autofocus: true,
            textInputAction: TextInputAction.send,
            focusNode: _timeFocusNode,
            controller: timeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$'))],
            onChanged: (value) {
              setState(() {
                tmpRestTime = int.tryParse(value) ?? 1;
              });
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(),
            ),
            onFieldSubmitted: (_) {
              _saveTime();
              Navigator.of(context).pop();
            }
          ),
        ),
        const SizedBox(width: 16.0),
        buildIconButton(
          icon: Icons.add,
          onPressed: () {
            setState(() {
              tmpRestTime += 10;
              timeController.text = '$tmpRestTime';
            });
          },
          color: Colors.green,
        ),
      ],
    );
  }

  Widget buildIncrementInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text('Increment:', style: style),
        // // const SizedBox(width: 48.0),
        // const SizedBox(height: 8),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIconButton(
                icon: Icons.remove,
                onPressed: () {
                  if(tmpIncrement - 0.5 > 0){
                    setState(() {
                      tmpIncrement -= 0.5;
                      incrementController.text = '$tmpIncrement';
                    });
                  }
                },
                color: Colors.red,
              ),
              const SizedBox(width: 16.0),
              SizedBox(
                width: 80.0, // Adjust the width as needed
                child: TextFormField(
                  autofocus: true,
                  textInputAction: TextInputAction.send,
                  controller: incrementController,
                  focusNode: _incrementFocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}$'))],
                  onChanged: (value) {
                    setState(() {
                      tmpIncrement = double.tryParse(value) ?? increment;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (_) {
                    _saveIncrement();
                    Navigator.of(context).pop();
                  }
                ),
              ),
              const SizedBox(width: 16.0),
              buildIconButton(
                icon: Icons.add,
                onPressed: () {
                  setState(() {
                    tmpIncrement += 0.5;
                    incrementController.text = '$tmpIncrement';
                  });
                },
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
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
                      _weightFocusNode.requestFocus();
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
                                    bool ret = history.remove(recordedSets1[selectedCardIndex]);
                                    // print('Removed from history? ${ret}');
                                    ret = recordedSets1.remove(recordedSets1[selectedCardIndex]);
                                    // print('Removed from recordedSets1? ${ret}');
                                    selectedCardIndex = -1;
                                  });
                                  FocusScope.of(context).unfocus();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Set deleted')),
                                  );
                                  await _saveHistory();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 100, 0, 0)
                                  // backgroundColor: const Color(0xFFB74093)
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
                                    _saveSetEdit();
                                    selectedCardIndex = -1;
                                  });
                                  await _saveHistory();
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