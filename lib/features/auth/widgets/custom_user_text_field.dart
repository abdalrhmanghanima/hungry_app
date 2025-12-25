import 'package:flutter/material.dart';
import 'package:hungry_app/core/constants/app_colors.dart';

class CustomUserTextField extends StatelessWidget {
  const CustomUserTextField({
    super.key,
    required this.controller,
    required this.label,
    this.textInputType,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? textInputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      cursorColor: AppColors.primary,
      cursorHeight: 20,
      style: TextStyle(color: AppColors.primary),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        labelStyle: TextStyle(color: AppColors.primary),
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
