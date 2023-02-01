import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';
import 'package:watchminter/Global/firebase_ref.dart';
import 'package:watchminter/Screens/Auth/Signup/Verification/PhoneAuthScreen.dart';
import 'package:watchminter/Screens/Home/HomeScreen.dart';

import '../../../../Constants/AppColors.dart';
import '../../../../Models/UserModel.dart';
import '../../LoginScreen.dart';

class MyVerify extends StatefulWidget {
  final verificationCode;
  UserModel userModel;
   MyVerify(this.verificationCode,this.userModel,{Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  var pinned;
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/hoodwenki.png',
                width: 250,
                height: 100,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                onCompleted: (pin) {
                  print(pin);
                  setState(() {
                  pinned = pin;
                  });
                }
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: AppColors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      EasyLoading.show();
                      FocusScope.of(context).unfocus();
                      try{
                            PhoneAuthCredential credential= PhoneAuthProvider.credential(verificationId: PhoneAuthScreen.verificationCode, smsCode: pinned);
                         await FirebaseAuth.instance.signInWithCredential(credential);
                           var check= (await usersRef.doc(widget.userModel.id).get()).exists;
                           if(check==true){
                             widget.userModel.idVerification = "Yes";
                            await usersRef.doc(widget.userModel.id).update(widget.userModel.toMap());
                            // Get.offAll(()=>HomeScreen(widget.userModel));
                             Get.offAll(()=> LoginScreen());
                             Fluttertoast.showToast(msg: "Please Re-Login for Confirmations");
                            EasyLoading.dismiss();

                           }else{
                             widget.userModel.idVerification ="Yes";
                            await DatabaseHelper().SignUp(widget.userModel);
                            Get.offAll(()=>LoginScreen());
                            EasyLoading.dismiss();
                           }

                      }catch(e){
                        FocusScope.of(context).unfocus();
                        print(e.toString());
                        Get.snackbar("Invalid Code", e.toString());
                        EasyLoading.dismiss();
                      }

                    },
                    child: Text("Verify Phone Number")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}