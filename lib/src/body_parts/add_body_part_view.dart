import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_parts_list_view.dart';
import 'package:flutter_workout_tracker/src/capitalization.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a custom Form widget.
class AddBodyPartForm extends StatefulWidget {
  const AddBodyPartForm({super.key});

  // static const routeName = '/add_body_part';

  @override
  AddBodyPartFormState createState() {
    return AddBodyPartFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class AddBodyPartFormState extends State<AddBodyPartForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  String? _exerciseName;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    // return buildForm(context);
    return AlertDialog(
      title: const Center(child: Text('Add body part')),
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
              textInputAction: TextInputAction.go,
              textCapitalization: TextCapitalization.words,
              inputFormatters: <TextInputFormatter>[
                UpperCaseTextFormatter()
              ],
              decoration: const InputDecoration(
                labelText: 'Body part name', // Label text goes here
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
            SizedBox(height: 30),
            // FormButtons(formKey: _formKey, exerciseName: _exerciseName ?? "Error"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      
                      // SharedPreferences prefs = await SharedPreferences.getInstance();
                      // var bodyPartList = prefs.getStringList('body_parts') ?? [];
                      bodyPartList.add(BodyPart(name: _exerciseName!, exercises: []));
                      
                      await prefs.setString('body_parts', BodyPart.encode(bodyPartList));
                      
                      setState(() {
                        bodyParts.add(BodyPart(name: _exerciseName!, exercises: []));
                      });
                      
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Operation cancelled')),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            )
          ],
        ),
    );
  }
}