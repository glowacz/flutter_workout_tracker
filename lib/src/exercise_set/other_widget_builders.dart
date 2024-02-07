import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/exercise_set/input_builders.dart';
import 'package:flutter_workout_tracker/src/exercise_set/worker_methods.dart';
import 'package:flutter_workout_tracker/src/formatters.dart';
import 'package:intl/intl.dart';
import 'package:flutter_workout_tracker/src/exercise_set/exercise_set_recorder.dart';
// import 'package:collection/collection.dart';

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

  Widget timerButton(BuildContext context) {
    return buildIconButton(icon: Icons.timer_sharp, color: Colors.blue, 
      onPressed: ()  {
        tmpRestTime = restTime;
        timeController.text = '$tmpRestTime';
        // setState(() {
        //   tmpRestTime = restTime;
        //   timeController.text = '$tmpRestTime';
        // });

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
                      tmpRestTime = restTime;
                      timeController.text = '$tmpRestTime';
                      // setState(() {
                      //   tmpRestTime = restTime;
                      //   timeController.text = '$tmpRestTime';
                      // });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      saveTime();
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
        tmpIncrement = increment;
        incrementController.text = '$tmpIncrement';
        // setState(() {
        //   tmpIncrement = increment;
        //   incrementController.text = '$tmpIncrement';
        // });
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
                      tmpIncrement = increment;
                      incrementController.text = '$tmpIncrement';
                      // setState(() {
                      //   tmpIncrement = increment;
                      //   incrementController.text = '$tmpIncrement';
                      // });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      saveIncrement();
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
              onPressed: saveSet,
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
}