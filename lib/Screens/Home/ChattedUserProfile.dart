import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:watchminter/Models/UserModel.dart';
import '../../Constants/AppColors.dart';
import '../../Database/DatabaseHelper.dart';
import '../../Global/firebase_ref.dart';
import '../../Models/ChatModel.dart';
import '../ViewProfile.dart';
import 'ChattedUserWatches.dart';
import 'MessageScreen.dart';

class ChattedUserProfile extends StatefulWidget {
  UserModel myUser;
  ChatModel chatModel;
  ChattedUserProfile(this.myUser,this.chatModel,{Key? key}) : super(key: key);
  @override
  State<ChattedUserProfile> createState() => _ChattedUserProfileState();
}
class _ChattedUserProfileState extends State<ChattedUserProfile> {
  UserModel ReceiverUser = UserModel();
  UserModel currentUser = UserModel();
  var ratings = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColors.white
              //     image: DecorationImage(
              //   fit: BoxFit.cover,
              //   image: new AssetImage("assets/images/blacknwhite_bg.jpg"),
              // )
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 150,
                  child: Stack(
                    children: [
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(12.0),
                      //   child: Image.asset(
                      //     "assets/images/cover.png",
                      //     fit: BoxFit.cover,
                      //     alignment: Alignment.center,
                      //     width: MediaQuery.of(context).size.width,
                      //     height: MediaQuery.of(context).size.height,
                      //   ).marginOnly(bottom: 40),
                      // ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Material(
                          color: Colors.transparent,
                          elevation: 20,
                          borderRadius: BorderRadius.circular(50),
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(MediaQuery.of(context).size.height * .2),
                            child: CachedNetworkImage(
                                width: MediaQuery.of(context).size.height * .15,
                                height: MediaQuery.of(context).size.height * .15,
                                fit: BoxFit.cover,
                                imageUrl: widget.chatModel.image??"assets/images/watch.png",
                                placeholder: (context, url) =>Image.asset("assets/images/watch.png"),
                                errorWidget: (context, url, error) =>Container(color: AppColors.orange,child: Image.asset("assets/images/watch.png"))
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ).marginOnly(top: 70, left: 20, right: 20),
                Text(
                  widget.chatModel.name,
                  style: TextStyle(
                      fontFamily: 'Gotham',
                      color: AppColors.background,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ).marginOnly(top: 12),
                InkWell(
                  onTap: ()async{
                    await Clipboard.setData(ClipboardData(text: widget.chatModel.id));
                    Get.snackbar("Copy Successfull", "Id copied to clipboard",
                        colorText: AppColors.white,
                        icon: Icon(Icons.error_outline, color: Colors.white),
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: AppColors.orange);
                  },
                  child: Text(
                    widget.chatModel.id,
                    style: TextStyle(color: AppColors.orange, letterSpacing: 2),
                  ).marginOnly(top: 10),
                ),
                // InkWell(
                //   onTap: (){
                //     print("Clicked");
                //     // Get.to(MessageScreen(currentUser!, ReceiverUser!));
                //     Get.t
                //   },
                //   child: Text(
                //     "Send a message",
                //     style: TextStyle(
                //       color: AppColors.orange,
                //       fontSize: 18,
                //       letterSpacing: 1,
                //       decoration: TextDecoration.underline,
                //     ),
                //   ).marginOnly(top: 12),
                // ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Collection",
                    style: TextStyle(
                        fontFamily: "Gotham",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ).marginAll(12),
                ),

                Container(
                  height: 100,
                  child: StreamBuilder(
                      stream: watchesRef
                          .where("ownerId", isEqualTo: widget.chatModel.id)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data.docs.isEmpty) {
                          return Center(
                              child: Text("No watches found in your collection")
                          );
                        }else if(snapshot.connectionState ==
                            ConnectionState.waiting){
                          EasyLoading.show(status:"Loading");
                          return Container();
                        }
                        else {
                          EasyLoading.dismiss();
                          return ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              scrollDirection: Axis.horizontal,
                              physics: ScrollPhysics(),
                              shrinkWrap: false,
                              primary: true,
                              itemCount:  snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return  ChattedUserWatches(snapshot.data.docs[index],widget.myUser);
                              });
                        }
                      }),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "About "+widget.chatModel.name,
                    style: TextStyle(
                        color: AppColors.background,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Gotham"),
                  ).marginOnly(left: 12, top: 12),
                ),
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
                                  "Business Name",
                                  style: TextStyle(
                                      color: Colors.grey, fontFamily: "Gotham"),
                                )),
                            Expanded(
                                child: Text(
                                  widget.chatModel.businessDetails,
                                  style: TextStyle(
                                      color: AppColors.background,
                                      fontFamily: "Gotham"),
                                ))
                          ]).marginAll(10),
                          Row(children: [
                            Expanded(
                                child: Text(
                                  "Username",
                                  style: TextStyle(
                                      color: Colors.grey, fontFamily: "Gotham"),
                                )),
                            Expanded(
                                child: Text(
                                  widget.chatModel.name,
                                  style: TextStyle(
                                      color: AppColors.background,
                                      fontFamily: "Gotham"),
                                ))
                          ]).marginOnly(left: 10, right: 10),
                          Row(children: [
                            Expanded(
                                child: Text(
                                  "Location",
                                  style: TextStyle(
                                      color: Colors.grey, fontFamily: "Gotham"),
                                )),
                            Expanded(
                                child: Text(
                                  widget.chatModel.country,
                                  style: TextStyle(
                                      color: AppColors.background,
                                      fontFamily: "Gotham"),
                                ))
                          ]).marginOnly(left: 10, right: 10, top: 5),
                          Row(children: [
                            Expanded(
                                child: Text(
                                  "Identity Verified",
                                  style: TextStyle(
                                      color: Colors.grey, fontFamily: "Gotham"),
                                )),
                            Expanded(
                                child: Text(
                                  widget.chatModel.idVerification,
                                  style: TextStyle(
                                      color: AppColors.background,
                                      fontFamily: "Gotham"),
                                ))
                          ]).marginOnly(left: 10, right: 10, top: 5),
                          // Row(children: [
                          //   Expanded(
                          //       child: Text(
                          //         "Trust Rating",
                          //         style: TextStyle(
                          //             color: Colors.grey, fontFamily: "Gotham"),
                          //       )),
                          //   Expanded(
                          //       child: Text(
                          //         ReceiverUser.rating.toString()??"N/A",
                          //         // "N/A",
                          //         style: TextStyle(
                          //             color: AppColors.background,
                          //             fontFamily: "Gotham"),
                          //       ))
                          // ]).marginOnly(left: 10, right: 10, top: 5),

                          Row(children: [
                            Expanded(
                                child: Text(
                                  "Joined In",
                                  style: TextStyle(
                                      color: Colors.grey, fontFamily: "Gotham"),
                                )),
                            Expanded(
                                child: Text(
                                  getTime(widget.chatModel.createdAt),
                                  style: TextStyle(
                                      color: AppColors.background,
                                      fontFamily: "Gotham"),
                                ))
                          ]).marginOnly(left: 12, right: 10, top: 5, bottom: 5),
                          Row(children: [
                            Expanded(
                                child: Text(
                                  "About",
                                  style: TextStyle(
                                      color: Colors.grey, fontFamily: "Gotham"),
                                )),
                            Expanded(
                                child: Text(
                                  ReceiverUser.about,
                                  style: TextStyle(
                                      color: AppColors.background,
                                      fontFamily: "Gotham"),
                                ))
                          ]).marginOnly(left: 12, right: 10,bottom: 5),
                        ],
                      ),
                    )).marginOnly(left: 12, right: 12, top: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Reviews",
                    style: TextStyle(
                        color: AppColors.background,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Gotham"),
                  ).marginOnly(left: 12, top: 12),
                ),

                (ReceiverUser.rating==null)?Align(
                  alignment: Alignment.center,
                  child: Text("You have no reviews yet"),
                ).marginOnly(top: 10)
                    :RatingBar.builder(
                  initialRating: ratings,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  ignoreGestures: true,
                  itemCount: 5,
                  itemSize: 25,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: AppColors.orange,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                    setState(() {
                      ratings = ReceiverUser.rating;
                    });
                  },
                )

              ],
            ),
          )
        ],
      ),
    );
  }
  String getTime(var time) {
    DateTime now = DateTime.parse(time);
    String formattedDate = DateFormat('yyyy').format(now);
    // time= DateTime.tryParse(time);
    // print(formattedDate.toString());

    return formattedDate.toString();
  }
  getCurrentUser()async{
    // EasyLoading.show();
    currentUser= await DatabaseHelper().GetSpecificUser(FirebaseAuth.instance.currentUser!.uid);
    // EasyLoading.dismiss();
  }

  getReceiverUser()async{
    // EasyLoading.show();
    ReceiverUser?.id= widget.chatModel.id;
    ReceiverUser?.image= widget.chatModel.image;
    ReceiverUser?.name= widget.chatModel.name;
    ReceiverUser?.email= widget.chatModel.email;
    ReceiverUser?.dob= widget.chatModel.dob;
    ReceiverUser?.house= widget.chatModel.house;
    ReceiverUser?.street= widget.chatModel.street;
    ReceiverUser?.town= widget.chatModel.town;
    ReceiverUser?.province= widget.chatModel.province;
    ReceiverUser?.type= widget.chatModel.type;
    ReceiverUser?.zip= widget.chatModel.zip;
    ReceiverUser?.country= widget.chatModel.country;
    ReceiverUser?.about= widget.chatModel.about;
    ReceiverUser?.businessDetails= widget.chatModel.businessDetails;
    ReceiverUser?.createdAt= widget.chatModel.createdAt;
    ReceiverUser?.rating= widget.chatModel.rating;
    ReceiverUser?.idVerification= widget.chatModel.idVerification;
    double sum=0.0;
    var rating;
    await usersRef.doc(widget.chatModel.id).get().then((val) async {
      List pointlist = List.from(val.data()!['Rating']);
      if(pointlist.isNotEmpty || pointlist.length!=0){
        for(var i in pointlist){
          print(i);
          sum += i;
        }
        print("SUM: "+sum.toString());
        rating = sum/pointlist.length;
        print("Rating is: "+rating.toString());
      }
      else{
        rating = 0.0;
      }

      ReceiverUser?.rating = rating;
      setState(() {
        ratings= rating;
      });


    });
    EasyLoading.dismiss();

  }

  @override
  void initState() {
    // EasyLoading.show();
    getCurrentUser();
    getReceiverUser();
    EasyLoading.dismiss();

  }
}
