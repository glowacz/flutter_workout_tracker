import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_parts_list_view.dart';
import 'package:flutter_workout_tracker/src/formatters.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a custom Form widget.
class AddExerciseForm extends StatefulWidget {
  AddExerciseForm({super.key, required this.bodyPartName});

  String bodyPartName;

  @override
  AddExerciseFormState createState() {
    return AddExerciseFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class AddExerciseFormState extends State<AddExerciseForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  String? _exerciseName;
  late int _restTime;
  late double _increment;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    // return buildForm(context);
    return AlertDialog(
      title: const Center(child: Text('Add exercise')),
      content: buildForm(context),
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Add TextFormFields and ElevatedButton here.
            TextFormField(
              autofocus: true,
              // textInputAction: TextInputAction.go,
              textCapitalization: TextCapitalization.words,
              inputFormatters: <TextInputFormatter>[
                UpperCaseTextFormatter()
              ],
              decoration: const InputDecoration(
                labelText: 'Exercise name', // Label text goes here
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (String? value) {
                _exerciseName = value;
                // print('value: ${value}');
                // print('_exerciseName: ${_exerciseName}');
              },
            ),
            TextFormField(
              initialValue: '1',
              inputFormatters: <TextInputFormatter>[
                NumberTextFormatter()
              ],
              decoration: const InputDecoration(
                labelText: 'Rest time', // Label text goes here
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (String? value) {
                _restTime = int.tryParse(value!) ?? 1;
              },
            ),
            TextFormField(
              initialValue: '2.5',
              inputFormatters: <TextInputFormatter>[
                DoubleTextFormatter()
              ],
              decoration: const InputDecoration(
                labelText: 'Weight increments',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (String? value) {
                _increment = double.tryParse(value!) ?? 2.5;
              },
            ),
            const SizedBox(height: 30),
            // FormButtons(formKey: _formKey, exerciseName: _exerciseName ?? "Error"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Operation cancelled')),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${_exerciseName!} added')),
                      );

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var bodyPartListHelp = prefs.getString('body_parts') ?? "";
                      List<BodyPart> bodyPartList = bodyPartListHelp.isNotEmpty ? BodyPart.decode(bodyPartListHelp) : [];
                      BodyPart bodyPart = bodyPartList.firstWhere((element) => element.name == widget.bodyPartName);
                      bodyPart.exercises.add(Exercise(name: _exerciseName!));
                      
                      await prefs.setString('body_parts', BodyPart.encode(bodyPartList));
                      await prefs.setInt("$_exerciseName/time", _restTime);
                      await prefs.setDouble("$_exerciseName/increment", _increment);

                      setState(() {
                        bodyParts = bodyPartList;
                      });
                      
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            )
          ],
        ),
    );
  }
}