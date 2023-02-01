import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';
import 'package:watchminter/Models/UserModel.dart';
import 'package:watchminter/Screens/Home/MessageScreen.dart';
import 'package:watchminter/Screens/Home/WatchDetailScreen.dart';
import '../Global/firebase_ref.dart';
import 'package:intl/intl.dart';

class ViewProfile extends StatefulWidget {
  UserModel userModel;
  ViewProfile(this.userModel,{Key? key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  UserModel? currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white
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
                  height: 200,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          "assets/images/cover.png",
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ).marginOnly(bottom: 40),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(MediaQuery.of(context).size.height * .2),
                          child: CachedNetworkImage(
                            width: MediaQuery.of(context).size.height * .15,
                            height: MediaQuery.of(context).size.height * .15,
                            fit: BoxFit.cover,
                            imageUrl: widget.userModel.image??"assets/images/watch.png",
                            placeholder: (context, url) =>Image.asset("assets/images/watch.png"),
                            errorWidget: (context, url, error) =>Container(color: AppColors.orange,child: Image.asset("assets/images/watch.png"))
                          ),
                        ),
                      )
                    ],
                  ),
                ).marginOnly(top: 70, left: 20, right: 20),
                Text(
                  widget.userModel.name,
                  style: TextStyle(
                      fontFamily: 'Gotham',
                      color: AppColors.background,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ).marginOnly(top: 12),
                if(FirebaseAuth.instance.currentUser!.uid!=widget.userModel.id)
                InkWell(
                  onTap: (){
                    print("Clicked");
                    Get.to(MessageScreen(currentUser!, widget.userModel));
                  },
                  child: Text(
                    "Send a message",
                    style: TextStyle(
                      color: AppColors.orange,
                      fontSize: 18,
                      letterSpacing: 1,
                      decoration: TextDecoration.underline,
                    ),
                  ).marginOnly(top: 12),
                ),
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
                          .where("ownerId", isEqualTo: widget.userModel.id)
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
                              scrollDirection: Axis.horizontal,
                              physics: ScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              primary: true,
                              itemCount:  snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return  WatchCollectionTiles(snapshot.data.docs[index]);
                              });
                        }
                      }),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "About "+widget.userModel.name,
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
                              widget.userModel.businessDetails,
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
                              widget.userModel.name,
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
                              widget.userModel.country,
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
                              widget.userModel.idVerification,
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontFamily: "Gotham"),
                            ))
                          ]).marginOnly(left: 10, right: 10, top: 5),
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Trust Rating",
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
                          ]).marginOnly(left: 10, right: 10, top: 5),

                          Row(children: [
                            Expanded(
                                child: Text(
                                  "Joined In",
                                  style: TextStyle(
                                      color: Colors.grey, fontFamily: "Gotham"),
                                )),
                            Expanded(
                                child: Text(
                                  getTime(widget.userModel.createdAt),
                                  style: TextStyle(
                                      color: AppColors.background,
                                      fontFamily: "Gotham"),
                                ))
                          ]).marginOnly(left: 12, right: 10, top: 5, bottom: 10),
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

                Align(
                  alignment: Alignment.center,
                  child: Text("You have no reviews yet"),
                ).marginOnly(top: 10)

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
    EasyLoading.show();
    currentUser= await DatabaseHelper().GetSpecificUser(FirebaseAuth.instance.currentUser!.uid);
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    getCurrentUser();
    EasyLoading.dismiss();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }
}

class WatchCollectionTiles extends StatefulWidget {
  final data;
  WatchCollectionTiles(this.data,{Key? key}) : super(key: key);

  @override
  State<WatchCollectionTiles> createState() => _WatchCollectionTilesState();
}

class _WatchCollectionTilesState extends State<WatchCollectionTiles> {
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        Get.to(WatchDetailScreen(widget.data['watchId']));
      },
      child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(10),
        child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: AppColors.white),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: FadeInImage.assetNetwork(
                          image: widget.data["displayImage"],
                          fit: BoxFit.cover,
                          placeholder: "assets/images/watch.png",
                          width: 100,
                          height: 70,
                        ).paddingSymmetric(vertical: 20),
                      ),
                    )
      ).marginOnly(left: 6, right: 6),
    );
  }
}



class ReviewTile extends StatefulWidget {
  const ReviewTile({Key? key}) : super(key: key);

  @override
  State<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dave",
            style:
                TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold,fontFamily: "Gotham"),
          ),
          Text(
            "Bought a watch from John. Awesome expereince",
            style: TextStyle(color: AppColors.background,fontFamily: "Gotham"),
          ),
          Divider(
            color: Colors.grey,
          ).marginOnly(top: 6, left: 12, right: 12)
        ],
      ),
    ).marginOnly(left: 12, right: 12, bottom: 12);
  }
}
