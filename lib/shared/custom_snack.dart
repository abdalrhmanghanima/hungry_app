import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'custom_text.dart';

SnackBar customSnack(errorMsg){
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red.shade900,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    content: Row(
      children: [
        const Icon(CupertinoIcons.info, color: Colors.white),
        const Gap(15),
        Expanded(
          child: CustomText(
            text: errorMsg,
            color: Colors.white,
            size: 14,
            weight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}