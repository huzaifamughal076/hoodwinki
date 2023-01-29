import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';

import '../../Constants/AppColors.dart';
import '../Models/WatchModel.dart';

class WatchSellScreen extends StatefulWidget {
  WatchModel watchModel;
  WatchSellScreen(this.watchModel,{Key? key}) : super(key: key);

  @override
  State<WatchSellScreen> createState() => _WatchSellScreenState();
}

class _WatchSellScreenState extends State<WatchSellScreen> {

  var _formKey = GlobalKey<FormState>();

  var buyerId;
  // var emailValid = RegExp(
  //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

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
                            "Buyer Id",
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
                            return "BuyerId required";
                          }
                          else{
                            buyerId=email;
                            return null;
                          }
                        },
                        // focusNode: focusNodePassword,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: AppColors.background),
                        autofocus: true,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Buyer Id",
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

                  ],
                ),
               Positioned(
                 bottom: 10,
                 right: 10,
                 left: 10,
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                   Material(
                     elevation: 20,
                     borderRadius: BorderRadius.circular(50),
                     child: InkWell(
                       onTap: () async {
                         Get.focusScope!.unfocus();
                         if (_formKey.currentState != null &&
                             _formKey.currentState!.validate()){
                           EasyLoading.show(status: "Loading");
                           widget.watchModel.escrow=true;
                           bool result= await DatabaseHelper().SellWatch(widget.watchModel,buyerId);
                           EasyLoading.dismiss();
                           if(result==true){
                             Get.snackbar("Successful", "Watch sold successfully",
                                 colorText: AppColors.white,
                                 icon: Icon(Icons.error_outline, color: Colors.white),
                                 snackPosition: SnackPosition.TOP,
                                 backgroundColor: AppColors.orange);
                             Get.back();

                           }else{
                             Get.snackbar("Error", "Buyer id was not found",
                                 colorText: AppColors.white,
                                 icon: Icon(Icons.error_outline, color: Colors.white),
                                 snackPosition: SnackPosition.TOP,
                                 backgroundColor: AppColors.orange);
                           }
                           //buyerId
                           //history
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
                             "Direct Transfer",
                             style: TextStyle(
                                 fontSize: 16,
                                 fontFamily: "Gotham",
                                 color: Colors.white),
                           ),
                         ),
                       ),
                     ),
                   ).marginOnly(left: 12, right: 12, top: 12),
                   SizedBox(height: 10,),
                   Material(
                     elevation: 20,
                     borderRadius: BorderRadius.circular(50),
                     child: InkWell(
                       onTap: () async {
                         Get.focusScope!.unfocus();
                         if (_formKey.currentState != null &&
                             _formKey.currentState!.validate()){
                           EasyLoading.show(status: "Loading");
                           widget.watchModel.escrow=false;
                           bool result= await DatabaseHelper().SellWatch(widget.watchModel,buyerId);
                           EasyLoading.dismiss();
                           if(result==true){
                             Get.snackbar("Successful", "Watch send to escrow successfully",
                                 colorText: AppColors.white,
                                 icon: Icon(Icons.error_outline, color: Colors.white),
                                 snackPosition: SnackPosition.TOP,
                                 backgroundColor: AppColors.orange);
                             Get.back();

                           }else{
                             Get.snackbar("Error", "Buyer id was not found",
                                 colorText: AppColors.white,
                                 icon: Icon(Icons.error_outline, color: Colors.white),
                                 snackPosition: SnackPosition.TOP,
                                 backgroundColor: AppColors.orange);
                           }
                           //buyerId
                           //history
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
                             "Send to escrow",
                             style: TextStyle(
                                 fontSize: 16,
                                 fontFamily: "Gotham",
                                 color: Colors.white),
                           ),
                         ),
                       ),
                     ),
                   ).marginOnly(left: 12, right: 12, top: 12),

                 ],),
               )

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
