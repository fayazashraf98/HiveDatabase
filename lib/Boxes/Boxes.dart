import 'package:hive/hive.dart';
import 'package:hive_database/Models/notes_models.dart';

class Boxes {
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}
