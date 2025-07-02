// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:path_provider/path_provider.dart';
// import 'Connections.dart';
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:test_drive/AppConfig.dart';

// class Todo {
//   final Map<String, dynamic> sys;
//   final String taskRef;
//   final String taskType;
//   final String matingIdRef;
//   final String taskIntroDate;
//   bool closed;
//   final String taskCloseDate;
//   final String taskMessage;
//   dynamic answerData;
//   final String taskID;

//   Todo({
//     required this.sys,
//     required this.taskRef,
//     required this.taskType,
//     required this.matingIdRef,
//     required this.taskIntroDate,
//     required this.closed,
//     required this.taskCloseDate,
//     required this.taskMessage,
//     required this.answerData,
//     required this.taskID,
//   });

//   factory Todo.fromJson(Map<String, dynamic> json) {
//     return Todo(
//       sys: json['sys'] ?? '',
//       taskRef: json['taskRef'] ?? '',
//       taskType: json['taskType'] ?? '',
//       matingIdRef: json['matingIdRef'] ?? '',
//       taskIntroDate: json['taskIntroDate'] ?? '',
//       closed: json['closed'] ?? false,
//       taskCloseDate: json['taskCloseDate'] ?? '',
//       taskMessage: json['taskMessage'] ?? '',
//       answerData: json['answerData'] ?? '',
//       taskID: json['taskID'] ?? '',
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'sys': sys,
//       'taskRef': taskRef,
//       'taskType': taskType,
//       'matingIdRef': matingIdRef,
//       'taskIntroDate': taskIntroDate,
//       'closed': closed,
//       'taskCloseDate': taskCloseDate,
//       'taskMessage': taskMessage,
//       'answerData': answerData,
//       'taskID': taskID,
//     };
//   }
// }

// final APIEndpoint = AppConfig().API_ENDPOINT_GLOBAL;

// class TodoListPage extends StatefulWidget {
//   const TodoListPage({super.key});

//   @override
//   State<TodoListPage> createState() => _TodoListPageState();
// }

// class _TodoListPageState extends State<TodoListPage> {
//   late List<Todo> todoList;
//   bool isButtonVisible = true; // Track FAB visibility
//   late SharedPreferences prefs;

//   ApiHandler apiHandler = ApiHandler(); // Create instance here

//   @override
//   void initState() {
//     super.initState();
//     todoList = [];
//     initSharedPreferences(); // Initialize shared preferences
//     //fetchTodoList(); // Fetch data from API on initialization
//     file_fetchTodoList(); // Fetch data from file on initialization
//   }
//   // >>>>>>>>>>>>>>>>>>>>>>>>>> Start of hinding of refresh button

//   Future<void> initSharedPreferences() async {
//     prefs = await SharedPreferences.getInstance();
//     final now = DateTime.now();

//     // Calculate the time remaining until the next midnight
//     final nextMidnight = DateTime(now.year, now.month, now.day + 1);
//     final durationUntilMidnight = nextMidnight.difference(now);

//     // Check if the current time is past midnight
//     if (now.hour == 0 && now.minute == 0) {
//       isButtonVisible = true; // Show the button at midnight
//     } else {
//       isButtonVisible = false; // Hide the button otherwise
//       scheduleVisibilityUpdate(
//           durationUntilMidnight); // Schedule update for midnight
//     }

//     setState(() {});
//   }

//   void scheduleVisibilityUpdate(Duration duration) {
//     Future.delayed(duration, () {
//       setState(() {
//         isButtonVisible = true;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Todo List'),
//       ),
//       body: ListView.builder(
//         itemCount: todoList.length,
//         itemBuilder: (context, index) {
//           return TodoCard(
//             todo: todoList[index],
//             updateTodoCallback: updateTodoByTaskRef,
//           );
//         },
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Visibility(
//             visible: isButtonVisible,
//             child: FloatingActionButton(
//               onPressed: () async {
//                 setState(() {
//                   isButtonVisible = false; // Hide the refresh button
//                 });
//                 await fetchTodoList(); // Get data from API
//                 scheduleVisibilityUpdate(
//                     const Duration(days: 1)); // Reset visibility after a day
//               },
//               child: const Icon(Icons.refresh),
//             ),
//           ),
//           const SizedBox(height: 16), // Spacer between buttons
//           Visibility(
//             visible: !isButtonVisible,
//             child: FloatingActionButton(
//               onPressed: () async {
//                 // Handle upload button action
//                 updateDataToAPI();
//               },
//               child: const Icon(Icons.upload),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation
//           .startFloat, // Position the FABs at the bottom left
//     );
//   }

//   // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//   Future<void> fetchTodoList() async {
//     // Fetch data from the API
//     String host = "$APIEndpoint/tasks";
//     // print("URI ::: " host);

//     try {
//       final jsonData = await readDataFromFile();

//       // Filter out tasks that are already closed
//       final filteredData =
//           jsonData.where((item) => item['closed'] == true).toList();

//       if (filteredData.isNotEmpty) {
//         // Show a warning dialog if there are closed tasks
//         showDialog(
//           context: context,
//           barrierDismissible: false, // User must tap a button to dismiss
//           builder: (BuildContext dialogContext) {
//             return AlertDialog(
//               title: const Text(
//                 'Warning!!',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20.0,
//                     color: Colors.black),
//               ),
//               content: Text(
//                 'There are ${filteredData.length} task(s) are already done! If you continue, they tasks will be lost and not saved. Cancel to go back',
//                 style: const TextStyle(
//                   fontSize: 16.0,
//                   color: Colors.black87,
//                 ),
//               ),
//               actionsPadding: const EdgeInsets.symmetric(horizontal: 10.0),
//               actions: <Widget>[
//                 // Cancel button with custom style
//                 SizedBox(
//                   width: double.infinity,
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12.0),
//                     ),
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     onPressed: () {
//                       // Close the dialog and cancel action
//                       Navigator.of(dialogContext).pop();
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 10), // Add space between buttons
//                 // Continue button with custom style
//                 SizedBox(
//                   width: double.infinity,
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12.0),
//                     ),
//                     child: const Text(
//                       'Continue Anyway',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     onPressed: () {
//                       // Close the dialog and perform the continue action
//                       Navigator.of(dialogContext).pop();
//                       performActionAfterContinue(); // Custom action for "Continue"
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       } else if (jsonData.isEmpty) {
//         performActionAfterContinue();
//       } else {
//         // Handle case where no closed tasks are present (optional)
//         print("No closed tasks found.");
//       }
//     } catch (e) {
//       throw Exception('Error fetching data: $e');
//     }
//   }

//   Future<void> performActionAfterContinue() async {
//     // Custom logic for continue action
//     print("User chose to continue.");

//     String host = "$APIEndpoint/tasks";

//     // Set a timeout duration in milliseconds (e.g., 5 seconds)
//     const int timeoutDuration = 5000;

//     try {
//       // Make the API call
//       final response = await http
//           .get(Uri.parse(host), headers: {'timeout': '$timeoutDuration'});

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);

//         // Save the fetched JSON data to a local file
//         await saveDataToFile(jsonData);

//         // Optionally, update the UI with the fetched data
//         setState(() {
//           todoList =
//               List<Todo>.from(jsonData.map((item) => Todo.fromJson(item)));
//         });

//         print("API data successfully fetched and stored.");
//       } else {
//         throw Exception('Failed to fetch data: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle the exception
//       print("Error occurred while fetching data: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Error: Unable to fetch data')));
//     }
//   }

//   Future<void> saveDataToFile(dynamic jsonData) async {
//     try {
//       final file = await _f_localFile;
//       await file.writeAsString(jsonEncode(jsonData), mode: FileMode.write);
//       print('Data saved to file successfully');
//     } catch (e) {
//       throw Exception('Error saving data to file: $e');
//     }
//   }

//   Future<void> file_fetchTodoList() async {
//     // Fetch data from local file
//     try {
//       final jsonData = await readDataFromFile();

//       final filteredData =
//           jsonData.where((item) => item['closed'] == false).toList();

//       if (filteredData.isEmpty) {
//         setState(() {
//           isButtonVisible = true; // Show the refresh button
//         });
//       }

//       print("FILE FETCH ::: " '$jsonData');
//       // Update state with data from file
//       setState(() {
//         todoList =
//             List<Todo>.from(filteredData.map((item) => Todo.fromJson(item)));
//       });
//     } catch (e) {
//       throw Exception('Error fetching data from file: $e');
//     }
//   }

//   Future<List<dynamic>> readDataFromFile() async {
//     try {
//       final file = await _f_localFile;

//       // Check if the file exists
//       if (!(await file.exists())) {
//         // If the file doesn't exist, create it with default data
//         final defaultData = []; // You can customize this with your default data
//         await file.writeAsString(jsonEncode(defaultData));
//       }

//       // Read the file and decode JSON data
//       final fileData = await file.readAsString(encoding: utf8);
//       return jsonDecode(fileData);
//     } catch (e) {
//       // Handle any exceptions (e.g., file not found, permission issues)
//       print('Error reading data from file: $e');
//       // Return an empty list or handle as needed
//       return [];
//     }
//   }

//   Future<File> get _f_localFile async {
//     final directory = await getApplicationDocumentsDirectory();
//     return File('${directory.path}/todo_data.json');
//   }
//   //////////////////////////////////////////////

//   // Update Todo by taskRef
// // Update Todo by taskRef
//   void updateTodoByTaskRef(String taskRef, dynamic input) {
//     int index = todoList.indexWhere((todo) => todo.taskRef == taskRef);
//     if (index != -1) {
//       Todo foundTodo = todoList[index];

//       // Check if answerData is a Map, if not, initialize it as an empty Map
//       if (foundTodo.answerData is! Map<String, dynamic>) {
//         foundTodo.answerData = {};
//       }

//       // Update fields in foundTodo
//       foundTodo.closed = true;

//       // Handle comment tasks
//       foundTodo.answerData['taskActionComments'] = input; // string comments

//       foundTodo.answerData['actionDate'] = DateTime.now().toIso8601String();
//       todoList[index] = foundTodo;
//       saveTodoListToFile(foundTodo); // Save the updated todo to file
//     } else {
//       print('Todo with taskRef $taskRef not found.');
//     }
//   }

//   void saveTodoListToFile(Todo updatedTodo) async {
//     try {
//       final file = await _f_localFile;
//       final jsonData = await readDataFromFile();
//       int updateIndex =
//           jsonData.indexWhere((item) => item['taskRef'] == updatedTodo.taskRef);
//       if (updateIndex != -1) {
//         jsonData[updateIndex] = updatedTodo.toJson();
//       }
//       await file.writeAsString(jsonEncode(jsonData), mode: FileMode.write);
//       print('Updated Data: $jsonData');
//       loadTodoListFromFile();
//     } catch (e) {
//       print('Error saving data to file: $e');
//     }
//   }

//   Future<void> updateDataToAPI() async {
//     String host = '$APIEndpoint/tasks/update';

//     final jsonData = await readDataFromFile();

//     final filteredData =
//         jsonData.where((item) => item['closed'] == true).toList();

//     // Show confirmation dialog before proceeding
//     bool? proceed = await _showConfirmationDialog(filteredData.length);

//     try {
//       if (filteredData.isEmpty) {
//         // Show a SnackBar indicating there is no data to post
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('No tasks completed yet!'),
//             duration: const Duration(seconds: 2),
//             action: SnackBarAction(
//               label: 'OK',
//               onPressed: () {
//                 // Handle action press if needed
//               },
//             ),
//           ),
//         );
//         return; // Exit the method if there is no data to post
//       }

//       print('Ready to POST ${filteredData.length} records');
//       if (proceed == true) {
//         // Extract the required fields and create JSON data for the POST request
//         final postData = filteredData.map((item) {
//           return {
//             'taskRef': item['taskRef'],
//             'answerData': item['answerData'],
//           };
//         }).toList();

//         // Make the POST request to your API endpoint
//         final response = await http.post(
//           Uri.parse(host),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode(postData),
//         );

//         if (response.statusCode == 200) {
//           print('Data updated to API successfully');
//           // Optionally, perform any UI update or action after successful update
//           //fetchTodoList(); // Get more tasks once an update happens

//           // If successful, remove the closed tasks locally
//           final updatedData =
//               jsonData.where((item) => item['closed'] == false).toList();
//           await saveDataToFile(updatedData);

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Tasks updated and deleted locally!')),
//           );
//         } else {
//           throw Exception(
//               'Failed to update data to API: ${response.statusCode}');
//         }
//       } else {
//         print('Failed to update data to api');
//       }
//     } catch (e) {
//       print('Error updating data to API: $e');
//     }
//   }

//   Future<bool?> _showConfirmationDialog(int updateSize) {
//     return showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Action'),
//           content:
//               Text('You are about to update $updateSize resolved tasks?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false); // User clicked Cancel
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true); // User clicked Proceed
//               },
//               child: const Text('Proceed'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Load data from file
//   void loadTodoListFromFile() async {
//     try {
//       final jsonData = await readDataFromFile();
//       todoList = List<Todo>.from(jsonData.map((item) => Todo.fromJson(item)));
//     } catch (e) {
//       print('Error loading data from file: $e');
//     }
//   }

//   // Find a Todo object by taskRef
//   Todo? findTodoByTaskRef(String taskRef) {
//     try {
//       return todoList.firstWhere((todo) => todo.taskRef == taskRef);
//     } catch (e) {
//       return null;
//     }
//   }
//   //////////////////////////////////////////////
// }

// class TodoCard extends StatefulWidget {
//   final Todo todo;
//   final Function(String, dynamic)
//       updateTodoCallback; // Modify callback to accept dynamic

//   const TodoCard({super.key, 
//     required this.todo,
//     required this.updateTodoCallback,
//   });

//   @override
//   State<TodoCard> createState() => _TodoCardState();
// }

// class _TodoCardState extends State<TodoCard> {
//   TextEditingController textEditingController = TextEditingController();
//   bool showInput = false;
//   bool commentsSubmitted = false; // Track if comments are submitted

//   // Variables for Yes/No selection
//   String? selectedOption;

//   @override
//   void initState() {
//     super.initState();
//     textEditingController.text = '';
//   }

//   @override
//   void dispose() {
//     textEditingController.dispose();
//     super.dispose();
//   }

//   bool isYesNoTask(int taskType) {
//     return taskType == 2 || taskType == 3 || taskType == 6 || taskType == 10;
//   }

//   @override
//   Widget build(BuildContext context) {
//     int taskType;
//     try {
//       taskType = int.parse(widget.todo.taskType);
//     } catch (e) {
//       taskType = -1; // Default or handle error
//     }

//     bool yesNo = isYesNoTask(taskType);

//     return Visibility(
//       visible: !commentsSubmitted, // Hide the card if comments are submitted
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.todo.taskMessage,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 'Ref: ${widget.todo.taskRef}',
//                 style: const TextStyle(
//                   fontSize: 10,
//                   color: Color.fromARGB(255, 69, 211, 236),
//                   fontStyle: FontStyle.italic,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               if (!showInput)
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       showInput = true;
//                       selectedOption = null; // Reset selection
//                       textEditingController.text = '';
//                       commentsSubmitted = false;
//                     });
//                   },
//                   child: const Text('Done'),
//                 ),
//               if (showInput && yesNo)
//                 Column(
//                   children: [
//                     // Task type 2 or 3: Health related options
//                     if (taskType == 2 || taskType == 3) ...[
//                       RadioListTile<String>(
//                         title: const Text('Health Okay'),
//                         value: 'YES',
//                         groupValue: selectedOption,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedOption = value;
//                           });
//                         },
//                       ),
//                       RadioListTile<String>(
//                         title: const Text('Health Not Okay'),
//                         value: 'NO',
//                         groupValue: selectedOption,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedOption = value;
//                           });
//                         },
//                       ),
//                     ],
//                     // Task type 6: Pregnancy related options
//                     if (taskType == 6) ...[
//                       RadioListTile<String>(
//                         title: const Text('Pregnancy Confirmed'),
//                         value: 'YES',
//                         groupValue: selectedOption,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedOption = value;
//                           });
//                         },
//                       ),
//                       RadioListTile<String>(
//                         title: const Text('Pregnancy Not Confirmed'),
//                         value: 'NO',
//                         groupValue: selectedOption,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedOption = value;
//                           });
//                         },
//                       ),
//                     ],
//                     if (taskType == 10) ...[
//                       RadioListTile<String>(
//                         title: const Text('Yes'),
//                         value: 'YES',
//                         groupValue: selectedOption,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedOption = value;
//                           });
//                         },
//                       ),
//                       RadioListTile<String>(
//                         title: const Text('No'),
//                         value: 'NO',
//                         groupValue: selectedOption,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedOption = value;
//                           });
//                         },
//                       ),
//                     ],
//                     ElevatedButton(
//                       onPressed: () {
//                         if (selectedOption == null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Please select an option.'),
//                             ),
//                           );
//                         } else {
//                           // Pass the selected option string directly
//                           widget.updateTodoCallback(
//                               widget.todo.taskRef, selectedOption);
//                           setState(() {
//                             commentsSubmitted = true;
//                             showInput = false;
//                           });
//                         }
//                       },
//                       child: const Text('Submit'),
//                     ),
//                   ],
//                 ),
//               if (showInput && !yesNo)
//                 Column(
//                   children: [
//                     TextField(
//                       controller: textEditingController,
//                       decoration: InputDecoration(
//                         labelText: 'Comments',
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: commentsSubmitted &&
//                                     textEditingController.text.isEmpty
//                                 ? Colors.red
//                                 : Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (textEditingController.text.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Please add comments.'),
//                             ),
//                           );
//                         } else {
//                           // Call the callback provided by the parent widget to update todo
//                           widget.updateTodoCallback(
//                             widget.todo.taskRef,
//                             textEditingController.text,
//                           );
//                           setState(() {
//                             commentsSubmitted = true;
//                             showInput = false;
//                           });
//                         }
//                       },
//                       child: const Text('Submit'),
//                     ),
//                   ],
//                 ),
//               if (commentsSubmitted)
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       showInput = false; // Hide the input field
//                       commentsSubmitted = false; // Reset commentsSubmitted
//                     });
//                   },
//                   child: const Text('Done'),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
