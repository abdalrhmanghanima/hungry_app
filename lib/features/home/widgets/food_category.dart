import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../data/models/data.dart';

class FoodCategory extends StatelessWidget {
  const FoodCategory({
    super.key,
    required this.selectedIndex,
    required this.categories,
    required this.onSelected,
  });

  final int selectedIndex;
  final List<Data> categories;
  final Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categories.length, (index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 15),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xffF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomText(
                text: categories[index].name ?? '',
                weight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          );
        }),
      ),
    );
  }
}
