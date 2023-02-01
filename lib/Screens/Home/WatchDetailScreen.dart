import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';
import 'package:watchminter/Models/UserModel.dart';
import 'package:watchminter/Models/WatchModel.dart';
import 'package:watchminter/Screens/Home/MessageScreen.dart';
import 'package:watchminter/Screens/WatchSellScreen.dart';

import '../EditWatchDetails.dart';

class WatchDetailScreen extends StatefulWidget {
  final watchId;

  WatchDetailScreen(this.watchId, {Key? key}) : super(key: key);

  @override
  State<WatchDetailScreen> createState() => _WatchDetailScreenState();
}
class _WatchDetailScreenState extends State<WatchDetailScreen> {
  bool value = false;
  bool contactBool =false;
  WatchModel watchModel = WatchModel();
  List images = [];
  var history = "";
  var buyer_elevation = 0.0;
  final formKey = GlobalKey<FormState>();
  var focusNodeBuyerId = FocusNode();
  var buyerId;

  UserModel? currentUser;
  UserModel ReceiverUser = UserModel();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  @override
  void initState() {
    focusNodeBuyerId.addListener(() {
      if (focusNodeBuyerId.hasFocus) {
        setState(() {
          buyer_elevation = 10; //Check your conditions on text variable
        });
      } else {
        setState(() {
          buyer_elevation = 0; //Check your conditions on text variable
        });
      }
    });
    getWatchDetails();

  }
  getCurrentUser()async{
    currentUser= await DatabaseHelper().GetSpecificUser(FirebaseAuth.instance.currentUser!.uid);
  }

  getReceiverUser()async{
    print(watchModel.ownerId);
    ReceiverUser= await DatabaseHelper().GetSpecificUser(watchModel.ownerId);
    EasyLoading.dismiss();

  }
  getWatchDetails() async {
    EasyLoading.show(status: "Loading....");
    watchModel = await DatabaseHelper().GetWatch(widget.watchId);

    history = "This watch was created by ";
    for (int i = 0; i < watchModel.history.length; i++) {
      UserModel user = await DatabaseHelper()
          .GetSpecificUser(watchModel.history[i].ownerId.toString());
      history = history +
          user.name +
          " on " +
          watchModel.history[i].time.toString() +
          ".";
      if (i + 1 < watchModel.history.length) {
        history = history + "Then it was passed to ";
      }
    }
    if(FirebaseAuth.instance.currentUser!.uid!=watchModel.ownerId){
      setState(() {
        contactBool=true;
      });
    }
    setState(() {
      watchModel;
      images = watchModel.images;
      history;
    });
    getCurrentUser();
    getReceiverUser();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return value
        ? Center(child: Container())
        : Scaffold(
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
                              watchModel.brand ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: "Gotham"),
                            ).marginOnly(top: 30, left: 12)),
                      ),
                     imageFileList!.isNotEmpty?CarouselSlider(
                       options: CarouselOptions(height: 200.0,
                           enableInfiniteScroll: false,
                           scrollPhysics: const BouncingScrollPhysics(),
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
                     ).marginOnly(top: 12):
                      CarouselSlider(
                        options: CarouselOptions(height: 200.0,
                            enableInfiniteScroll: false,
                          viewportFraction: 1.1,
                          enlargeCenterPage: true,
                        ),
                        items: watchModel.images != null
                            ?  images.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return InkWell(
                                      onTap: (){
                                        Get.defaultDialog(
                                          barrierDismissible: false,
                                          backgroundColor: Colors.transparent,
                                          content: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(width: MediaQuery.of(context).size.width,
                                                color: Colors.transparent,
                                                child: Image.network((i),fit: BoxFit.contain,),),
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          decoration:
                                              BoxDecoration(color: Colors.white),
                                          child: Image.network(i)),
                                    );
                                  },
                                );
                              }).toList()
                            : [1].map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                        child: Image.asset(
                                            "assets/images/watch.png")
                                        // child: Image.asset(
                                        //   "assets/images/watch.png",
                                        // )
                                        );
                                  },
                                );
                              }).toList(),
                      ).marginOnly(top: 12),
                      if(FirebaseAuth.instance.currentUser!.uid==watchModel.ownerId)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              await selectImages();
                            },
                            child: Text(
                              "Add image",
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: 'Gotham',
                                  fontSize: 16),
                            ),
                          ),
                          Icon(
                            Icons.add,
                            color: AppColors.background,
                          ),
                        ],
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
                          if(FirebaseAuth.instance.currentUser!.uid==watchModel.ownerId)
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
                          child: InkWell(
                            onTap: () {
                              // Get.to(EditWatchDetails(),transition: Transition.downToUp);
                            },
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
                                          color: Colors.grey,
                                          fontFamily: "Gotham"),
                                    )),
                                    Expanded(
                                        child: Text(
                                      watchModel.watchId ?? "",
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
                                          color: Colors.grey,
                                          fontFamily: "Gotham"),
                                    )),
                                    Expanded(
                                        child: Text(
                                      watchModel.brand ?? "",
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
                                          color: Colors.grey,
                                          fontFamily: "Gotham"),
                                    )),
                                    Expanded(
                                        child: Text(
                                      watchModel.model ?? "",
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
                                          color: Colors.grey,
                                          fontFamily: "Gotham"),
                                    )),
                                    Expanded(
                                        child: Text(
                                      watchModel.serialNumber ?? "",
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
                                          color: Colors.grey,
                                          fontFamily: "Gotham"),
                                    )),
                                    Expanded(
                                        child: Text(
                                      watchModel.condition ?? "",
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
                                          color: Colors.grey,
                                          fontFamily: "Gotham"),
                                    )),
                                    Expanded(
                                        child: Text(
                                      watchModel.papers ?? "",
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
                                          color: Colors.grey,
                                          fontFamily: "Gotham"),
                                    )),
                                    Expanded(
                                        child: Text(
                                      watchModel.box ?? "",
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
                                          color: Colors.grey,
                                          fontFamily: "Gotham"),
                                    )),
                                    Expanded(
                                        child: Text(
                                      watchModel.location ?? "",
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
                                          color: Colors.grey,
                                          fontFamily: "Gotham"),
                                    )),
                                    Expanded(
                                        child: Text(
                                      watchModel.offeredBy ?? "",
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
                                          color: Colors.grey,
                                          fontFamily: "Gotham"),
                                    )),
                                    Expanded(
                                        child: Text(
                                      watchModel.verified??'N/A',
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
                                          color: Colors.grey,
                                          fontFamily: "Gotham"),
                                    )),
                                    Expanded(
                                        child: Text(
                                      watchModel.createdAt ?? "",
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
                                          color: Colors.grey,
                                          fontFamily: "Gotham"),
                                    )),
                                    Expanded(
                                        child: Text(
                                      "4.8",
                                      style: TextStyle(
                                          color: AppColors.background,
                                          fontFamily: "Gotham"),
                                    ))
                                  ]).marginAll(10),
                                ],
                              ),
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
                      Text(history).marginOnly(left: 12, right: 12, top: 10),
                      if(FirebaseAuth.instance.currentUser!.uid==watchModel.ownerId)
                      Row(
                        children: [
                          Checkbox(
                            value: watchModel.forSale ?? false,
                            checkColor: AppColors.background,
                            activeColor: AppColors.orange,
                            side: BorderSide(
                              color: AppColors.orange, //your desire colour here
                              width: 1.5,
                            ),
                            onChanged: (var value) {
                              setState(() {
                                watchModel.forSale = value!;
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
                      watchModel.forSale != null && watchModel.forSale
                          ? Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Set Price",
                                    style: TextStyle(
                                        color: AppColors.background,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        watchModel.price = value.toString();
                                      },

                                      readOnly: FirebaseAuth.instance.currentUser!.uid!=watchModel.ownerId?true:false,
                                      style: const TextStyle(
                                          color: AppColors.background),
                                      initialValue: watchModel.price ?? "",
                                      decoration: InputDecoration(
                                        isDense: true,
                                        prefix: Icon(
                                          Icons.currency_pound,
                                          size: 15,
                                        ),
                                        hintText: "Price",
                                        fillColor: Colors.white,
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.all(12),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: AppColors.background,
                                              width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: AppColors.background,
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: AppColors.background,
                                              width: 1),
                                        ),
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ).marginOnly(left: 12, right: 12)
                          : Container(),
                      if(FirebaseAuth.instance.currentUser!.uid==watchModel.ownerId)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sell watch",
                            style: TextStyle(
                                color: AppColors.background, fontSize: 18),
                          ),

                          InkWell(
                            onTap: () {
                              Get.to(WatchSellScreen(watchModel));
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.orange),
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ).marginOnly(left: 12, right: 12, top: 20),
                      if(FirebaseAuth.instance.currentUser!.uid==watchModel.ownerId)
                      Material(
                        elevation: 20,
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          onTap: () async {
                            EasyLoading.show();
                            if(imageFileList!.isNotEmpty){
                              await DatabaseHelper().EditWatch(watchModel.displayImage,watchModel,imageFileList);
                            }else{
                              await DatabaseHelper().UpdateWatch(watchModel);
                            }

                            EasyLoading.dismiss();
                            // Fluttertoast.showToast(msg: "Changes saved");
                            Get.back();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: BoxDecoration(
                                color: AppColors.orange,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "Save Changes",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Gotham",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ).marginOnly(left: 12, right: 12, top: 20),
                      if(FirebaseAuth.instance.currentUser!.uid==watchModel.ownerId)
                      Material(
                        elevation: 20,
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          onTap: () async {

                            Get.defaultDialog(
                              title: "Are You Sure",
                              middleText: "You want to delete",
                              cancel: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey
                                  ),
                                  onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No")),
                              confirm: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.orange
                                ),
                                  onPressed: () async {
                                Navigator.pop(context);
                                await DatabaseHelper().DeleteWatch(watchModel);
                              },
                                  child: Text("Yes")),
                              onCancel:()=> Navigator.pop(context),
                              onConfirm: () async => await DatabaseHelper().DeleteWatch(watchModel),
                            );

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: BoxDecoration(
                                color: AppColors.orange,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "Delete Watch",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Gotham",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ).marginOnly(left: 12, right: 12, top: 20, bottom: 40),

                      if(contactBool==true)
                        Material(
                          elevation: 20,
                          borderRadius: BorderRadius.circular(50),
                          child: InkWell(
                            onTap: () {
                              Get.to(MessageScreen(currentUser!, ReceiverUser));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: AppColors.orange,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  "Contact Owner",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Gotham",
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ).marginOnly(left: 12, right: 12, top: 20, bottom: 20),
                      SizedBox(height: 20,),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
    mounted;
  }

  selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
      setState(() {
        imageFileList;
      });
      print("PICKED");
    }
    print("Not Picked");
    setState(() {
      imageFileList!;
      // watchModel;
    });

  }
}
