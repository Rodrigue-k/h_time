import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLines;
  final void Function(String)? onChanged;

  const TaskTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.validator,
    this.maxLines,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      style: GoogleFonts.roboto(
        color: Colors.black87,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
      //textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: GoogleFonts.roboto(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
      ),
    );
  }
}
