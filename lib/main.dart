import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TaskListApp(),
    );
  }
}

class TaskListApp extends StatefulWidget {
  @override
  _TaskListAppState createState() => _TaskListAppState();
}

class _TaskListAppState extends State<TaskListApp> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo List App"),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: data.isEmpty 
        ? Center(
            child: Text(
              "No task yet, add some!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                ...data.entries
                    .map((e) => card(e.key, e.value))
                    .toList(growable: false),
              ],
            ),
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTaskDialog(context);
        },
        child: Icon(Icons.add)
      ),
    );
  }

  void showAddTaskDialog(BuildContext context) {
    // Create controllers
    TextEditingController titleController = TextEditingController();
    TextEditingController decController = TextEditingController();
    
    // Create form key for validation
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Task"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Task Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: decController,
                  decoration: InputDecoration(
                    labelText: "Task Description",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                // Validate form
                if (_formKey.currentState!.validate()) {
                  // If form is valid, add the task
                  data[titleController.text.trim()] = decController.text.trim();
                  setState(() {
                    Navigator.pop(context);
                  });
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: Text("Add", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Container card(String title, String dec) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(dec, style: TextStyle(fontSize: 15)),
            ],
          ),
          IconButton(
            onPressed: () {
              // remove item
              setState(() {
                data.remove(title);
              });
            },
            icon: Icon(Icons.done),
          )
        ],
      ),
    );
  }
}