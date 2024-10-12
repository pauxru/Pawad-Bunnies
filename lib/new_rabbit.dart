import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'Connections.dart';
import 'ToDoPage.dart';

class RabbitForm extends StatefulWidget {
  @override
  _RabbitFormState createState() => _RabbitFormState();
}

class _RabbitFormState extends State<RabbitForm> {
  ApiHandler apiHandler = ApiHandler(); // Create instance here
  final TextEditingController _tagNoController = TextEditingController();
  final TextEditingController _motherController = TextEditingController();
  final TextEditingController _fatherController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _diseasesController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _priceSoldController = TextEditingController();
  final TextEditingController _cageController = TextEditingController();
  final TextEditingController _imagesController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  String? _selectedSex; // Variable to hold the selected sex
  String? _selectedBreed; // Variable to hold the selected breed
  DateTime? _selectedDate;

  // List of rabbit breeds for the dropdown
  final List<String> _rabbitBreeds = [
    'Flemish Giant rabbit',
    'Dutch Rabbit',
    'Flemish Giant Rabbit',
    'Californian rabbit',
    'Holland Lop',
    'Netherland Dwarf Rabbit',
    'Rex Rabbit',
    'Mini Lop Rabbit',
    'Harlequin Rabbit',
    'English Lop Rabbit'
  ];

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

  Future<File> get _rLocalFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/rabbits.json');
  }

  Future<void> _submitForm() async {
    if (_tagNoController.text.isEmpty) {
      _alertEmptyField("TagNo");
      return;
    }
    if (_selectedSex == null) {
      _alertEmptyField("Sex");
      return;
    }
    if (_selectedBreed == null) {
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

    // Create JSON representation
    Map<String, dynamic> rabbitData = {
      'tagNo': _tagNoController.text,
      'present': 'Yes',
      'breed': _selectedBreed, // Use selected breed from dropdown
      'mother': _motherController.text,
      'father': _fatherController.text,
      'sex': _selectedSex, // Use the selected sex
      'origin': _originController.text,
      'diseases': _diseasesController.text,
      'comments': _commentsController.text,
      'weight': _weightController.text,
      'price_sold': _priceSoldController.text,
      'cage': _cageController.text,
      'birthday': _selectedDate!.toIso8601String(),
      'images': _imagesController.text,
    };

    String jsonStr = jsonEncode(rabbitData);
    print("JSON DATA ::: $rabbitData");

    const int timeoutDuration = 5000;
    final response =
        await apiHandler.APIpost('/api/rabbits/create_rabbit', rabbitData);

    if (response == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Rabbit ${_tagNoController.text} data saved successfully!')),
      );
      _clearForm();
    }
  }

  void _clearForm() {
    setState(() {
      _tagNoController.clear();
      _motherController.clear();
      _fatherController.clear();
      _originController.clear();
      _diseasesController.clear();
      _commentsController.clear();
      _weightController.clear();
      _priceSoldController.clear();
      _cageController.clear();
      _imagesController.clear();
      _birthdayController.clear();
      _selectedDate = null;
      _selectedSex = null;
      _selectedBreed = null;
    });

    print('Form has been cleared');
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
            buildBreedDropdown(), // Dropdown for selecting breed
            buildTextField('Mother', _motherController),
            buildTextField('Father', _fatherController),
            buildSexDropdown(), // Dropdown for sex selection
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
                    border: InputBorder.none,
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBreedDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: DropdownButtonFormField<String>(
        value: _selectedBreed,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
          ),
          labelText: 'Breed',
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.lightBlueAccent,
          ),
        ),
        items: _rabbitBreeds.map<DropdownMenuItem<String>>((String breed) {
          return DropdownMenuItem<String>(
            value: breed,
            child: Text(breed),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedBreed = newValue; // Update the selected breed
          });
        },
        validator: (value) => value == null ? 'Please select breed' : null,
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.lightBlueAccent,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.lightBlue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget buildSexDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedSex,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Sex',
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.lightBlueAccent,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent),
          ),
        ),
        items: ['Male', 'Female'].map<DropdownMenuItem<String>>((String sex) {
          return DropdownMenuItem<String>(
            value: sex,
            child: Text(sex),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedSex = newValue;
          });
        },
        validator: (value) => value == null ? 'Please select sex' : null,
      ),
    );
  }
}
