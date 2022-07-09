import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.purple),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
   MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController noteController = TextEditingController();

  List<String> notes = [];

  saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("noteData", notes);
  }

  loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.getStringList("noteData") != null) {
        notes = prefs.getStringList("noteData")!;
      } else {
        notes = [];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple.shade100,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Note App",
            style: TextStyle(fontSize: 25),
          ),
          actions: const [
            Icon(Icons.notifications),
            Icon(Icons.access_alarm_outlined)
          ],
        ),
        drawer: const Drawer(
          width: 120,
          child: Center(child: Text("test")),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: const Text("Add a note"),
                    content: TextField(
                      controller: noteController,
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              notes.add(noteController.text);
                              saveData();
                            });

                            print(notes);
                            Navigator.of(context).pop();
                            noteController.clear();
                          },
                          child: Text("Add"))
                    ],
                  );
                });
          },
        ),
        body: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: ListTile(
                  trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          notes.removeAt(index);
                          saveData();
                        });
                        print(notes);
                      },
                      icon: Icon(
                        Icons.delete_sharp,
                        color: Colors.red,
                      )),
                  title: Text(notes[index]),
                  tileColor: Colors.white60,
                ),
              );
            }));
  }
}
