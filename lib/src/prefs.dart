import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<BodyPart> GetBodyPart(String name) async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var bodyPartListHelp = prefs.getString('body_parts') ?? "";
  List<BodyPart> bodyPartList = bodyPartListHelp.isNotEmpty ? BodyPart.decode(bodyPartListHelp) : [];
  BodyPart bodyPart = bodyPartList.firstWhere((element) => element.name == name);
  return bodyPart;
}