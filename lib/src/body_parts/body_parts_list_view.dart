import 'package:flutter/material.dart';
import 'package:flutter_workout_tracker/src/body_parts/add_body_part_form.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/exercise_set/excercise_list_view.dart';
import 'package:flutter_workout_tracker/src/settings/settings_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class BodyPartListView extends StatefulWidget {
  BodyPartListView({
    super.key,
    required this.bodyParts
  });

  static const routeName = '/';

  List<BodyPart> bodyParts;

  @override
  State<BodyPartListView> createState() { 
    return _BodyPartListViewState();
  }
}

class _BodyPartListViewState extends State<BodyPartListView> {
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bodyPartListHelp = prefs.getString('body_parts') ?? "";
    List<BodyPart> bodyPartList = bodyPartListHelp.isNotEmpty ? BodyPart.decode(bodyPartListHelp) : [];
    
    setState(() {
      widget.bodyParts = bodyPartList;
    });
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   widget.bodyParts = bodyParts;
    // });
    // initState();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Parts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context) {
                return AddBodyPartForm(); 
              })
              .then((value) async {
                  // print('exited form');
                  // SharedPreferences prefs = await SharedPreferences.getInstance();
                  // var bodyPartListHelp = prefs.getString('body_parts') ?? "";
                  // List<BodyPart> bodyPartList = bodyPartListHelp.isNotEmpty ? BodyPart.decode(bodyPartListHelp) : [];
                  setState( () {
                    widget.bodyParts = bodyParts;
                  });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children:
          widget.bodyParts.mapIndexed((index, bodyPart) => 
            ListTile(
              title: Text(widget.bodyParts[index].name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseListView(bodyPart: widget.bodyParts[index]),
                  ),
                ).then((value) => setState( () => widget.bodyParts = bodyParts ));
              },
            )
          ).toList(),
        ),
      )
    );
  }
}