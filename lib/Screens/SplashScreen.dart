import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Screens/Auth/LoginScreen.dart';
import 'package:watchminter/Screens/Home/HomeScreen.dart';

import '../Models/UserModel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: new AssetImage("assets/images/splashImg.png"),
          )),
        ),
      ],
    ));
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), ()  {
       get();
      
    });
  }
  get()async{
    final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool("loggedIn",false);
    bool? result = true;
     setState(() {
        result = prefs.getBool("loggedIn");
     });
     if(result==true){
       print("User Present");
       Map<String,dynamic> userdata= jsonDecode(prefs.getString("usersModel")!);
       UserModel userModel =UserModel.fromMap(userdata);
       await Firebase.initializeApp();
       Get.offAll(HomeScreen(userModel),transition: Transition.leftToRight);
     }
     else{
       print("User Absent");
       Get.offAll(LoginScreen(),transition: Transition.zoom);
     }
  }
}
