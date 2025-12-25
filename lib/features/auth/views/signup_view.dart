import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/views/login_view.dart';
import 'package:hungry_app/features/auth/widgets/custom_btn.dart';
import 'package:hungry_app/root.dart';

import '../../../shared/custom_snack.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/custom_textField.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthRepo authRepo = AuthRepo();
  Future<void> signup() async {
    if (!formKey.currentState!.validate()) return;
      try {
        setState(() => isLoading = true);
        final user = await authRepo.signup(
          nameController.text.trim(),
          emailController.text.trim(),
          passController.text.trim(),
        );
        if (user != null) {
          Navigator.push(context, MaterialPageRoute(builder: (c) => Root()));
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        String errMsg = 'Error In Register';
        if (e is ApiError) errMsg = e.message;
        ScaffoldMessenger.of(context).showSnackBar(customSnack(errMsg));
      }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Gap(200),
              SvgPicture.asset("assets/logo/logo.svg", color: AppColors.primary),
              CustomText(
                text: 'Welcome To Our Food App',
                color: AppColors.primary,
              ),
              Gap(100),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Gap(30),
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
                        Gap(20),
                        isLoading?CupertinoActivityIndicator(color: Colors.white,):
                        CustomAuthBtn(
                          color: AppColors.primary,
                          textColor: Colors.white,
                          text: "Sign Up",
                          onTap: signup,
                        ),
                        Gap(10),
                        CustomAuthBtn(
                          textColor: AppColors.primary,
                          color: Colors.white,
                          text: "I already have an account",
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (c) => LoginView()),
                            );
                          },
                        ),
                        Gap(20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => Root()),
                            );
                          },
                          child: const CustomText(
                            text: 'Continue As a Guest?',
                            color: Colors.white,
                            weight: FontWeight.bold,
                            size: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
