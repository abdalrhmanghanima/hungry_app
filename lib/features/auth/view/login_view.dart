import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/widgets/custom_btn.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:hungry_app/shared/custom_textField.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Gap(100),
                  SvgPicture.asset("assets/logo/logo.svg"),
                  Gap(10),
                  CustomText(
                    text: "Welcome Back Discover The Best Fast Food",
                    color: Colors.white,
                    size: 13,
                    weight: FontWeight.w500,
                  ),
                  Gap(60),
                  CustomTextfield(
                    hint: "Email Address",
                    isPassword: false,
                    controller: emailController,
                  ),
                  Gap(20),
                  CustomTextfield(
                    hint: "Password",
                    isPassword: true,
                    controller: passController,
                  ),
                  Gap(30),
                  CustomAuthBtn(text: "Login",onTap: () {
                    if(_formKey.currentState!.validate())
                      print("success register");
                  },)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
