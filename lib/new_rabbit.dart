import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'Connections.dart';
import 'ToDoPage.dart';

class RabbitForm extends StatefulWidget {
  @override
  _RabbitFormState createState() => _RabbitFormState();
}

class _RabbitFormState extends State<RabbitForm> {
  ApiHandler apiHandler = ApiHandler(); // Create instance here
  final TextEditingController _tagNoController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _motherController = TextEditingController();
  final TextEditingController _fatherController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _diseasesController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _priceSoldController = TextEditingController();
  final TextEditingController _cageController = TextEditingController();
  final TextEditingController _imagesController = TextEditingController();
  final TextEditingController _birthdayController =
      TextEditingController(); // Added birthday controller

  DateTime? _selectedDate;

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _birthdayController.text = DateFormat('dd-MM-yyyy')
            .format(pickedDate); // Update the text field with selected date
      });
    }
  }

  void _alertEmptyField(field) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validation Error'),
          content: Text('Please fill in the $field field.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    if (_tagNoController.text.isEmpty) {
      _alertEmptyField("TagNo");
      return;
    }
    if (_sexController.text.isEmpty) {
      _alertEmptyField("Sex");
      return;
    }
    if (_breedController.text.isEmpty) {
      _alertEmptyField("Breed");
      return;
    }
    if (_motherController.text.isEmpty) {
      _alertEmptyField("Mother");
      return;
    }
    if (_fatherController.text.isEmpty) {
      _alertEmptyField("Father");
      return;
    }
    if (_commentsController.text.isEmpty) {
      _alertEmptyField("Comments");
      return;
    }
    if (_cageController.text.isEmpty) {
      _alertEmptyField("Cage");
      return;
    }
    if (_selectedDate == null) {
      _alertEmptyField("Birthday");
      return;
    }

    // Proceed with creating the JSON representation
    Map<String, dynamic> rabbitData = {
      'tagNo': _tagNoController.text,
      'present': 'Yes',
      'breed': _breedController.text,
      'mother': _motherController.text,
      'father': _fatherController.text,
      'sex': _sexController.text,
      'origin': _originController.text,
      'diseases': _diseasesController.text,
      'comments': _commentsController.text,
      'weight': _weightController.text,
      'price_sold': _priceSoldController.text,
      'cage': _cageController.text,
      'birthday': DateFormat('dd/MM/yyyy').format(_selectedDate!).toString(),
      'images': _imagesController.text,
    };

    String jsonStr = jsonEncode(rabbitData);
    print("JSON DATA ::: $rabbitData");

    apiHandler.APIpost('/api/rabbits/create_rabbit', rabbitData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 90, 224, 241),
        title: Text('Create New Rabbit'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildTextField('Tag on the Rabbit', _tagNoController),
            buildTextField('Breed', _breedController),
            buildTextField('Mother', _motherController),
            buildTextField('Father', _fatherController),
            buildTextField('Sex', _sexController),
            buildTextField('Origin', _originController),
            buildTextField('Diseases', _diseasesController),
            buildTextField('Comments', _commentsController),
            buildTextField('Weight', _weightController),
            buildTextField('Price Sold', _priceSoldController),
            buildTextField('Cage', _cageController),
            buildTextField('Images', _imagesController),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.lightBlue,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: InputBorder.none, // Remove input field border
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                            : 'Select Birth Date',
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Add space between date picker and button
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Save'), // Change button text to 'Save'
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelText,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.lightBlueAccent, // Set text color to red
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.lightBlue), // Set border color to red
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.greenAccent), // Set border color to red
            ),
          ),
        ),
      ),
    );
  }
}
