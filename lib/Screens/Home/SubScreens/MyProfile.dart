import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';
import 'package:watchminter/Models/UserModel.dart';
import 'package:watchminter/Screens/Auth/LoginScreen.dart';
import 'package:watchminter/Screens/Auth/Signup/Verification/PhoneAuthScreen.dart';
import 'package:watchminter/Screens/Home/UpdateProfileScreen.dart';
import 'package:watchminter/Screens/ViewProfile.dart';

import '../ContactUsScreen.dart';
import '../ReviewScreen.dart';

class MyProfile extends StatefulWidget {
  UserModel userModel;
  MyProfile(this.userModel,{Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}



class _MyProfileState extends State<MyProfile> {
  var rate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(MediaQuery.of(context).size.height * .2),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.height * .15,
                        height: MediaQuery.of(context).size.height * .15,
                        fit: BoxFit.cover,
                        imageUrl: widget.userModel.image??"assets/images/watch.png",
                        placeholder: (context, url) =>Image.asset("assets/images/watch.png"),
                        errorWidget: (context, url, error) =>Container(color: AppColors.white, child: Image.asset("assets/images/watch.png")),
                      ),
                    ),
                    Text(
                      widget.userModel.name,
                      style: TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Gotham",
                          fontSize: 22),
                    ).marginOnly(top: 18),
                    InkWell(
                      onTap: ()async{
                        await Clipboard.setData(ClipboardData(text: widget.userModel.id));
                        Get.snackbar("Copy Successfull", "Id copied to clipboard",
                            colorText: AppColors.white,
                            icon: Icon(Icons.error_outline, color: Colors.white),
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: AppColors.orange);
                      },
                      child: Text(
                        widget.userModel.id,
                        style: TextStyle(color: AppColors.orange, letterSpacing: 2),
                      ).marginOnly(top: 10),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: (){
                          Get.to(ViewProfile(widget.userModel),transition: Transition.leftToRight);
                        },
                        child: Text(
                          "View Profile",
                          style: TextStyle(
                              color: AppColors.background,
                              fontFamily: "Gotham",
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ).marginOnly(top: 50,left: 20),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ).marginOnly(top: 12,left: 12,right: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: (){
                          Get.to(UpdateProfileScreen(widget.userModel),transition: Transition.leftToRight);
                        },
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                              color: AppColors.background,
                              fontFamily: "Gotham",
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ).marginOnly(top: 30,left: 20),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ).marginOnly(top: 12,left: 12,right: 12),
                    widget.userModel.idVerification=="Yes"
                        ?Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                            "Verified",
                            style: TextStyle(
                            color: AppColors.background,
                            fontSize: 20,
                            fontFamily: "Gotham",
                            fontWeight: FontWeight.bold),
                            ).marginOnly(top: 30,left: 20),
                            Icon(Icons.verified_sharp,color: AppColors.orange,).marginOnly(top: 30,right: 20),
                          ],
                        )
                        :InkWell(
                      onTap: (){
                        print(widget.userModel.CountryCode.toString());
                        Get.to(PhoneAuthScreen(widget.userModel));
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Verify Id",
                          style: TextStyle(
                              color: AppColors.background,
                              fontSize: 20,
                              fontFamily: "Gotham",
                              fontWeight: FontWeight.bold),
                        ).marginOnly(top: 30,left: 20),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ).marginOnly(top: 12,left: 12,right: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: (){
                           Get.to(()=>ReviewScreen());
                        },
                        child: Text(
                          "Reviews",
                          style: TextStyle(
                              color: AppColors.background,
                              fontSize: 20,
                              fontFamily: "Gotham",
                              fontWeight: FontWeight.bold),
                        ).marginOnly(top: 30,left: 20),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ).marginOnly(top: 12,left: 12,right: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: (){
                          Get.to(()=>ContactUsScreen());
                        },
                        child: Text(
                          "Contact us",
                          style: TextStyle(
                              color: AppColors.background,
                              fontSize: 20,
                              fontFamily: "Gotham",
                              fontWeight: FontWeight.bold),
                        ).marginOnly(top: 30,left: 20),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ).marginOnly(top: 12,left: 12,right: 12),

                    InkWell(
                      onTap: (){
                        confirmDialog();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app,color: AppColors.orange,).marginOnly(top: 30,left: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Log out",
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontSize: 20,
                                  fontFamily: "Gotham",
                                  fontWeight: FontWeight.bold),
                            ).marginOnly(top: 30,left: 20),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ).marginOnly(top: 12,left: 12,right: 12),
                    InkWell(
                      onTap: (){
                        DeleteConfirmDialog();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.delete,color: AppColors.orange,).marginOnly(top: 30,left: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Delete my account",
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontSize: 20,
                                  fontFamily: 'Gotham',
                                  fontWeight: FontWeight.bold),
                            ).marginOnly(top: 30,left: 20),
                          )
                        ],

                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.white70,
                    ).marginOnly(top: 12,left: 12,right: 12)
                  ],
                ).marginOnly(top: 80),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    EasyLoading.dismiss();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  void confirmDialog() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      backgroundColor: AppColors.orange,
      text: 'Do you want to logout',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: AppColors.orange,
      onConfirmBtnTap: ()async{
        EasyLoading.show();
        await DatabaseHelper.signOut();
        EasyLoading.dismiss();
        final prefs= await SharedPreferences.getInstance();
        await prefs.setBool("loggedIn", false);
        await prefs.remove('usersModel');
        Get.offAll(LoginScreen());
      }
    );

    AlertDialog(
      title: Text("Confirm"),
      alignment: Alignment.center,
      actions: [
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("Log Out",style: TextStyle(color: Colors.white,fontSize: 15),)) ,
        InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text("Cancel",style: TextStyle(color: Colors.black54,fontSize: 15),)),
        ) ,
      ],

      );
  }
  void DeleteConfirmDialog() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      backgroundColor: AppColors.orange,
      text: 'Do you want to Delete You Account',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: AppColors.orange,
      onConfirmBtnTap: ()async{
        EasyLoading.show();
        await DatabaseHelper().DeleteAccount();
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "Account Deleted Successfully");
        Get.offAll(LoginScreen());
      }
    );

    AlertDialog(
      title: Text("Confirm"),
      alignment: Alignment.center,
      actions: [
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("Log Out",style: TextStyle(color: Colors.white,fontSize: 15),)) ,
        InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text("Cancel",style: TextStyle(color: Colors.black54,fontSize: 15),)),
        ) ,
      ],

      );
  }

}
