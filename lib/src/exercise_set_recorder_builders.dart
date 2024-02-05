import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/line_chart_example.dart';
import 'package:intl/intl.dart';
import 'package:flutter_workout_tracker/src/exercise_set_recorder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';

import 'line_titles.dart';

extension ExerciseSetRecorderStateExtensions on ExerciseSetRecorderState {
  Widget buildHistoryTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
          // const Text(
            'History:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          buildHistory(),
        ],
      ),
    );
  }

  Widget buildGraphTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Weight graph:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Expanded(
            child:
              LineChart(mainData())
          )
        ],
      )
    );
  }

  Widget buildWeightInput() {
    return Row(
      children: [
        Text('Weight (kg):', style: style),
        const SizedBox(width: 48.0),
        buildIconButton(
          icon: Icons.remove,
          onPressed: () {
            setState(() {
              weight -= 2.5;
              weightController.text = '$weight';
            });
          },
          color: Colors.red,
        ),
        const SizedBox(width: 16.0),
        SizedBox(
          width: 80.0, // Adjust the width as needed
          child: TextField(
            controller: weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$'))],
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
        const SizedBox(width: 16.0),
        buildIconButton(
          icon: Icons.add,
          onPressed: () {
            setState(() {
              weight += 2.5;
              weightController.text = '$weight';
            });
          },
          color: Colors.green,
        ),
      ],
    );
  }

  Widget buildRepsInput() {
    return Row(
      children: [
        Text('Reps:', style: style),
        const SizedBox(width: 48.0),
        buildIconButton(
          icon: Icons.remove,
          onPressed: () {
            setState(() {
              reps -= 1;
              repsController.text = '$reps';
            });
          },
          color: Colors.red,
        ),
        const SizedBox(width: 16.0),
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
        const SizedBox(width: 16.0),
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
    );
  }

    Widget buildTimeInput() {
    return Row(
      children: [
        Text('Rest time:', style: style),
        const SizedBox(width: 48.0),
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

  Widget buildRecordedSets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: recordedSets1
          .map(
            (set) => Card(
              child: ListTile(
                // title: Text("${set.dateTime.toString()}:   ${set.weight.toString()} kg"),
                title: Text("${set.dateTime.toString()}: ${set.weight.toString()} kg | ${set.reps.toString()} reps"),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget buildHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: history
          .map(
            (set) => Card(
              child: ListTile(
                // title: Text("${set.dateTime.toString()}:   ${set.weight.toString()} kg"),
                // title: Text("${set.weight.toString()} kg"),
                title: Text("${DateFormat('yyyy-MM-dd').format(set.dateTime)}:\n${set.weight.toString()} kg | ${set.reps.toString()} reps"),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget buildGraph() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [LineChart(mainData())]
    );
  }

  LineChartData mainData() {
    final List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    return LineChartData(
      minX: 0,
      maxX: history.length.toDouble() - 1,
      minY: history == null || history.isEmpty ? 1 : max(history.reduce((curr, next) => curr.weight < next.weight ? curr : next).weight - 10, 0),
      // maxY: 6,
      // titlesData: LineTitles.getTitleData(),
      gridData: FlGridData(
        show: true,
        horizontalInterval: 2.5,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        drawVerticalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      titlesData: LineTitles(history: history).getTitleData(),
      lineBarsData: [
        LineChartBarData(
          spots: history.mapIndexed((index, set) => FlSpot(
              // set.dateTime.minute.toDouble(),
              index.toDouble(),
              set.weight)
          ).toList(),
          isCurved: false,
          // colors: gradientColors,
          barWidth: 5,
          // dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
              show: true,
              color: gradientColors[0].withOpacity(0.3)
          ),
        ),
      ],
    );
  }
}