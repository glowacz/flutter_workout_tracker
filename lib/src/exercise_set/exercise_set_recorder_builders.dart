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
              child: TextField(
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
              child: TextField(
                controller: repsController,
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
          width: 80.0, // Adjust the width as needed
          child: TextField(
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
                child: TextField(
                  controller: incrementController,
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

  // Widget buildRecordedSets() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: recordedSets1
  //         .mapIndexed(
  //           (index, set) => Card(
  //             child: ListTile(
  //               title: Text("${index + 1}: ${DateFormat.Hm().format(set.dateTime)} | ${formatDouble(set.weight)} kg | ${set.reps.toString()} ${set.reps >= 2 ? 'reps' : 'rep'}"),
  //               onTap: () {
  //                 print('tap');
  //               },
  //             ),
  //           ),
  //         )
  //         .toList(),
  //   );
  // }

}