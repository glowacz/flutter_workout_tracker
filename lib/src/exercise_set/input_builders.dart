import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/exercise_set/other_widget_builders.dart';
import 'package:flutter_workout_tracker/src/exercise_set/worker_methods.dart';
import 'package:flutter_workout_tracker/src/formatters.dart';
import 'package:flutter_workout_tracker/src/exercise_set/exercise_set_recorder.dart';

extension ExerciseSetRecorderStateInputBuilders on ExerciseSetRecorderState {
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
                weight -= increment;
                weightController.text = formatDouble(weight);
                // setState(() {
                //   weight -= increment;
                //   weightController.text = formatDouble(weight);
                // });
              },
              color: Colors.red,
            ),
            const SizedBox(width: 8.0),
            SizedBox(
              width: 95,
              child: TextFormField(
                focusNode: weightFocusNode,
                textInputAction: TextInputAction.go,
                // autofocus: true,
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}$'))],
                inputFormatters: [DoubleTextFormatterInput()],
                onChanged: (value) {
                  weight = double.tryParse(value) ?? 0.0;
                  // setState(() {
                  //   weight = double.tryParse(value) ?? 0.0;
                  // });
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) {
                  // print('submitted');
                  repsFocusNode.requestFocus();
                },
              ),
            ),
            const SizedBox(width: 8.0),
            buildIconButton(
              icon: Icons.add,
              onPressed: () {
                weight += increment;
                weightController.text = formatDouble(weight);
                // setState(() {
                //   weight += increment;
                //   weightController.text = formatDouble(weight);
                // });
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
                reps = reps >= 2 ? reps - 1 : reps;
                repsController.text = '$reps';
                // setState(() {
                //   reps = reps >= 2 ? reps - 1 : reps;
                //   repsController.text = '$reps';
                // });
              },
              color: Colors.red,
            ),
            const SizedBox(width: 8.0),
            SizedBox(
              width: 80.0, // Adjust the width as needed
              child: TextFormField(
                controller: repsController,
                focusNode: repsFocusNode,
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  reps = int.tryParse(value) ?? 0;
                  // setState(() {
                  //   reps = int.tryParse(value) ?? 0;
                  // });
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) {
                  selectedCardIndex == -1 ? saveSet() : saveSetEdit();
                  selectedCardIndex = -1;
                  // setState(() {
                  //   selectedCardIndex = -1;
                  // });
                },
              ),
            ),
            const SizedBox(width: 8.0),
            buildIconButton(
              icon: Icons.add,
              onPressed: () {
                reps += 1;
                repsController.text = '$reps';
                // setState(() {
                //   reps += 1;
                //   repsController.text = '$reps';
                // });
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
              tmpRestTime -= 10;
              timeController.text = '$tmpRestTime';
              // setState(() {
              //   tmpRestTime -= 10;
              //   timeController.text = '$tmpRestTime';
              // });
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
            focusNode: timeFocusNode,
            controller: timeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$'))],
            onChanged: (value) {
              tmpRestTime = int.tryParse(value) ?? 1;
              // setState(() {
              //   tmpRestTime = int.tryParse(value) ?? 1;
              // });
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(),
            ),
            onFieldSubmitted: (_) {
              saveTime();
              Navigator.of(context).pop();
            }
          ),
        ),
        const SizedBox(width: 16.0),
        buildIconButton(
          icon: Icons.add,
          onPressed: () {
            tmpRestTime += 10;
            timeController.text = '$tmpRestTime';
            // setState(() {
            //   tmpRestTime += 10;
            //   timeController.text = '$tmpRestTime';
            // });
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
                    tmpIncrement -= 0.5;
                    incrementController.text = '$tmpIncrement';
                    // setState(() {
                    //   tmpIncrement -= 0.5;
                    //   incrementController.text = '$tmpIncrement';
                    // });
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
                  focusNode: incrementFocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}$'))],
                  onChanged: (value) {
                    tmpIncrement = double.tryParse(value) ?? increment;
                    // setState(() {
                    //   tmpIncrement = double.tryParse(value) ?? increment;
                    // });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (_) {
                    saveIncrement();
                    Navigator.of(context).pop();
                  }
                ),
              ),
              const SizedBox(width: 16.0),
              buildIconButton(
                icon: Icons.add,
                onPressed: () {
                  tmpIncrement += 0.5;
                  incrementController.text = '$tmpIncrement';
                  // setState(() {
                  //   tmpIncrement += 0.5;
                  //   incrementController.text = '$tmpIncrement';
                  // });
                },
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }
}