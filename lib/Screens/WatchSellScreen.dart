import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';
import 'package:watchminter/Global/firebase_ref.dart';
import 'package:watchminter/Screens/Home/TermsAndConditions.dart';

import '../../Constants/AppColors.dart';
import '../Models/UserModel.dart';
import '../Models/WatchModel.dart';

class WatchSellScreen extends StatefulWidget {
  WatchModel watchModel;
  UserModel usermodel;
  WatchSellScreen(this.watchModel,this.usermodel,{Key? key}) : super(key: key);

  @override
  State<WatchSellScreen> createState() => _WatchSellScreenState();
}

class _WatchSellScreenState extends State<WatchSellScreen> {

  var _formKey = GlobalKey<FormState>();

  var buyerId;

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

                           Get.defaultDialog(
                             title: "Alert",
                             middleText: "Are you sure you want to transfer this watch passport. Once it has been sent, it will move out of your collection permanently",
                             actions: [
                               SizedBox(width: 100,),
                              ElevatedButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                              }, child: Text("No"),
                              style: ElevatedButton.styleFrom(elevation: 0,backgroundColor: Colors.grey)),
                              ElevatedButton(onPressed: () async {
                                Navigator.pop(context);
                                EasyLoading.show(status: "Loading");
                                widget.watchModel.escrow=true;
                                // bool result = true;
                                /////////////Converting the Date time into milliseconds
                                String dateString = widget.watchModel.createdAt;
                                String format = 'dd-MMM-yyyy';

                                // Create a DateFormat object to parse the date string
                                DateFormat formatter = DateFormat(format);

                                // Parse the date string into a DateTime object
                                DateTime date = formatter.parse(dateString);

                                // Get the milliseconds since Unix epoch
                                int millisecondsSinceEpoch = date.millisecondsSinceEpoch;
                                widget.watchModel.createdAt = millisecondsSinceEpoch;

                                print(millisecondsSinceEpoch); // Output: 1688409600000


                                bool result= await DatabaseHelper().SellWatch(widget.watchModel,buyerId);
                                EasyLoading.dismiss();
                                if(result==true){
                                  UserModel BuyerModel = UserModel();
                                  BuyerModel = await DatabaseHelper().GetSpecificUser(buyerId);
                                  Get.snackbar("Successful", "Watch sold successfully",
                                      colorText: AppColors.white,
                                      icon: Icon(Icons.error_outline, color: Colors.white),
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: AppColors.orange);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  //////////////////////////////////////////////////
                                  showDialog(context: context, builder: (context) {
                                    return RatingDialog(
                                      initialRating: 2,
                                      starColor: AppColors.orange,
                                      image: Image.asset("assets/images/hood.png",height: 50,),
                                      message: const Text("Please rate the client",textAlign: TextAlign.center,style: TextStyle(color: AppColors.grey,fontSize: 12),),
                                      starSize: 30.0,
                                      title: const Text("Rating",textAlign: TextAlign.center,style: TextStyle(color: AppColors.orange),),
                                      submitButtonText: 'Submit',
                                      showCloseButton: true,
                                      enableComment: false,
                                      onCancelled: ()async{
                                        // Navigator.of(context);
                                        await DatabaseHelper.SendNeedReviewFromBoth(FirebaseAuth.instance.currentUser!.uid,BuyerModel.id);
                                        // await DatabaseHelper.SendNeedReview(FirebaseAuth.instance.currentUser!.uid);
                                        Fluttertoast.showToast(msg: "Please be Sure to Review him later");
                                      },
                                      onSubmitted: (RatingDialogResponse ) async {
                                        if (kDebugMode) {
                                          print('rating: ${RatingDialogResponse.rating}');
                                        }
                                        await usersRef.doc(buyerId).get().then((val) async {
                                          List pointlist = List.from(val.data()!['Rating']);
                                          pointlist.add(RatingDialogResponse.rating);
                                          BuyerModel.rating = pointlist;
                                           await usersRef.doc(buyerId).update(BuyerModel.toMap());
                                           await DatabaseHelper.NeedReviewFromPurchaser(FirebaseAuth.instance.currentUser!.uid,BuyerModel.id);

                                          Get.back();
                                        });
                                      },
                                    );
                                  },
                                  );
                                  // Get.back();

                                }else{
                                  Get.snackbar("Error", "Buyer id was not found",
                                      colorText: AppColors.white,
                                      icon: Icon(Icons.error_outline, color: Colors.white),
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: AppColors.orange);
                                }


                              }, child: Text("Yes"),
                              style: ElevatedButton.styleFrom(elevation: 0,backgroundColor: AppColors.orange))
                             ]
                           );

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
                           Get.defaultDialog(
                               title: "Click here to confirm you have read and accepted the terms of the escrow agreement",
                               middleText: "Are you sure you want to transfer this watch passport. Once it has been sent, it will move out of your collection into escrow. It will remain in escrow until the terms of the escrow agreement have been satisfied. Once satisfied, it will move to the new owner’s collection",

                               actions: [
                                 GestureDetector(
                                     onTap:(){
                                       Navigator.push(context,
                                           CupertinoPageRoute(
                                             fullscreenDialog: true,
                                             builder: (context) =>TermsAndConditions() ,));
                                     },
                                     child: Text("Terms and Conditions",style: TextStyle(color: AppColors.orange,fontSize: 18),)),

                                 Row(
                                   mainAxisAlignment:MainAxisAlignment.end,
                                   children: [
                                   ElevatedButton(
                                       onPressed: (){
                                         Navigator.pop(context);
                                       }, child: Text("No"),
                                       style: ElevatedButton.styleFrom(elevation: 0,backgroundColor: Colors.grey)),
                                   SizedBox(width: 10,),
                                   ElevatedButton(onPressed: () async {
                                     Navigator.pop(context);
                                     EasyLoading.show(status: "Loading");
                                     setState(() {
                                       widget.watchModel.escrow=false;
                                     });

                                     /////////////Converting the Date time into milliseconds
                                     String dateString = widget.watchModel.createdAt;
                                     String format = 'dd-MMM-yyyy';

                                     // Create a DateFormat object to parse the date string
                                     DateFormat formatter = DateFormat(format);

                                     // Parse the date string into a DateTime object
                                     DateTime date = formatter.parse(dateString);

                                     // Get the milliseconds since Unix epoch
                                     int millisecondsSinceEpoch = date.millisecondsSinceEpoch;
                                     widget.watchModel.createdAt = millisecondsSinceEpoch;

                                     print(millisecondsSinceEpoch); // Outp

                                     print("escrow");
                                     bool result= await DatabaseHelper().SellWatch(widget.watchModel,buyerId);
                                     EasyLoading.dismiss();
                                     if(result==true){
                                       UserModel BuyerModel = UserModel();
                                       BuyerModel = await DatabaseHelper().GetSpecificUser(buyerId);
                                       Get.snackbar("Successful", "Watch send to escrow successfully",
                                           colorText: AppColors.white,
                                           icon: Icon(Icons.error_outline, color: Colors.white),
                                           snackPosition: SnackPosition.TOP,
                                           backgroundColor: AppColors.orange);
                                       Navigator.pop(context);
                                       Navigator.pop(context);
                                       //////////////////////////////////////////////////
                                       showDialog(context: context, builder: (context) {
                                         return RatingDialog(
                                           initialRating: 2,
                                           starColor: AppColors.orange,
                                           image: Image.asset("assets/images/hood.png",height: 50,),
                                           message: const Text("Please rate the client",textAlign: TextAlign.center,style: TextStyle(color: AppColors.grey,fontSize: 12),),
                                           starSize: 30.0,
                                           title: const Text("Rating",textAlign: TextAlign.center,style: TextStyle(color: AppColors.orange),), submitButtonText: 'Submit',
                                           enableComment: false,
                                           showCloseButton: true,
                                           onCancelled: () async {
                                             Navigator.of(context);
                                             await DatabaseHelper.SendNeedReviewFromBoth(FirebaseAuth.instance.currentUser!.uid,BuyerModel.id);
                                             Fluttertoast.showToast(msg: "Please be Sure to Review him later");
                                           },
                                           onSubmitted: (RatingDialogResponse ) async {
                                             if (kDebugMode) {
                                               print('rating: ${RatingDialogResponse.rating}');
                                             }
                                             await usersRef.doc(buyerId).get().then((val) async {
                                               List pointlist = List.from(val.data()!['Rating']);
                                               pointlist.add(RatingDialogResponse.rating);
                                               BuyerModel.rating = pointlist;
                                               await usersRef.doc(buyerId).update(BuyerModel.toMap());
                                               await DatabaseHelper.NeedReviewFromPurchaser(FirebaseAuth.instance.currentUser!.uid,BuyerModel.id);

                                               Get.back();
                                             });
                                           },
                                         );
                                       },
                                       );
                                     }else{
                                       Get.snackbar("Error", "Buyer id was not found",
                                           colorText: AppColors.white,
                                           icon: Icon(Icons.error_outline, color: Colors.white),
                                           snackPosition: SnackPosition.TOP,
                                           backgroundColor: AppColors.orange);
                                     }
                                   }, child: Text("Yes"),
                                       style: ElevatedButton.styleFrom(elevation: 0,backgroundColor: AppColors.orange))
                                 ],),
                                 SizedBox(width: 10,),
                               ]
                           );
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
