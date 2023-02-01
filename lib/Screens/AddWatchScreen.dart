
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';
import 'package:watchminter/Models/WatchModel.dart';

import '../Models/UserModel.dart';
import 'EditWatchDetails.dart';
import 'package:intl/intl.dart';

class AddWatchScreen extends StatefulWidget {
  UserModel userModel;

  AddWatchScreen(this.userModel, {Key? key}) : super(key: key);

  @override
  State<AddWatchScreen> createState() => _AddWatchScreenState();
}

class _AddWatchScreenState extends State<AddWatchScreen> {
  bool value = false;
  var joinedIn, offeredBy, currentDate, userType, Price;
  WatchModel watchModel = WatchModel();
  final formKey = GlobalKey<FormState>();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  @override
  void initState() {
    DateTime date = DateTime.parse(widget.userModel.createdAt);
    joinedIn = date.year;
    if (widget.userModel.type == 0) {
      offeredBy = "Private Owner/Seller";
    } else {
      offeredBy = "Professional Dealer";
    }
    watchModel.location="H: "+widget.userModel.house+" S: "+widget.userModel.street+" Town: "+widget.userModel.town+" ,"+widget.userModel.province+" ,"+widget.userModel.country;
    watchModel.forSale = value;
    userType = widget.userModel.type;
    DateTime now = DateTime.now();
    currentDate = DateFormat('d MMM y').format(now);
  }

   selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {
      imageFileList!;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.white),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(color: AppColors.orange),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Add Watch",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Gotham"),
                      ).marginOnly(top: 30, left: 12)),
                ),
                CarouselSlider(
                  options: CarouselOptions(height: 200.0,
                      viewportFraction: 1.0),
                  items: imageFileList!.isNotEmpty?imageFileList?.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return InkWell(
                          onTap:(){
                            Get.defaultDialog(
                              barrierDismissible: false,
                              backgroundColor: Colors.transparent,
                              content: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(width: MediaQuery.of(context).size.width,
                                  color: Colors.transparent,
                                  child: Image.file(File(i.path),fit: BoxFit.contain,),),
                                  Positioned(
                                    right: 5,
                                    top: 5,
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: ClipRRect(
                                          child: Container(color:AppColors.orange, child: Icon(Icons.close,color: Colors.white,)),
                                        borderRadius: BorderRadius.circular(20),

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(color: Colors.white),
                              child: Image.file(File(i.path))),
                        );
                      },
                    );
                  }).toList():[1].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(color: AppColors.white),
                            child: Image.asset(
                              "assets/images/watch.png",
                            ));
                      },
                    );
                  }).toList(),
                ).marginOnly(top: 12),
                InkWell(
                  onTap: ()async{
                    await selectImages();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Add image",
                        style: TextStyle(
                            color: AppColors.background,
                            fontFamily: 'Gotham',
                            fontSize: 16),
                      ),
                      Icon(
                        Icons.add,
                        color: AppColors.background,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Details",
                      style: TextStyle(
                          color: AppColors.background,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Gotham"),
                    ),
                    InkWell(
                        onTap: () async {
                          watchModel = await Get.to(
                              EditWatchDetails(watchModel),
                              transition: Transition.downToUp);
                          setState(() {
                            watchModel;
                          });
                        },
                        child: Icon(Icons.edit))
                  ],
                ).marginOnly(left: 12, top: 12, right: 12),
                Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Watch Id",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "Gotham"),
                            )),
                            Expanded(
                                child: Text(
                              "xxxxx-xxxxx-xxxx",
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: "Gotham"),
                            ))
                          ]).marginAll(10),
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Brand",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "Gotham"),
                            )),
                            Expanded(
                                child: Text(
                              watchModel.brand ?? "---------",
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: "Gotham"),
                            ))
                          ]).marginOnly(left: 10, right: 10),
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Model",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "Gotham"),
                            )),
                            Expanded(
                                child: Text(
                              watchModel.model ?? "---------",
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: "Gotham"),
                            ))
                          ]).marginOnly(left: 10, right: 10, top: 5),
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Serial number",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "Gotham"),
                            )),
                            Expanded(
                                child: Text(
                              watchModel.serialNumber ?? "---------",
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: "Gotham"),
                            ))
                          ]).marginOnly(left: 10, right: 10, top: 5),
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Condition",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "Gotham"),
                            )),
                            Expanded(
                                child: Text(
                              watchModel.condition ?? "---------",
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: "Gotham"),
                            ))
                          ]).marginOnly(left: 10, right: 10, top: 5),
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Original Papers",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "Gotham"),
                            )),
                            Expanded(
                                child: Text(
                              watchModel.papers ?? "---------",
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: "Gotham"),
                            ))
                          ]).marginOnly(left: 10, right: 10, top: 5),
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Original Box",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "Gotham"),
                            )),
                            Expanded(
                                child: Text(
                              watchModel.box ?? "---------",
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: "Gotham"),
                            ))
                          ]).marginOnly(left: 10, right: 10, top: 5),
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Location",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "Gotham"),
                            )),
                            Expanded(
                                child: Text(
                                  watchModel.location,
                                  style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: "Gotham"),
                            ))
                          ]).marginOnly(left: 10, right: 10, top: 5),
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Offered by",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "Gotham"),
                            )),
                            Expanded(
                                child: Text(
                              offeredBy,
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: "Gotham"),
                            ))
                          ]).marginOnly(left: 10, right: 10, top: 5),
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Id verified",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "Gotham"),
                            )),
                            Expanded(
                                child: Text(
                              widget.userModel.idVerification,
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: "Gotham"),
                            ))
                          ]).marginOnly(left: 10, right: 10, top: 5),
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Joined in",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "Gotham"),
                            )),
                            Expanded(
                                child: Text(
                              joinedIn.toString(),
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: "Gotham"),
                            ))
                          ]).marginOnly(left: 10, right: 10, top: 5),
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Seller rating",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "Gotham"),
                            )),
                            Expanded(
                                child: Text(
                              widget.userModel.rating,
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: "Gotham"),
                            ))
                          ]).marginAll(10),
                        ],
                      ),
                    )).marginOnly(left: 12, right: 12, top: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "History",
                      style: TextStyle(
                          color: AppColors.background,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Gotham"),
                    ),
                  ],
                ).marginOnly(left: 12, top: 12, right: 12),
                RichText(
                  text: TextSpan(
                    text: 'This watch passport was created by user ',
                    style: TextStyle(
                        fontFamily: 'Gotham', color: AppColors.background),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.userModel.name,
                        style: TextStyle(
                            fontFamily: 'Gotham', color: AppColors.orange),
                      ),
                      TextSpan(
                          text: ' on ',
                          style: TextStyle(
                              fontFamily: 'Gotham',
                              color: AppColors.background)),
                      TextSpan(
                          text: currentDate,
                          style: TextStyle(
                              fontFamily: 'Gotham', color: AppColors.orange)),
                      TextSpan(
                          text: ' This user is a',
                          style: TextStyle(
                              fontFamily: 'Gotham',
                              color: AppColors.background)),
                      TextSpan(
                          text: userType == 1
                              ? " Profeesional dealer"
                              : " Private Owner/Seller",
                          style: TextStyle(
                              fontFamily: 'Gotham', color: AppColors.orange)),
                      TextSpan(
                          text: ' with a trust rating of ',
                          style: TextStyle(
                              fontFamily: 'Gotham',
                              color: AppColors.background)),
                      TextSpan(
                          text: widget.userModel.rating,
                          style: TextStyle(
                              fontFamily: 'Gotham', color: AppColors.orange)),
                    ],
                  ),
                ).marginOnly(left: 12, right: 12, top: 10),
                Row(
                  children: [
                    Checkbox(
                      value: this.value,
                      checkColor: AppColors.background,
                      activeColor: AppColors.orange,
                      side: BorderSide(
                        color: AppColors.orange, //your desire colour here
                        width: 1.5,
                      ),
                      onChanged: (var value) {
                        setState(() {
                          this.value = value!;
                          watchModel.forSale = this.value;
                        });
                      },
                    ),
                    Text(
                      "Mark for sale",
                      style: TextStyle(
                          color: AppColors.background,
                          fontSize: 18,
                          fontFamily: 'Gotham'),
                    ),
                  ],
                ).marginOnly(top: 12),
                Visibility(
                  visible: value,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Set Price",
                          style: TextStyle(
                              color: AppColors.background, fontSize: 18),
                        ),
                        SizedBox(
                          width: 100,
                          child: Form(
                            key: formKey,
                            child: TextFormField(
                              validator: (price) {
                                if (value) {
                                  if (price == null || price.isEmpty) {
                                    return "Price required";
                                  } else {
                                    Price = price;
                                    return null;
                                  }
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.number,
                              style:
                                  const TextStyle(color: AppColors.background),
                              decoration: InputDecoration(
                                isDense: true,
                                prefix: Icon(
                                  Icons.currency_pound,
                                  size: 15,
                                ),
                                hintText: "Price",
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
                                      color: AppColors.background, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: AppColors.background, width: 1),
                                ),
                                hintStyle: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).marginOnly(left: 12, right: 12),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Sell watch",
                //       style:
                //           TextStyle(color: AppColors.background, fontSize: 18),
                //     ),
                //     Container(
                //         alignment: Alignment.center,
                //         height: 40,
                //         width: 100,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10),
                //             color: AppColors.orange),
                //         child: Icon(
                //           Icons.share,
                //           color: Colors.white,
                //         )),
                //   ],
                // ).marginOnly(left: 12, right: 12, top: 20),
                Material(
                  elevation: 20,
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                    onTap: () async {
                      if (watchModel.brand == null ||
                          watchModel.model == null ||
                          watchModel.serialNumber == null ||
                          watchModel.condition == null ||
                          watchModel.papers == null ||
                          watchModel.box == null) {
                        Get.snackbar("Error", "Watch details are missing",
                            colorText: AppColors.white,
                            icon:
                                Icon(Icons.error_outline, color: Colors.white),
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: AppColors.orange);
                      } else {
                        if (watchModel.forSale) {
                          if (formKey.currentState != null &&
                              formKey.currentState!.validate()) {
                            //watchModel.forSale = value;
                            watchModel.price = Price;
                            watchModel.ownerId = widget.userModel.id;
                            watchModel.createdAt = currentDate;
                            watchModel.escrow =true;
                            watchModel.verified=widget.userModel.idVerification;
                            //print("Imagesssss: "+imageFileList!.length.toString());
                            watchModel.images=imageFileList;
                            if (widget.userModel.type == 0) {
                              watchModel.offeredBy = "Private owner/seller";
                            } else {
                              watchModel.offeredBy =
                                  "Professional owner/seller";
                            }
                            if(imageFileList!.isEmpty){
                              Get.snackbar("Error", "Add watch images",
                                  colorText: AppColors.white,
                                  icon:
                                  Icon(Icons.error_outline, color: Colors.white),
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: AppColors.orange);
                            }else{
                              EasyLoading.show(status: 'Saving watch');
                              watchModel.verified=widget.userModel.idVerification;
                              print("Verified: "+watchModel.verified.toString());
                              await DatabaseHelper().AddWatch(watchModel);
                              EasyLoading.dismiss();
                              Get.back();
                            }
                          }
                        } else {
                          //watchModel.price = Price;
                          watchModel.ownerId = widget.userModel.id;
                          watchModel.createdAt = currentDate;
                          watchModel.escrow=true;
                          watchModel.verified = widget.userModel.idVerification;
                          watchModel.images=imageFileList;
                          if (widget.userModel.type == 0) {
                            watchModel.offeredBy = "Private owner/seller";
                          } else {
                            watchModel.offeredBy = "Professional owner/seller";
                          }
                          if(imageFileList!.isEmpty){
                            Get.snackbar("Error", "Add watch images",
                                colorText: AppColors.white,
                                icon:
                                Icon(Icons.error_outline, color: Colors.white),
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: AppColors.orange);
                          }else{
                            EasyLoading.show(status: 'Saving watch');
                            watchModel.verified=widget.userModel.idVerification;
                            await DatabaseHelper().AddWatch(watchModel);
                            EasyLoading.dismiss();
                            Get.back();
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
                          "Save Watch",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Gotham",
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ).marginOnly(left: 12, right: 12, top: 20, bottom: 40),
              ],
            ),
          )
        ],
      ),
    );
  }
}
