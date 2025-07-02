// lib/utils/form_utils.dart

import 'package:flutter/material.dart';
import 'constants.dart';

Widget buildTextField(String labelText, TextEditingController controller) {
  return Padding(
    padding: fieldPadding,
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: labelTextColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: borderColor, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: focusedBorderColor, width: 2.0),
        ),
      ),
    ),
  );
}
