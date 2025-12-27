import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.image,
    required this.text,
    required this.desc,
    required this.rate,
  });

  final String image;
  final String text;
  final String desc;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade100,
                  Colors.grey.shade300,
                  Colors.grey.shade400,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Image.asset(
                        'assets/icon/shadow.png',
                        color: Colors.black26,
                      ),
                      Image.network(
                        image,
                        width: 130,
                        height: 130,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: text,
                          weight: FontWeight.bold,
                          size: 13,
                          color: AppColors.primary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        CustomText(
                          text: desc,
                          size: 10,
                          color: Colors.black54,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.star_fill,
                              size: 16,
                              color: Colors.yellow.shade600,
                            ),
                            const Gap(6),
                            CustomText(
                              text: rate,
                              size: 15,
                              weight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                            const Spacer(),
                            Icon(
                              CupertinoIcons.heart,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
