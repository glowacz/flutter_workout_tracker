import 'package:flutter/material.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_parts_list_view.dart';

// Define a custom Form widget.
class AddBodyPartForm extends StatefulWidget {
  const AddBodyPartForm({super.key});

  static const routeName = '/add_body_part';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add body part'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Add TextFormFields and ElevatedButton here.
              TextFormField(
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
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${_exerciseName!} added')),
                    );

                    bodyParts.add(BodyPart(name: _exerciseName!, exercises: []));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BodyPartListView(bodyParts: bodyParts),
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        )
      )
    );
  }
}