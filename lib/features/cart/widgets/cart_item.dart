import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    this.image,
    this.text,
    this.desc,
    this.onAdd,
    this.onMin,
    this.onRemove,
    this.number,
    required this.isLoading
  });

  final String? image;
  final String? text;
  final String? desc;
  final VoidCallback? onAdd;
  final VoidCallback? onMin;
  final VoidCallback? onRemove;
  final int? number;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (image != null)
                    Image.network(
                      image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  const Gap(6),
                  if (text != null)
                    CustomText(
                      text: text!,
                      weight: FontWeight.bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (desc != null)
                    CustomText(
                      text: desc!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const Gap(12),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: onMin,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: const Icon(
                          CupertinoIcons.minus,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const Gap(12),
                    CustomText(
                      text: (number ?? 0).toString(),
                      size: 18,
                    ),
                    const Gap(12),
                    GestureDetector(
                      onTap: onAdd,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: const Icon(
                          CupertinoIcons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(14),
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: isLoading? CupertinoActivityIndicator() :Center(
                      child: CustomText(
                        text: 'Remove',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
