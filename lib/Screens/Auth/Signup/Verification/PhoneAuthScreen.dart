import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:watchminter/Screens/Auth/Signup/Verification/MyVerify.dart';

import '../../../../Constants/AppColors.dart';
import '../../../../Models/UserModel.dart';

class PhoneAuthScreen extends StatefulWidget {
  UserModel userModel;
  PhoneAuthScreen(this.userModel,{Key? key}) : super(key: key);
  static var verificationCode;

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}


class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  var Phone;
  var phoneValidator  = new RegExp(r'^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$');
  var _formKey = GlobalKey<FormState>();



  TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+92";
    super.initState();
    EasyLoading.dismiss();
  }
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: (){
          EasyLoading.dismiss();
          return  Future.value(true);
        },
        child: Scaffold(
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
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 40,
                          child: TextField(
                            controller: countryController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Text(
                          "|",
                          style: TextStyle(fontSize: 33, color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              onChanged: (val){
                                setState(() {
                                  Phone =val;
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone",
                              ),
                            ))
                      ],
                    ),
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
                          FocusScope.of(context).unfocus();
                          await Firebase.initializeApp();
                          EasyLoading.show();
                          try{
                            await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: countryController.text+Phone,
                                verificationCompleted: (PhoneAuthCredential credential)async{
                                  EasyLoading.dismiss();
                                },
                                verificationFailed: (FirebaseAuthException e){
                                  print(e.message.toString());
                                  Fluttertoast.showToast(msg: e.message.toString());
                                  EasyLoading.dismiss();

                                },
                                codeSent: (String verificationID , int? resendCode){
                                  setState(() {
                                    PhoneAuthScreen.verificationCode = verificationID;
                                    print("Code Received: "+verificationID);
                                    Get.to(MyVerify(PhoneAuthScreen.verificationCode,widget.userModel));
                                    EasyLoading.dismiss();
                                  });
                                },
                                codeAutoRetrievalTimeout: (String verificationID ){
                                  setState(() {
                                    PhoneAuthScreen.verificationCode = verificationID;
                                    EasyLoading.dismiss();
                                  });
                                },
                                timeout: Duration(seconds: 60));


                          }on FirebaseAuthException catch(e){
                            Fluttertoast.showToast(msg: e.message.toString());

                          }
                        },
                        child: Text("Send the code")),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
