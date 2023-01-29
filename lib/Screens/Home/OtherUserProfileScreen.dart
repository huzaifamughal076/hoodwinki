import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:watchminter/Models/UserModel.dart';
import '../../Constants/AppColors.dart';
import '../../Database/DatabaseHelper.dart';
import '../../Global/firebase_ref.dart';
import '../ViewProfile.dart';
import 'MessageScreen.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final data;
   OtherUserProfileScreen(this.data,{Key? key}) : super(key: key);
  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}
class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  UserModel? currentUser;
  UserModel ReceiverUser = UserModel();
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
                        child: Material(
                          elevation: 20,
                          borderRadius: BorderRadius.circular(50),
                          child: CircleAvatar(
                            radius: 50, // Image radius
                            backgroundColor: AppColors.orange,
                            backgroundImage:
                            AssetImage("assets/images/watch.png"),
                          ),
                        ),
                      )
                    ],
                  ),
                ).marginOnly(top: 70, left: 20, right: 20),
                Text(
                  widget.data['Name'],
                  style: TextStyle(
                      fontFamily: 'Gotham',
                      color: AppColors.background,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ).marginOnly(top: 12),
                InkWell(
                  onTap: (){
                    print("Clicked");
                    Get.to(MessageScreen(currentUser!, ReceiverUser!));
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
                          .where("ownerId", isEqualTo: widget.data['id'])
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
                              shrinkWrap: true,
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
                    "About "+widget.data["Name"],
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
                                  widget.data['Business details'],
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
                                  widget.data["Name"],
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
                                  widget.data['Country'],
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
                                  widget.data['Verified'],
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
                                  widget.data['Rating'],
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
                                  getTime(widget.data['Created at']),
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

                // Material(
                //     elevation: 10,
                //     borderRadius: BorderRadius.circular(10),
                //     child: Container(
                //       width: MediaQuery.of(context).size.width,
                //       decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(10)),
                //       child: ListView.builder(
                //           itemCount: 5,
                //           shrinkWrap: true,
                //           itemBuilder: (BuildContext context, int index) {
                //             return ReviewTile();
                //           }),
                //     )).marginOnly(left: 12, right: 12, top: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
  String getTime(var time) {
    DateTime now = DateTime.parse(time);
    String formattedDate = DateFormat('yyyy-EEE-d-MMM-kk:mm:ss a').format(now);
    // time= DateTime.tryParse(time);
    // print(formattedDate.toString());

    return formattedDate.toString();
  }
  getCurrentUser()async{
    EasyLoading.show();
    currentUser= await DatabaseHelper().GetSpecificUser(FirebaseAuth.instance.currentUser!.uid);
    EasyLoading.dismiss();
  }

  getReceiverUser()async{
    EasyLoading.show();
    ReceiverUser?.id= widget.data['id'];
    ReceiverUser?.image= widget.data['image'];
    ReceiverUser?.name= widget.data['Name'];
    ReceiverUser?.email= widget.data['Email'];
    ReceiverUser?.dob= widget.data['DOB'];
    ReceiverUser?.house= widget.data['House_name_number'];
    ReceiverUser?.street= widget.data['Street'];
    ReceiverUser?.town= widget.data['Town'];
    ReceiverUser?.province= widget.data['Province'];
    ReceiverUser?.type= widget.data['Type'];
    ReceiverUser?.zip= widget.data['Zip'];
    ReceiverUser?.country= widget.data['Country'];
    ReceiverUser?.about= widget.data['About'];
    ReceiverUser?.businessDetails= widget.data['Business details'];
    ReceiverUser?.createdAt= widget.data['Created at'];
    ReceiverUser?.rating= widget.data['Rating'];
    ReceiverUser?.idVerification= widget.data['Verified'];
    EasyLoading.dismiss();

  }

  @override
  void initState() {
    getCurrentUser();
    getReceiverUser();
    EasyLoading.dismiss();
  }
}