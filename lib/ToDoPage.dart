import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'Connections.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Todo {
  final Map<String, dynamic> sys;
  final String taskRef;
  final String taskType;
  final String matingIdRef;
  final String taskIntroDate;
  bool closed;
  final String taskCloseDate;
  final String taskMessage;
  dynamic answerData;
  final String taskID;

  Todo({
    required this.sys,
    required this.taskRef,
    required this.taskType,
    required this.matingIdRef,
    required this.taskIntroDate,
    required this.closed,
    required this.taskCloseDate,
    required this.taskMessage,
    required this.answerData,
    required this.taskID,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      sys: json['sys'] ?? '',
      taskRef: json['taskRef'] ?? '',
      taskType: json['taskType'] ?? '',
      matingIdRef: json['matingIdRef'] ?? '',
      taskIntroDate: json['taskIntroDate'] ?? '',
      closed: json['closed'] ?? false,
      taskCloseDate: json['taskCloseDate'] ?? '',
      taskMessage: json['taskMessage'] ?? '',
      answerData: json['answerData'] ?? '',
      taskID: json['taskID'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'sys': sys,
      'taskRef': taskRef,
      'taskType': taskType,
      'matingIdRef': matingIdRef,
      'taskIntroDate': taskIntroDate,
      'closed': closed,
      'taskCloseDate': taskCloseDate,
      'taskMessage': taskMessage,
      'answerData': answerData,
      'taskID': taskID,
    };
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  late List<Todo> todoList;
  bool isButtonVisible = true; // Track FAB visibility
  late SharedPreferences prefs;

  ApiHandler apiHandler = ApiHandler(); // Create instance here

  @override
  void initState() {
    super.initState();
    todoList = [];
    initSharedPreferences(); // Initialize shared preferences
    //fetchTodoList(); // Fetch data from API on initialization
    file_fetchTodoList(); // Fetch data from file on initialization
  }
  // >>>>>>>>>>>>>>>>>>>>>>>>>> Start of hinding of refresh button

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    final lastClickTime = prefs.getInt('last_click_time');
    if (lastClickTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final durationUntilMidnight = Duration(milliseconds: lastClickTime - now);
      if (durationUntilMidnight.inMilliseconds > 0) {
        isButtonVisible = false; // Button should remain hidden until midnight
        scheduleVisibilityUpdate(durationUntilMidnight);
      } else {
        isButtonVisible = true; // Button should be visible
      }
    } else {
      isButtonVisible = true; // Button should be visible
    }
    setState(() {});
  }

  void scheduleVisibilityUpdate(Duration duration) {
    final now = DateTime.now();
    final midnight =
        DateTime(now.year, now.month, now.day + 1); // Next midnight

    prefs.setInt('last_click_time', midnight.millisecondsSinceEpoch);

    Future.delayed(duration, () {
      setState(() {
        isButtonVisible = true; // Show the button after the specified duration
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return TodoCard(
            todo: todoList[index],
            updateTodoCallback: updateTodoByTaskRef,
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: isButtonVisible,
            child: FloatingActionButton(
              onPressed: () async {
                setState(() {
                  isButtonVisible = false; // Hide the refresh button
                });
                await fetchTodoList(); // Get data from API
                scheduleVisibilityUpdate(
                    Duration(days: 1)); // Reset visibility after a day
              },
              child: const Icon(Icons.refresh),
            ),
          ),
          const SizedBox(height: 16), // Spacer between buttons
          Visibility(
            visible: !isButtonVisible,
            child: FloatingActionButton(
              onPressed: () async {
                // Handle upload button action
                updateDataToAPI();
              },
              child: const Icon(Icons.upload),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .startFloat, // Position the FABs at the bottom left
    );
  }

  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<void> fetchTodoList() async {
    // Fetch data from the API
    const String host = 'http://192.168.0.104:8080/tasks';
    print("URI ::: " + '$host');

    try {
      // Set a timeout duration in milliseconds (e.g., 5 seconds)
      const int timeoutDuration = 5000;

      // Replace the URL with your actual API endpoint and add the timeout parameter
      final response = await http
          .get(Uri.parse(host), headers: {'timeout': '$timeoutDuration'});

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Save JSON data to a file
        await saveDataToFile(jsonData); // Call the saveDataToFile function

        // Optionally, update the UI with the fetched data
        setState(() {
          todoList =
              List<Todo>.from(jsonData.map((item) => Todo.fromJson(item)));
        });
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<void> saveDataToFile(dynamic jsonData) async {
    try {
      final file = await _f_localFile;
      await file.writeAsString(jsonEncode(jsonData), mode: FileMode.write);
      print('Data saved to file successfully');
    } catch (e) {
      throw Exception('Error saving data to file: $e');
    }
  }

  Future<void> file_fetchTodoList() async {
    // Fetch data from local file
    try {
      final jsonData = await readDataFromFile();

      final filteredData =
          jsonData.where((item) => item['closed'] == false).toList();

      if (filteredData.length == 1) {
        setState(() {
          isButtonVisible = true; // Show the refresh button
        });
      }

      print("FILE FETCH ::: " + '$jsonData');
      // Update state with data from file
      setState(() {
        todoList =
            List<Todo>.from(filteredData.map((item) => Todo.fromJson(item)));
      });
    } catch (e) {
      throw Exception('Error fetching data from file: $e');
    }
  }

  Future<List<dynamic>> readDataFromFile() async {
    final file = await _f_localFile;
    final fileData = await file.readAsString(encoding: utf8);
    return jsonDecode(fileData);
  }

  Future<File> get _f_localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todo_data.json');
  }
  //////////////////////////////////////////////

  // Update Todo by taskRef
  void updateTodoByTaskRef(String taskRef, String comments) {
    int index = todoList.indexWhere((todo) => todo.taskRef == taskRef);
    if (index != -1) {
      Todo foundTodo = todoList[index];

      // Check if answerData is a Map, if not, initialize it as an empty Map
      if (foundTodo.answerData is! Map<String, dynamic>) {
        foundTodo.answerData = {};
      }

      // Update fields in foundTodo
      foundTodo.closed = true;
      foundTodo.answerData['taskActionComments'] = comments;
      foundTodo.answerData['actionDate'] = DateTime.now().toString();
      todoList[index] = foundTodo;
      saveTodoListToFile(foundTodo); // Save the updated todo to file
    } else {
      print('Todo with taskRef $taskRef not found.');
    }
  }

  void saveTodoListToFile(Todo updatedTodo) async {
    try {
      final file = await _f_localFile;
      final jsonData = await readDataFromFile();
      int updateIndex =
          jsonData.indexWhere((item) => item['taskRef'] == updatedTodo.taskRef);
      if (updateIndex != -1) {
        jsonData[updateIndex] = updatedTodo.toJson();
      }
      await file.writeAsString(jsonEncode(jsonData), mode: FileMode.write);
      print('Updated Data: $jsonData');
      loadTodoListFromFile();
    } catch (e) {
      print('Error saving data to file: $e');
    }
  }

  Future<void> updateDataToAPI() async {
    const String host = 'http://192.168.0.104:8080/tasks/update';
    try {
      final jsonData = await readDataFromFile();

      final filteredData =
          jsonData.where((item) => item['closed'] == true).toList();

      if (filteredData.isEmpty) {
        // Show a SnackBar indicating there is no data to post
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No tasks completed yet!'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                // Handle action press if needed
              },
            ),
          ),
        );
        return; // Exit the method if there is no data to post
      }

      // Extract the required fields and create JSON data for the POST request
      final postData = filteredData.map((item) {
        return {
          'taskRef': item['taskRef'],
          'answerData': item['answerData'],
        };
      }).toList();

      // Make the POST request to your API endpoint
      final response = await http.post(
        Uri.parse(host), // Replace with your API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        print('Data updated to API successfully');
        // Optionally, perform any UI update or action after successful update
      } else {
        throw Exception('Failed to update data to API: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating data to API: $e');
    }
  }

  // Load data from file
  void loadTodoListFromFile() async {
    try {
      final jsonData = await readDataFromFile();
      todoList = List<Todo>.from(jsonData.map((item) => Todo.fromJson(item)));
    } catch (e) {
      print('Error loading data from file: $e');
    }
  }

  // Find a Todo object by taskRef
  Todo? findTodoByTaskRef(String taskRef) {
    try {
      return todoList.firstWhere((todo) => todo.taskRef == taskRef);
    } catch (e) {
      return null;
    }
  }
  //////////////////////////////////////////////
}

class TodoCard extends StatefulWidget {
  final Todo todo;
  final Function(String, String) updateTodoCallback; // Modified callback

  const TodoCard({
    required this.todo,
    required this.updateTodoCallback,
  });

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  TextEditingController textEditingController = TextEditingController();
  bool showTextInput = false;
  bool commentsSubmitted = false; // Track if comments are submitted

  @override
  void initState() {
    super.initState();
    // Initialize textEditingController with empty text
    textEditingController.text = '';
  }

  @override
  void dispose() {
    // Dispose textEditingController when the widget is disposed
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !commentsSubmitted, // Hide the card if comments are submitted
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.todo.taskMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ref: ${widget.todo.taskRef}',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(255, 69, 211, 236),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              if (!showTextInput) // Show "Done" button if comments not open
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showTextInput = true;
                      // Clear the text field when showing input
                      textEditingController.text = '';
                      commentsSubmitted = false;
                    });
                  },
                  child: const Text('Done'),
                ),
              if (showTextInput)
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    labelText: 'Comments',
                    border: OutlineInputBorder(
                      borderSide: commentsSubmitted &&
                              textEditingController.text.isEmpty
                          ? BorderSide(
                              color: Colors
                                  .red) // Red border if comments not added
                          : BorderSide(), // Default border
                    ),
                  ),
                ),
              if (showTextInput)
                ElevatedButton(
                  onPressed: () {
                    if (textEditingController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please add comments.'),
                        ),
                      );
                    } else {
                      // Call the callback provided by the parent widget to update todo
                      widget.updateTodoCallback(
                        widget.todo.taskRef,
                        textEditingController.text,
                      );
                      setState(() {
                        commentsSubmitted = true;
                        showTextInput = false;
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
              if (commentsSubmitted) // Always show the "Done" button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showTextInput = false; // Hide the input field
                      commentsSubmitted = false; // Reset commentsSubmitted
                    });
                  },
                  child: const Text('Done'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
