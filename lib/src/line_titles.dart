import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'exercise_set_model.dart';

class LineTitles {
  List<ExerciseSet> history = [];

  LineTitles({required this.history});

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text = Text("${DateFormat('yyyy-MM-dd \n HH:mm:ss').format(history[value.toInt()].dateTime)}", style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  getTitleData() {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 2.5,
          reservedSize: 62
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        axisNameWidget: const Text(
          'Date and time',
          textAlign: TextAlign.left,
        ),
        axisNameSize: 24,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 72,
          interval: 1,
          getTitlesWidget: bottomTitleWidgets,
        ),
      ),
      leftTitles: const AxisTitles(
        axisNameWidget: Text(
          'Weight (kg)',
          textAlign: TextAlign.left,
        ),
        axisNameSize: 24,
        sideTitles: SideTitles(
          showTitles: true,
          interval: 2.5,
          // getTitlesWidget: leftTitleWidgets,
          reservedSize: 62,
        ),
      ),
    );
  }
}