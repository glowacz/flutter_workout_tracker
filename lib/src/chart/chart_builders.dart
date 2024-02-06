import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_workout_tracker/src/exercise_set/exercise_set_recorder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
import 'line_titles.dart';

extension ExerciseSetRecorderStateExtensions on ExerciseSetRecorderState {
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