import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_parts_list_view.dart';
import 'package:flutter_workout_tracker/src/formatters.dart';
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_exerciseName!} added')),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var bodyPartListHelp = prefs.getString('body_parts') ?? "";
      List<BodyPart> bodyPartList = bodyPartListHelp.isNotEmpty ? BodyPart.decode(bodyPartListHelp) : [];
      bodyPartList.add(BodyPart(name: _exerciseName!, exercises: []));
      
      await prefs.setString('body_parts', BodyPart.encode(bodyPartList));
      Navigator.of(context).pop();
    }
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
              textInputAction: TextInputAction.send,
              textCapitalization: TextCapitalization.words,
              inputFormatters: <TextInputFormatter>[
                UpperCaseTextFormatter()
              ],
              decoration: const InputDecoration(
                labelText: 'Body part name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (String? value) {
                _exerciseName = value;
              },
              onFieldSubmitted: (_) {
                _submitForm();
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            )
          ],
        ),
    );
  }
}