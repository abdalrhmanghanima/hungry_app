import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class SpicySlider extends StatefulWidget {
  const SpicySlider({super.key, required this.value, required this.onChanged, required this.image});
final double value;
final ValueChanged<double>onChanged;
final String image;

  @override
  State<SpicySlider> createState() => _SpicySliderState();
}

class _SpicySliderState extends State<SpicySlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 4,
            child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(widget.image, fit: BoxFit.contain,))),
        Gap(12),
        Expanded(
          flex: 6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text:
                'Customize Your Burger\n To Your Tastes.\n Ultimate Experience',
              ),
              Slider(
                value: widget.value,
                max: 1,
                min: 0,
                onChanged: widget.onChanged,
                activeColor: AppColors.primary,
                inactiveColor: Colors.grey.shade300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🥶'),
                  Text('🌶')
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
