import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.size,
    this.weight,
    this.maxLines,
    this.align,
    this.overflow,
  });

  final String text;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final int? maxLines;
  final TextAlign? align;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      textAlign: align ?? TextAlign.start,
      textScaler: const TextScaler.linear(1.0),
      style: TextStyle(fontSize: size, fontWeight: weight, color: color),
    );
  }
}
