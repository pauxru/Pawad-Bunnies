import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import '../services/rabbit_api_service.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_drive/AppConfig.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';
import '../widgets/yes_no_option_widget.dart';
import '../widgets/base_scaffold.dart';
import '../constants/constants.dart';


//final APIEndpoint = AppConfig().API_ENDPOINT_GLOBAL;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  late List<Todo> todoList;
  bool isButtonVisible = true; // Track FAB visibility
  late SharedPreferences prefs;
  late TodoService todoService;

  RabbitApiService apiHandler = RabbitApiService(); // Create instance here

  @override
  void initState() {
    super.initState();
    todoList = [];
    initSharedPreferences(); // Initialize shared preferences
    //fetchTodoList(); // Fetch data from API on initialization
  }
  // >>>>>>>>>>>>>>>>>>>>>>>>>> Start of hinding of refresh button

  Future<void> initSharedPreferences() async {
  prefs = await SharedPreferences.getInstance();
  final now = DateTime.now();

  // Calculate the time remaining until the next midnight
  final nextMidnight = DateTime(now.year, now.month, now.day + 1);
  final durationUntilMidnight = nextMidnight.difference(now);

  // Check if the current time is past midnight
  isButtonVisible = now.hour == 0 && now.minute == 0;

  if (!isButtonVisible) {
    scheduleVisibilityUpdate(durationUntilMidnight);
  }

  // ✅ Initialize the service now
  todoService = TodoService(
    context: context,
    apiEndpoint: Constants.apiBaseUrl,
    onTodoListUpdated: (todos) {
      setState(() {
        todoList = todos;
      });
    },
    onToggleButtonVisibility: (visible) {
      setState(() {
        isButtonVisible = visible;
      });
    },
    onUpdate: (todos) {
      setState(() {
        todoList = todos;
      });
    },
  );

  // ✅ Now safe to call fetch method
  await todoService.fileFetchTodoList();

  setState(() {});
}


  void scheduleVisibilityUpdate(Duration duration) {
    Future.delayed(duration, () {
      setState(() {
        isButtonVisible = true;
      });
    });
  }

@override
Widget build(BuildContext context) {
  return BaseScaffold(
    title: 'Task List',
    currentIndex: 1, // Index for Tasks in your BottomNavBar
    child: Stack(
      children: [
        ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            return TodoCard(
              todo: todoList[index],
              updateTodoCallback: todoService.updateTodoByTaskRef,
            );
          },
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: isButtonVisible,
                child: FloatingActionButton(
                  onPressed: () async {
                    setState(() {
                      isButtonVisible = false;
                    });
                    await todoService.fetchTodoList();
                    scheduleVisibilityUpdate(const Duration(days: 1));
                  },
                  child: const Icon(Icons.refresh),
                ),
              ),
              const SizedBox(height: 12),
              Visibility(
                visible: !isButtonVisible,
                child: FloatingActionButton(
                  onPressed: () {
                    todoService.updateDataToAPI();
                  },
                  child: const Icon(Icons.upload),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  
  //////////////////////////////////////////////
}

class TodoCard extends StatefulWidget {
  final Todo todo;
  final Function(String, dynamic)
      updateTodoCallback; // Modify callback to accept dynamic

  const TodoCard({super.key, 
    required this.todo,
    required this.updateTodoCallback,
  });

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  TextEditingController textEditingController = TextEditingController();
  bool showInput = false;
  bool commentsSubmitted = false; // Track if comments are submitted

  // Variables for Yes/No selection
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    textEditingController.text = '';
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  bool isYesNoTask(int taskType) {
    return taskType == 2 || taskType == 3 || taskType == 6 || taskType == 10;
  }

  @override
  Widget build(BuildContext context) {
    int taskType;
    try {
      taskType = int.parse(widget.todo.taskType);
    } catch (e) {
      taskType = -1; // Default or handle error
    }

    bool yesNo = isYesNoTask(taskType);

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
              if (!showInput)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showInput = true;
                      selectedOption = null; // Reset selection
                      textEditingController.text = '';
                      commentsSubmitted = false;
                    });
                  },
                  child: const Text('Done'),
                ),
              if (showInput && yesNo)
                Column(
                  children: [
                    YesNoOptionWidget(
                      taskType: taskType,
                      selectedOption: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedOption == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select an option.'),
                            ),
                          );
                        } else {
                          widget.updateTodoCallback(
                            widget.todo.taskRef,
                            selectedOption,
                          );
                          setState(() {
                            commentsSubmitted = true;
                            showInput = false;
                          });
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),

              if (showInput && !yesNo)
                Column(
                  children: [
                    TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        labelText: 'Comments',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: commentsSubmitted &&
                                    textEditingController.text.isEmpty
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (textEditingController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
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
                            showInput = false;
                          });
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              if (commentsSubmitted)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showInput = false; // Hide the input field
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
