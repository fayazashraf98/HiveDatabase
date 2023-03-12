import 'package:flutter/material.dart';
import 'package:hive_database/Models/notes_models.dart';
import 'package:hive_flutter/adapters.dart';

import '../Boxes/Boxes.dart';

class ModelViewPage extends StatefulWidget {
  const ModelViewPage({super.key});

  @override
  State<ModelViewPage> createState() => _ModelViewPageState();
}

class _ModelViewPageState extends State<ModelViewPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("HIVE CURD"),
        ),

        //Floationg Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _ShowMyDialog();
          },
          child: const Icon(Icons.add),
        ),
        body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList()..cast<NotesModel>;
            return box.values.isEmpty
                ? const Center(
                    child: Text("No List Found"),
                  )
                : ListView.builder(
                    itemCount: box.length,
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(data[index].title.toString()),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      delete(data[index]);
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        _editDialog(
                                            data[index],
                                            data[index].title.toString(),
                                            data[index].Desc.toString());
                                      },
                                      child: const Icon(Icons.edit)),
                                ],
                              ),
                              Text(data[index].Desc.toString()),
                            ],
                          ),
                        ),
                      );
                    });
          },
        ));
  }

  // Display Data function
  Future<void> _ShowMyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Notes"),
            content: SingleChildScrollView(
                child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      hintText: "Enter Title", border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                      hintText: "Enter Description",
                      border: OutlineInputBorder()),
                ),
              ],
            )),
            actions: [
              TextButton(
                  onPressed: () {
                    final data = NotesModel(
                        title: titleController.text, Desc: descController.text);
                    final box = Boxes.getData();
                    box.add(data);

                    //data.save();
                    titleController.clear();
                    descController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Add")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("cancel"))
            ],
          );
        });
  }

// Delete data function
  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

// Edit data Function
  Future<void> _editDialog(
      NotesModel notesModel, String title, String desc) async {
    titleController.text = title;
    descController.text = desc;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Notes"),
            content: SingleChildScrollView(
                child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      hintText: "Enter Title", border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                      hintText: "Enter Description",
                      border: OutlineInputBorder()),
                ),
              ],
            )),
            actions: [
              TextButton(
                  onPressed: () async {
                    notesModel.title = titleController.text.toString();
                    notesModel.Desc = descController.text.toString();

                    notesModel.save();
                    descController.clear();
                    titleController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Edit")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("cancel"))
            ],
          );
        });
  }
}
