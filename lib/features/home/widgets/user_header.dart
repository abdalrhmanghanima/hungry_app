import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key, required this.userName, required this.userImage});

  final String userName, userImage;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/logo/logo.svg",
              color: AppColors.primary,
              height: 35,
            ),
            Gap(5),
            CustomText(
              text: userName??"Hello, Ghanima",
              size: 16,
              weight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ],
        ),
        Spacer(),
        CircleAvatar(
          radius: 31,
          backgroundColor: AppColors.primary,
          backgroundImage: userImage.isNotEmpty
              ? NetworkImage(userImage)
              : null,
          child: userImage.isEmpty
              ? Icon(Icons.person, color: Colors.white, size: 30)
              : null,
        ),

      ],
    );
  }
}
