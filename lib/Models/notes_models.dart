import 'package:hive/hive.dart';
part 'notes_models.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String Desc;
  NotesModel({required this.title, required this.Desc});
}
