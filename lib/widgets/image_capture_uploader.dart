import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCaptureWidget extends StatefulWidget {
  final void Function(File) onImageSelected;

  const ImageCaptureWidget({Key? key, required this.onImageSelected}) : super(key: key);

  @override
  State<ImageCaptureWidget> createState() => _ImageCaptureWidgetState();
}

class _ImageCaptureWidgetState extends State<ImageCaptureWidget> {
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);

    if (picked != null) {
      final file = File(picked.path);
      setState(() => _selectedImage = file);
      widget.onImageSelected(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedImage != null)
          Image.file(_selectedImage!, height: 150, fit: BoxFit.cover),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () => _pickImage(ImageSource.camera),
              tooltip: 'Capture from Camera',
            ),
            IconButton(
              icon: const Icon(Icons.photo),
              onPressed: () => _pickImage(ImageSource.gallery),
              tooltip: 'Pick from Gallery',
            ),
          ],
        ),
      ],
    );
  }
}
