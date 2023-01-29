import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';

import '../../Constants/AppColors.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({Key? key}) : super(key: key);

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {

  var _formKey = GlobalKey<FormState>();

  var Email;
  var emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColors.white
              ),
            ),
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: BoxDecoration(color: AppColors.orange),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Forget Password",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: "Gotham"),
                          ).marginOnly(top: 30, left: 12)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10,bottom: 10),
                      child: Text("Enter your email to reveive reset mail",
                        style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 14),),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      child: TextFormField(
                        validator: (email){
                          if(email==null||email.isEmpty){
                            return "Email required";
                          }else if(!emailValid.hasMatch(email)){
                            return "Format Error";
                          }
                          else{
                             Email=email;
                            return null;
                          }
                        },
                        // focusNode: focusNodePassword,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: AppColors.background),
                        autofocus: true,
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
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: AppColors.background, width: 0),
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
                      ),
                    ),
                    SizedBox(height: 20,),
                    Material(
                      elevation: 20,
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        onTap: () async {
                          Get.focusScope!.unfocus();
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()){
                            EasyLoading.show(status: 'loading...');
                            await DatabaseHelper.resetPassword(Email, context);
                            EasyLoading.dismiss();
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
                              "Send",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Gotham",
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ).marginOnly(left: 12, right: 12, top: 12),

                  ],
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
EasyLoading.dismiss();
  }
}
