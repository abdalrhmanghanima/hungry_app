import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/widgets/custom_btn.dart';

import '../../../shared/custom_text.dart';
import '../../../shared/custom_textField.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController=TextEditingController();
    TextEditingController nameController=TextEditingController();
    TextEditingController passController=TextEditingController();
    TextEditingController confirmController=TextEditingController();
    final GlobalKey<FormState>formKey=GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Gap(100),
                SvgPicture.asset("assets/logo/logo.svg"),
                Gap(60),
                CustomTextfield(
                  hint: "Name",
                  isPassword: false,
                  controller: nameController,
                ),
                Gap(15),
                CustomTextfield(
                  hint: "Email Address",
                  isPassword: false,
                  controller: emailController,
                ),
                Gap(15),
                CustomTextfield(
                  hint: "Password",
                  isPassword: true,
                  controller: passController,
                ),
                Gap(15),
                CustomTextfield(
                  hint: "Confirm Password",
                  isPassword: true,
                  controller: passController,
                ),
                Gap(30),
                CustomAuthBtn(text: "Sign Up",onTap: () {
                  if(formKey.currentState!.validate())
                    print("success register");
                },),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
