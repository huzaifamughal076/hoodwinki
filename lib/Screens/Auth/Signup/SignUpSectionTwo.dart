import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';
import 'package:watchminter/Screens/Auth/Signup/Verification/Verifiy.dart';
import 'package:watchminter/Screens/Home/HomeScreen.dart';

import '../../../Models/UserModel.dart';
import 'Verification/PhoneAuthScreen.dart';

class SignUpSectionTwo extends StatefulWidget {
  final UserModel userModel;
  const SignUpSectionTwo(this.userModel,{Key? key}) : super(key: key);

  @override
  State<SignUpSectionTwo> createState() => _SignUpSectionTwoState();
}

class _SignUpSectionTwoState extends State<SignUpSectionTwo> {

  var _groupValue ;
  final formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Column(
            children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Join our community",
                style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 24,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w900),
              ).marginOnly(left: 12, top: 50),
            ),
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        validator: (About){
                          if(About==null||About.isEmpty){
                            return "Provide some info about yourself";
                          }else{
                            widget.userModel.about=About;
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.black87),
                        maxLines: 8,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "About me",
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Colors.transparent, width: 0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: AppColors.background, width: 1),
                          ),
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
                      ).marginOnly(left: 12, right: 12, top: 20),
                      TextFormField(
                        validator: (bDetails){
                          widget.userModel.businessDetails=bDetails;
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.black87),
                        maxLines: 8,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Business details (if applicable)",
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Colors.transparent, width: 0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: AppColors.background, width: 1),
                          ),
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
                      ).marginOnly(left: 12, right: 12, top: 20,bottom: 20),
                    ],
                  ),
                ),
              ),
            ).marginOnly(left: 12,right: 12,top: 20),
            Column(
              children: <Widget>[
                RadioListTile(
                  value: 0,
                  groupValue: _groupValue,
                  title: Text("Private Owner/Seller"),
                  onChanged: ( newValue) =>
                      setState(() => _groupValue = newValue),
                  activeColor: Colors.red,
                  selected: false,
                ),
                RadioListTile(
                  value: 1,
                  groupValue: _groupValue,
                  title: Text("Professional Dealer"),
                  onChanged: (newValue) =>
                      setState(() => _groupValue = newValue),
                  activeColor: Colors.red,
                  selected: false,
                ),

              ],
            ).marginOnly(top: 20),
            InkWell(
              onTap: ()async{
                // var scanning =  await Get.to(Verify());
                Get.focusScope!.unfocus();
                if (formKey.currentState != null &&
                    formKey.currentState!.validate()){
                  UserModel userModel=UserModel();
                  if(_groupValue!=null){
                    widget.userModel.type=_groupValue;
                    widget.userModel.rating=[];
                    // EasyLoading.show(status: 'loading...');
                    // Get.to(Verify(widget.userModel));
                    Get.to(PhoneAuthScreen(widget.userModel));

                  }else{
                    Get.snackbar("Error", "Select a type",
                        colorText: AppColors.white,
                        icon: Icon(Icons.error_outline, color: Colors.white),
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: AppColors.orange);
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Identity verified (Optional)",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Gotham",
                          color: Colors.white),
                    ),
                    Image.asset(
                      "assets/images/next.png",
                      height: 15,
                      width: 20,
                    ).marginOnly(left: 10)
                  ],
                ),
              ).marginOnly(left: 12, right: 12, top: 30),
            ),
            InkWell(

              onTap: () async{
                print(widget.userModel.CountryCode.toString());
                Get.focusScope!.unfocus();
                if (formKey.currentState != null &&
                    formKey.currentState!.validate()){
                  UserModel userModel=UserModel();
                  if(_groupValue!=null){
                    widget.userModel.type=_groupValue;
                    widget.userModel.rating=[];
                    widget.userModel.idVerification="No";
                    EasyLoading.show(status: 'loading...');
                     userModel=await  DatabaseHelper().SignUp(widget.userModel);
                     if(userModel.id==null){
                       EasyLoading.dismiss();
                       print("Sign up failed");
                     }else{
                       EasyLoading.dismiss();
                       Get.offAll(HomeScreen(userModel,0),
                           transition: Transition.leftToRight);
                     }
                  }else{
                    Get.snackbar("Error", "Select a type",
                        colorText: AppColors.white,
                        icon: Icon(Icons.error_outline, color: Colors.white),
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: AppColors.orange);
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(50)),
                child: Center(
                  child: Text(
                    "SignUp",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Gotham",
                        color: AppColors.white),
                  ),
                ),
              ).marginOnly(left: 12, right: 12, top: 20),
            ),
          ],),
        ),
      ),

    );
  }
}
