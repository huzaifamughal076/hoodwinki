import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';

import '../../Models/UserModel.dart';
import 'HomeScreen.dart';

class UpdateProfileScreen extends StatefulWidget {
   UserModel userModel;
   UpdateProfileScreen(this.userModel,{Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final formKey = GlobalKey<FormState>();
  var focusNodeEmail=FocusNode();
  var focusNodeName=FocusNode();
  var focusNodePassword=FocusNode();
  var focusNodeNewPassword=FocusNode();
  var focusNodeConfirmPassword=FocusNode();
  var focusNodeDob=FocusNode();
  var email_elevation=0.0;
  var name_elevation=0.0;
  var password_elevation=0.0;
  var new_password_elevation=0.0;
  var confirm_password_elevation=0.0;
  var dob_elevation=0.0;

  var Name;
  var currentPassword;
  var newPassword;
  var confirmPassword;

  String? _image;

  @override
  void initState() {
    focusNodeEmail.addListener(() {
      if (focusNodeEmail.hasFocus) {
        setState(() {
          email_elevation=10; //Check your conditions on text variable
        });
      }else{
        setState(() {
          email_elevation=0; //Check your conditions on text variable
        });
      }
    });
    focusNodeName.addListener(() {
      if (focusNodeName.hasFocus) {
        setState(() {
          name_elevation=10; //Check your conditions on text variable
        });
      }else{
        setState(() {
          name_elevation=0; //Check your conditions on text variable
        });
      }
    });
    focusNodePassword.addListener(() {
      if (focusNodePassword.hasFocus) {
        setState(() {
          password_elevation=10; //Check your conditions on text variable
        });
      }else{
        setState(() {
          password_elevation=0; //Check your conditions on text variable
        });
      }
    });
    focusNodeNewPassword.addListener(() {
      if (focusNodeNewPassword.hasFocus) {
        setState(() {
          new_password_elevation=10; //Check your conditions on text variable
        });
      }else{
        setState(() {
          new_password_elevation=0; //Check your conditions on text variable
        });
      }
    });
    focusNodeConfirmPassword.addListener(() {
      if (focusNodeConfirmPassword.hasFocus) {
        setState(() {
          confirm_password_elevation=10; //Check your conditions on text variable
        });
      }else{
        setState(() {
          confirm_password_elevation=0; //Check your conditions on text variable
        });
      }
    });
    focusNodeDob.addListener(() {
      if (focusNodeDob.hasFocus) {
        setState(() {
          dob_elevation=10; //Check your conditions on text variable
        });
      }else{
        setState(() {
          dob_elevation=0; //Check your conditions on text variable
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white
              ),
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(color: AppColors.orange),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          "assets/images/back.png",
                          width: 20,
                          height: 20,
                        ).marginOnly(top: 30, left: 12).paddingAll(5),
                      ),
                      Text(
                        "Update Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Gotham"),
                      ).marginOnly(top: 30, left: 12),

                    ],
                  ),
                ),
                Stack(
                  children: [
                    _image != null
                        ?
                    //local image
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(MediaQuery.of(context).size.height * .1),
                      child: Image.file(
                        File(_image!),
                        width: MediaQuery.of(context).size.height * .17,
                        height: MediaQuery.of(context).size.height * .17,
                        fit: BoxFit.cover,
                      ),
                    )
                        :ClipRRect(
                      borderRadius:
                      BorderRadius.circular(MediaQuery.of(context).size.height * .1),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.height * .17,
                        height: MediaQuery.of(context).size.height * .17,
                        fit: BoxFit.cover,
                        imageUrl: widget.userModel.image??"assets/images/watch.png",
                        placeholder: (context, url) =>Image.asset("assets/images/watch.png"),
                        errorWidget: (context, url, error) =>
                            CircleAvatar(
                                child: Icon(CupertinoIcons.person)),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: InkWell(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image
                          final XFile? image =
                              await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            log("image Path: ${image.path}.......${image.mimeType}");
                            setState(() {
                              _image = image.path;
                            });

                          }
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(Icons.edit, color: Colors.black),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  50,
                                ),
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(2, 4),
                                  color: Colors.black.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 3,
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
                Material(
                borderRadius: BorderRadius.circular(10),
                  elevation: 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height*0.45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: email_elevation,
                          shadowColor: AppColors.orange,
                          child: TextFormField(
                            focusNode: focusNodeEmail,
                            keyboardType: TextInputType.emailAddress,
                            initialValue: widget.userModel.email,
                            style: const TextStyle(color: AppColors.background),
                            readOnly: true,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Email",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ).marginOnly(left: 12, right: 12,top: 12),
                        Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: name_elevation,
                          shadowColor: AppColors.orange,
                          child: TextFormField(
                            focusNode: focusNodeName,
                            keyboardType: TextInputType.name,
                            initialValue: widget.userModel.name,
                            validator: (name){
                              if(name!.isEmpty||name==''||name==null){
                                return "Name Field Required";
                              }else{
                                Name= name;
                                return null;
                              }
                            },
                            onChanged: (val){
                              setState(() {
                                Name = val;
                              });
                            },
                            style: const TextStyle(color: AppColors.background),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Name",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ).marginOnly(left: 12, right: 12,top: 15),
                        Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: password_elevation,
                          shadowColor: AppColors.orange,
                          child: TextFormField(
                            obscureText: true,
                            focusNode: focusNodePassword,
                            keyboardType: TextInputType.name,
                            initialValue: "******",
                            validator: (password){
                              if(password!.isEmpty||password==null||password==''){
                                return "Password Required";
                              }
                            },
                            onChanged: (val){
                              currentPassword = val;
                            },
                            style: const TextStyle(color: AppColors.background),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Current Password",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ).marginOnly(left: 12, right: 12,top: 15),
                        Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: new_password_elevation,
                          shadowColor: AppColors.orange,
                          child: TextFormField(
                            obscureText: true,
                            focusNode: focusNodeNewPassword,
                            keyboardType: TextInputType.name,
                            validator: (ConfirmPassword){
                              if(confirmPassword!=newPassword){
                                return "Password doesn't match";
                              }
                              else{
                                return null;
                              }
                            },
                            onChanged: (val){
                              setState(() {
                                newPassword = val;
                              });
                            },
                            style: const TextStyle(color: AppColors.background),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "New Password",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ).marginOnly(left: 12, right: 12,top: 15),
                        Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: confirm_password_elevation,
                          shadowColor: AppColors.orange,
                          child: TextFormField(
                            obscureText: true,
                            focusNode: focusNodeConfirmPassword,
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: AppColors.background),
                            validator: (ConfirmPassword){
                              if(confirmPassword!=newPassword){
                                return "Password doesn't match";
                              }
                              else{
                                return null;
                              }
                            },
                            onChanged: (val){
                              setState(() {
                                confirmPassword=val;
                              });
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Confirm Password",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ).marginOnly(left: 12, right: 12,top: 15),
                        Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: dob_elevation,
                          shadowColor: AppColors.orange,
                          child: TextFormField(
                            focusNode: focusNodeDob,
                            keyboardType: TextInputType.name,
                            initialValue: widget.userModel.dob,
                            readOnly: true,
                            style: const TextStyle(color: AppColors.background),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "DOB (MM/DD/YYYY)",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              // enabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(10.0),
                              //   borderSide: const BorderSide(
                              //       color: AppColors.background, width: 1),
                              //),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              // disabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(25.0),
                              //   borderSide: const BorderSide(
                              //       color: Colors.transparent, width: 0),
                              // ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ).marginOnly(left: 12, right: 12,top: 15),
                        InkWell(
                          onTap: () async {
                            if(formKey.currentState!.validate()){
                              EasyLoading.show();
                              if(newPassword!=null && confirmPassword!=null){
                                widget.userModel.name = Name;
                                await DatabaseHelper().updateProfileWithNewPassword(_image,widget.userModel,currentPassword,newPassword);
                              }else{
                                widget.userModel.name = Name;
                                if(currentPassword!=null){
                                  await DatabaseHelper().updateProfile(_image,widget.userModel,currentPassword);
                                  EasyLoading.dismiss();
                                }
                                else{
                                  Fluttertoast.showToast(msg: "Please type the valid password");
                                  EasyLoading.dismiss();
                                }
                              }
                            }

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: BoxDecoration(
                                color: AppColors.orange,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "Update",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Gotham",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ).marginOnly(left: 12, right: 12, top: 30,bottom: 12),
                      ],
                    ),
                  ),
                ).marginOnly(left: 12,right: 12,top: 20)
              ],
            )
          ],
        ),
      ),
    );
  }
}
