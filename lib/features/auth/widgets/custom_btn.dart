import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CustomAuthBtn extends StatelessWidget {
  const CustomAuthBtn({super.key, this.onTap, required this.text});
final Function()?onTap;
final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
        ),
        width: double.infinity,
        child: Center(
          child: CustomText(
            text: text,
            size: 15,
            weight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
