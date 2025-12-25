import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/views/signup_view.dart';
import 'package:hungry_app/features/auth/widgets/custom_btn.dart';
import 'package:hungry_app/root.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:hungry_app/shared/custom_textField.dart';

import '../../../shared/custom_snack.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  bool isLoading = false;
  final AuthRepo authRepo = AuthRepo();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return ;
      try {
        setState(() => isLoading = true);
        final user = await authRepo.login(
          emailController.text.trim(),
          passController.text.trim(),
        );

        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Root()));
        }
      } catch (e) {
        String errorMsg = 'Unhandled error in login';
        if (e is ApiError) errorMsg = e.message;

        ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
      } finally {
        setState(() => isLoading = false);
      }
  }
  @override
  void initState() {
    emailController.text='Ghanima15@gmail.com';
    passController.text='12345678';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Gap(constraints.maxHeight * 0.18),

                          SvgPicture.asset(
                            "assets/logo/logo.svg",
                            color: AppColors.primary,
                          ),

                          const Gap(10),

                          CustomText(
                            text: "Welcome Back Discover The Best Fast Food",
                            color: AppColors.primary,
                            size: 13,
                            weight: FontWeight.w500,
                          ),

                          const Gap(40),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Gap(30),

                                  CustomTextfield(
                                    isPassword: false,
                                    hint: "Email Address",
                                    controller: emailController,
                                  ),

                                  const Gap(15),

                                  CustomTextfield(
                                    hint: "Password",
                                    controller: passController,
                                    isPassword: true,
                                  ),

                                  const Gap(20),

                                  isLoading
                                      ? const CupertinoActivityIndicator(
                                          color: Colors.white,
                                        )
                                      : CustomAuthBtn(
                                          color: AppColors.primary,
                                          textColor: Colors.white,
                                          text: "Login",
                                          onTap: login,
                                        ),

                                  const Gap(15),

                                  CustomAuthBtn(
                                    color: Colors.white,
                                    textColor: AppColors.primary,
                                    text: "Create new account",
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SignupView(),
                                        ),
                                      );
                                    },
                                  ),

                                  const Gap(20),

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
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
