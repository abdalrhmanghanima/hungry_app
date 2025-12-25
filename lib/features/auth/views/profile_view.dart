import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/data/user_model.dart';
import 'package:hungry_app/features/auth/views/login_view.dart';
import 'package:hungry_app/features/auth/widgets/custom_user_text_field.dart';
import 'package:hungry_app/shared/custom_button.dart';
import 'package:hungry_app/shared/custom_snack.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../shared/custom_text.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _visa = TextEditingController();

  UserModel? userModel;
  AuthRepo authRepo = AuthRepo();
  File? selectedImage;
  bool isLoading = false;
  Future<void> autoLogin() async {
    final user = await authRepo.autoLogin();

    setState(() {
      userModel = user;
    });

    if (!authRepo.isGuest) {
      await getProfileData();
    }
  }

  Future<void> getProfileData() async {
    try {
      final user = await authRepo.getProfileData();

      setState(() {
        userModel = user;

        _name.text = userModel?.name ?? '';
        _email.text = userModel?.email ?? '';
        _address.text = userModel?.address ?? '';
      });
    } catch (e) {
      String errorMsg = "Error In Profile";
      if (e is ApiError) {
        errorMsg = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> updateProfileData() async {
    try {
      setState(() => isLoading = true);
      final user = await authRepo.updateProfileData(
        name: _name.text.trim(),
        email: _email.text.trim(),
        address: _address.text.trim(),
        imageFile: selectedImage,
        visa: _visa.text.trim(),
      );
      setState(() => isLoading = true);
      setState(() => userModel = user);
      await getProfileData();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnack("Profile Updated Successfully"));
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      String errorMsg = "Error In Profile";
      if (e is ApiError) {
        errorMsg = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
    }
  }

  Future<void> logOut()async {
    await authRepo.logOut();
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginView()));
  }

  @override
  void initState() {
    autoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool guest = authRepo.isGuest;

    if (guest) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Guest Mode', style: TextStyle(fontSize: 18)),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginView()),
                  );
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

     return GestureDetector(
       onTap: () => FocusScope.of(context).unfocus(),
       child: Scaffold(
         backgroundColor: Colors.white,
         appBar: AppBar(
           automaticallyImplyLeading: false,
           elevation: 0,
           scrolledUnderElevation: 0,
           backgroundColor: Colors.white,
           leading: GestureDetector(
             onTap: () {
               showDialog(
                 context: context,
                 builder: (context) => AlertDialog(
                   title: const Text('Confirm Exit'),
                   content: const Text('Are you sure you want to exit?'),
                   actions: [
                     TextButton(
                       onPressed: () {
                         Navigator.of(context).pop();
                       },
                       child: const Text('Cancel'),
                     ),
                     TextButton(
                       onPressed: logOut,
                       child: const Text(
                         'Exit',
                         style: TextStyle(color: Colors.red),
                       ),
                     ),
                   ],
                 ),
               );
             },
             child: Icon(Icons.logout, color: AppColors.primary),
           ),
           actions: [
             GestureDetector(
               onTap: () {
                 showDialog(
                   context: context,
                   builder: (context) => AlertDialog(
                     title: const Text('Confirm Edit'),
                     content: const Text('Do You Want to Update Profile?'),
                     actions: [
                       TextButton(
                         onPressed: () {
                           Navigator.of(context).pop();
                         },
                         child: const Text('Cancel'),
                       ),
                       TextButton(
                         onPressed: () async {
                           Navigator.of(context).pop();
                           await updateProfileData();
                         },
                         child: const Text(
                           'Update Profile',
                           style: TextStyle(color: Colors.red),
                         ),
                       ),
                     ],
                   ),
                 );
               },
               child: isLoading
                   ? CupertinoActivityIndicator()
                   : Icon(CupertinoIcons.pencil, color: Colors.black, size: 27),
             ),
             Gap(7),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
               child: SvgPicture.asset(
                 'assets/icon/settings.svg',
                 width: 22,
                 color: Colors.black,
               ),
             ),
           ],
         ),
         body: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
           child: RefreshIndicator(
             displacement: 20,
             backgroundColor: AppColors.primary,
             color: Colors.white,
             onRefresh: () async {
               if (authRepo.isGuest) return;

               setState(() {
                 userModel = null;
               });
               await getProfileData();
             },


             child: SingleChildScrollView(
               physics: const AlwaysScrollableScrollPhysics(),
               padding: const EdgeInsets.symmetric(horizontal: 15),
               child: Skeletonizer(
                 enabled: userModel == null,
                 child: Column(
                   children: [
                     Center(
                       child: Container(
                         height: 110,
                         width: 110,
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           image: selectedImage != null
                               ? DecorationImage(
                             image: FileImage(selectedImage!),
                             fit: BoxFit.cover,
                           )
                               : null,
                           border: Border.all(
                             width: 1,
                             color: AppColors.primary,
                           ),
                           color: Colors.transparent,
                         ),
                         clipBehavior: Clip.antiAlias,
                         child: selectedImage != null
                             ? Image.file(selectedImage!, fit: BoxFit.cover)
                             : (userModel?.image != null &&
                             userModel!.image!.isNotEmpty)
                             ? Image.network(
                           userModel!.image!,
                           fit: BoxFit.cover,
                           errorBuilder: (context, err, builder) =>
                               Icon(Icons.person),
                         )
                             : Icon(Icons.person),
                       ),
                     ),
                     Gap(10),
                     CustomButton(
                       onTap: pickImage,
                       text: selectedImage != null
                           ? 'Upload Image'
                           : 'Change Image',
                       width: 150,
                     ),
                     Gap(20),
                     CustomUserTextField(
                         controller: _name,
                         label: 'Name'
                     ),
                     Gap(30),
                     CustomUserTextField(
                         controller: _email,
                         label: 'Email'
                     ),
                     Gap(30),
                     CustomUserTextField(
                       controller: _address,
                       label: 'Delivery Address',
                     ),
                     Gap(36),
                     Divider(),
                     Gap(10),
                     userModel?.visa == null
                         ? CustomUserTextField(
                       controller: _visa,
                       textInputType: TextInputType.number,
                       label: 'Add Visa Card',
                     )
                         : ListTile(
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadiusGeometry.circular(20),
                       ),
                       tileColor: Color(0xffF3F4F6),
                       contentPadding: EdgeInsets.symmetric(
                         vertical: 0,
                         horizontal: 16,
                       ),
                       leading: Image.asset(
                         'assets/icon/profileVisa.png',
                         width: 50,
                       ),
                       title: CustomText(
                         text: 'Debit card',
                         color: Colors.black,
                       ),
                       subtitle: CustomText(
                         text: userModel?.visa ?? '**** **** ****',
                         color: Colors.black,
                       ),
                       trailing: CustomText(
                         text: 'Default',
                         color: Colors.black,
                       ),
                     ),
                   ],
                 ),
               ),
             ),
           ),
         ),
       ),
     );

  }
}
