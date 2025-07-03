import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_drive/services/image_upload_service.dart';
import '../services/rabbit_api_service.dart';
import '../models/rabbit.dart';
import '../widgets/image_capture_uploader.dart';

class NewRabbitPage extends StatefulWidget {
  const NewRabbitPage({super.key});

  @override
  State<NewRabbitPage> createState() => _NewRabbitPageState();
}

class _NewRabbitPageState extends State<NewRabbitPage> {
  final RabbitApiService apiHandler = RabbitApiService();
  final ImageUploadService imageUploadService = ImageUploadService();

  final _formKey = GlobalKey<FormState>();
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

  String? _selectedSex;
  String? _selectedBreed;
  DateTime? _selectedDate;
  File? _rabbitImage;

  final List<String> _rabbitBreeds = [
    'Flemish Giant rabbit',
    'Dutch Rabbit',
    'Californian rabbit',
    'Holland Lop',
    'Netherland Dwarf Rabbit',
    'Rex Rabbit',
    'Mini Lop Rabbit',
    'Harlequin Rabbit',
    'English Lop Rabbit',
  ];

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _submitForm() async {
  if (!_formKey.currentState!.validate() || _selectedDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all required fields")),
    );
    return;
  }

  String? uploadedImageName;
  if (_rabbitImage != null) {
    try {
      uploadedImageName = await imageUploadService.uploadImage(_rabbitImage!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed: $e")),
      );
      return;
    }
  }

  final rabbit = Rabbit(
    tagNo: _tagNoController.text.trim(),
    birthday: _selectedDate,
    breed: _selectedBreed ?? '',
    mother: _motherController.text.trim(),
    father: _fatherController.text.trim(),
    sex: _selectedSex ?? '',
    origin: _originController.text.trim(),
    diseases: _diseasesController.text.trim(),
    comments: _commentsController.text.trim(),
    weight: _weightController.text.trim(),
    priceSold: _priceSoldController.text.trim(),
    cage: _cageController.text.trim(),
    images: uploadedImageName != null ? [uploadedImageName] : [],
  );

  final response = await apiHandler.createRabbit(rabbit, null);

  if (response == 201) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Rabbit ${rabbit.tagNo} created!")),
    );
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to create rabbit")),
    );
  }
}

  Widget _buildTextField(String label, TextEditingController controller,
      {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required && (controller.text.isEmpty)
            ? (_) => 'Please enter $label'
            : null,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: value,
        onChanged: onChanged,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        validator: (val) => val == null ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _selectDate,
      child: AbsorbPointer(
        child: TextFormField(
          controller: _birthdayController,
          decoration: const InputDecoration(
            labelText: 'Birthday',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          validator: (_) => _selectedDate == null ? 'Please select birthday' : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Rabbit Entry'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ImageCaptureWidget(
                  onImageSelected: (file) {
                    setState(() {
                      _rabbitImage = file;
                    });
                  },
                ),
                _buildTextField("Tag No", _tagNoController),
                _buildDatePicker(),
                _buildDropdown(
                  label: "Breed",
                  value: _selectedBreed,
                  items: _rabbitBreeds,
                  onChanged: (val) => setState(() => _selectedBreed = val),
                ),
                _buildDropdown(
                  label: "Sex",
                  value: _selectedSex,
                  items: ['Male', 'Female'],
                  onChanged: (val) => setState(() => _selectedSex = val),
                ),
                _buildTextField("Mother", _motherController),
                _buildTextField("Father", _fatherController),
                
                _buildTextField("Origin", _originController, required: false),
                _buildTextField("Diseases", _diseasesController, required: false),
                _buildTextField("Comments", _commentsController),
                _buildTextField("Weight", _weightController, required: false),
                _buildTextField("Price Sold", _priceSoldController, required: false),
                
                //_buildTextField("Images", _imagesController, required: false),
                
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Submit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
