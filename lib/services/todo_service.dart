import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/todo.dart'; // adjust this import path as per your project structure

class TodoService {
  final BuildContext context;
  final Function(List<Todo>) onTodoListUpdated;
  final Function(bool) onToggleButtonVisibility;
  final String apiEndpoint;

  List<Todo> todoList = [];

  TodoService({
    required this.context,
    required this.onTodoListUpdated,
    required this.onToggleButtonVisibility,
    required this.apiEndpoint, required void Function(List<Todo> todos) onUpdate,
  });

  Future<void> fetchTodoList() async {
    String host = "$apiEndpoint/tasks";

    try {
      final jsonData = await readDataFromFile();

      final filteredData = jsonData.where((item) => item['closed'] == true).toList();

      if (filteredData.isNotEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Warning!!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              content: Text('There are ${filteredData.length} task(s) already done! If you continue, they will be lost.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                TextButton(
                  child: const Text('Continue Anyway', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    performActionAfterContinue();
                  },
                ),
              ],
            );
          },
        );
      } else if (jsonData.isEmpty) {
        performActionAfterContinue();
      } else {
        print("No closed tasks found.");
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<void> performActionAfterContinue() async {
    String host = "$apiEndpoint/tasks";
    const int timeoutDuration = 5000;

    try {
      final response = await http.get(Uri.parse(host), headers: {'timeout': '$timeoutDuration'});

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        await saveDataToFile(jsonData);

        todoList = List<Todo>.from(jsonData.map((item) => Todo.fromJson(item)));
        onTodoListUpdated(todoList);
        print("API data successfully fetched and stored.");
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred while fetching data: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Unable to fetch data')));
    }
  }

  Future<void> fileFetchTodoList() async {
    try {
      final jsonData = await readDataFromFile();
      final filteredData = jsonData.where((item) => item['closed'] == false).toList();

      if (filteredData.isEmpty) onToggleButtonVisibility(true);

      todoList = List<Todo>.from(filteredData.map((item) => Todo.fromJson(item)));
      onTodoListUpdated(todoList);
    } catch (e) {
      throw Exception('Error fetching data from file: $e');
    }
  }

  Future<void> updateTodoByTaskRef(String taskRef, dynamic input) async {
    int index = todoList.indexWhere((todo) => todo.taskRef == taskRef);
    if (index != -1) {
      Todo foundTodo = todoList[index];
      foundTodo.closed = true;
      foundTodo.answerData ??= {};
      foundTodo.answerData['taskActionComments'] = input;
      foundTodo.answerData['actionDate'] = DateTime.now().toIso8601String();

      todoList[index] = foundTodo;
      await saveTodoListToFile(foundTodo);
    } else {
      print('Todo with taskRef $taskRef not found.');
    }
  }

  Future<void> updateDataToAPI() async {
    String host = '$apiEndpoint/tasks/update';
    final jsonData = await readDataFromFile();
    final filteredData = jsonData.where((item) => item['closed'] == true).toList();

    bool? proceed = await _showConfirmationDialog(filteredData.length);

    if (filteredData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No tasks completed yet!')));
      return;
    }

    if (proceed == true) {
      final postData = filteredData.map((item) => {
            'taskRef': item['taskRef'],
            'answerData': item['answerData'],
          }).toList();

      try {
        final response = await http.post(
          Uri.parse(host),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(postData),
        );

        if (response.statusCode == 200) {
          final updatedData = jsonData.where((item) => item['closed'] == false).toList();
          await saveDataToFile(updatedData);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tasks updated and deleted locally!')),
          );
        } else {
          throw Exception('Failed to update data: ${response.statusCode}');
        }
      } catch (e) {
        print('Error updating data to API: $e');
      }
    }
  }

  Future<void> loadTodoListFromFile() async {
    try {
      final jsonData = await readDataFromFile();
      todoList = List<Todo>.from(jsonData.map((item) => Todo.fromJson(item)));
      onTodoListUpdated(todoList);
    } catch (e) {
      print('Error loading data from file: $e');
    }
  }

  Todo? findTodoByTaskRef(String taskRef) {
    try {
      return todoList.firstWhere((todo) => todo.taskRef == taskRef);
    } catch (_) {
      return null;
    }
  }

  // Helpers

  Future<void> saveTodoListToFile(Todo updatedTodo) async {
    try {
      final file = await _localFile;
      final jsonData = await readDataFromFile();
      int index = jsonData.indexWhere((item) => item['taskRef'] == updatedTodo.taskRef);
      if (index != -1) {
        jsonData[index] = updatedTodo.toJson();
      }
      await file.writeAsString(jsonEncode(jsonData));
      loadTodoListFromFile();
    } catch (e) {
      print('Error saving data to file: $e');
    }
  }

  Future<void> saveDataToFile(dynamic jsonData) async {
    try {
      final file = await _localFile;
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      throw Exception('Error saving data to file: $e');
    }
  }

  Future<List<dynamic>> readDataFromFile() async {
    try {
      final file = await _localFile;
      if (!(await file.exists())) {
        await file.writeAsString(jsonEncode([]));
      }
      final fileData = await file.readAsString(encoding: utf8);
      return jsonDecode(fileData);
    } catch (e) {
      print('Error reading data: $e');
      return [];
    }
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todo_data.json');
  }

  Future<bool?> _showConfirmationDialog(int updateSize) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Action'),
          content: Text('You are about to update $updateSize resolved tasks?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Proceed')),
          ],
        );
      },
    );
  }
}
