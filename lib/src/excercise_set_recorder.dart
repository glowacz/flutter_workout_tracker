import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/exercise_set_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ExerciseSetRecorder extends StatefulWidget {
  final Exercise exercise;

  const ExerciseSetRecorder({super.key, required this.exercise});

  @override
  _ExerciseSetRecorderState createState() => _ExerciseSetRecorderState();
}

class _ExerciseSetRecorderState extends State<ExerciseSetRecorder> {
  double weight = 0.0;
  int reps = 0;
  List<ExerciseSet> recordedSets1 = [];
  List<String> recordedSets = [];
  List<String> history = [];
  
  final style = const TextStyle(fontSize: 24.0);
  // const _ExerciseSetRecorderState({super.key, required this.exercise});

  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    weightController.text = '$weight';
    repsController.text = '$reps';
    _loadHistory();
  }

 @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.exercise.name} - Recording'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Record'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRecordTab(),
            _buildHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildWeightInput(),
          _buildRepsInput(),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _saveSet,
            child: Text('Save'),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Recorded Sets:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          _buildRecordedSets(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
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
          _buildHistory(),
        ],
      ),
    );
  }

  Widget _buildWeightInput() {
    return Row(
      children: [
        Text('Weight (kg):', style: style),
        const SizedBox(width: 48.0),
        _buildIconButton(
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
        Container(
          width: 80.0, // Adjust the width as needed
          child: TextField(
            controller: weightController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$'))],
            onChanged: (value) {
              setState(() {
                weight = double.tryParse(value) ?? 0.0;
              });
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        _buildIconButton(
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

  Widget _buildRepsInput() {
    return Row(
      children: [
        Text('Reps:', style: style),
        const SizedBox(width: 48.0),
        _buildIconButton(
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
        Container(
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
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        _buildIconButton(
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

  Widget _buildIconButton({
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

  Widget _buildRecordedSets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: recordedSets
          .map(
            (set) => Card(
              child: ListTile(
                title: Text(set),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: history
          .map(
            (set) => Card(
              child: ListTile(
                title: Text(set),
              ),
            ),
          )
          .toList(),
    );
  }

  void _saveSet() async{
    if (weight > 0 && reps > 0) {
      String setInfo = 'Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}\n'
          'Weight: $weight kg, Reps: $reps';
      ExerciseSet setInfo1 = ExerciseSet(exercise: widget.exercise, 
      weight: weight, reps: reps, dateTime: DateTime.now());
      
      setState(() {
        recordedSets.add(setInfo);
      });

      setState(() {
        recordedSets1.add(setInfo1);
      });

      history.add(setInfo);
      await _saveHistory();
    }
  }

  void _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // history = prefs.getStringList('history') ?? [];
      history = prefs.getStringList(widget.exercise.name) ?? [];
    });
  }

  Future<void> _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setStringList('history', history);
    await prefs.setStringList(widget.exercise.name, history);

    // final docSet = FirebaseFirestore.instance.collection('RecordedSets').doc();

    // final jsonSet = {
    //   'weight': weight,
    //   'reps': reps,
    //   'exercise': widget.exercise.name,
    //   'date': DateTime.now(),
    // };

    // await docSet.set(jsonSet);
  }
}