import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

const List<String> list = <String>['Male', 'Female'];

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late File? _capturedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _capturedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Picker Example')),
      body: _capturedImage != null
          ? Image.file(_capturedImage!)
          : Center(child: Text('No image captured')),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureImage,
        child: Icon(Icons.camera),
      ),
    );
  }
}


class Rabbit {
  final String tagNo;
  //final DateTime birthday;
  final String breed;
  final String mother;
  final String father;
  final String sex;
  final String origin;
  final String diseases;
  final String comments;
  final String weight;
  final String priceSold;
  final String cage;
  final List<String> images;

  Rabbit({
    required this.tagNo,
    //required this.birthday,
    required this.breed,
    required this.mother,
    required this.father,
    required this.sex,
    required this.origin,
    required this.diseases,
    required this.comments,
    required this.weight,
    required this.priceSold,
    required this.cage,
    required this.images,
  });

  factory Rabbit.fromJson(Map<String, dynamic> json) {
    return Rabbit(
      tagNo: json['tagNo'],
      //birthday: DateTime.parse(json['birthday']),
      breed: json['breed'],
      mother: json['mother'],
      father: json['father'],
      sex: json['sex'],
      origin: json['origin'],
      diseases: json['diseases'],
      comments: json['comments'],
      weight: json['weight'],
      priceSold: json['price_sold'],
      cage: json['cage'],
      images: List<String>.from(json['images']),
    );
  }
}

class RabbitData {
  // A Map to store Rabbit objects using their tagNo as the key
  static final Map<String, Rabbit> rabbits = {};

  // Add a Rabbit to the Map
  static void addRabbit(Rabbit rabbit) {
    rabbits[rabbit.tagNo] = rabbit;
  }

  // Retrieve a Rabbit from the Map
  static Rabbit getRabbit(String tagNo) {
    return rabbits[tagNo]!;
  }
}

class NewRabbit extends StatefulWidget {
  const NewRabbit({super.key});

  @override
  _NewRabbitState createState() => _NewRabbitState();
}


class _NewRabbitState extends State<NewRabbit> {
  final TextEditingController _tagNoController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _cageNumberController = TextEditingController();
  final TextEditingController _motherController = TextEditingController();
  final TextEditingController _fatherController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _diseasesController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _priceSoldController = TextEditingController();
  final TextEditingController _imagesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Rabbit'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          buildTextField('Tag on the Rabbit', _tagNoController),
          buildTextField('Breed', _breedController),
          buildTextField('Birthday', _birthdayController),
          buildTextField('Cage Number', _cageNumberController),
          buildTextField('Mother', _motherController),
          buildTextField('Father', _fatherController),
          buildTextField('Origin', _originController),
          buildTextField('Diseases', _diseasesController),
          buildTextField('Comments', _commentsController),
          buildTextField('Weight', _weightController),
          buildTextField('Price sold', _priceSoldController),
          buildTextField('Images', _imagesController),
          // ... other widgets

          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownMenu<String>(
              initialSelection: list.first,
              onSelected: (String? value) {
                // This is called when the user selects an item.
                print("Selection made");
              },
              dropdownMenuEntries:
                  list.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 40,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime value) {
                  // handle changes to the selected date
                },
                // dateFormat: 'dd/MM/yyyy', // specify the date format
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraScreen()),
                );
              },
              child: const Text('Capture Image'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                // Access values using the controllers
                String tagNo = _tagNoController.text;
                String breed = _breedController.text;
                String birthday = _birthdayController.text;
                String cage = _cageNumberController.text;
                String mother = _motherController.text;
                String father = _fatherController.text;
                String sex = _fatherController.text;
                String origin = _originController.text;
                String diseases = _diseasesController.text;
                String comments = _commentsController.text;
                String weight = _weightController.text;
                String priceSold = _priceSoldController.text;
                String images = _imagesController.text;

                print("DONE HERE$tagNo");

                // Create a new Rabbit object with the collected values
                Rabbit rabbit = Rabbit(
                  tagNo: tagNo,
                  breed: breed,
                  mother: mother,
                  father: father,
                  sex: sex,
                  origin: origin,
                  diseases: diseases,
                  comments: comments,
                  weight: weight,
                  priceSold: priceSold,
                  cage: cage,
                  images: [
                    images
                  ], // You may need to split the images into a list
                );

                // Add the Rabbit to the data storage or perform other actions as needed
                // RabbitData.addRabbit(rabbit);
              },
              child: const Text('Save Rabbit'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText,
          ),
        ),
      ),
    );
  }
}
