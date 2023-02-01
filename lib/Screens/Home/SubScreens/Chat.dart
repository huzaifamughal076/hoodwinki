import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';
import 'package:watchminter/Global/firebase_ref.dart';
import 'package:watchminter/Models/UserModel.dart';
import 'package:watchminter/Screens/Home/MessageScreen.dart';

import '../../../Constants/my_date_utils.dart';
import '../../ChatScreens/CreateNewMessage.dart';

class Chat extends StatefulWidget {
  UserModel userModel;

  Chat(this.userModel, {Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  @override
  Widget build(BuildContext context) {
    List<String> receiversList = [];

    receiversList.clear();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: AppColors.white),
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
                            "Messages",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: "Gotham"),
                          ).marginOnly(top: 30, left: 12)),
                    ),
                    Expanded(
                      child: StreamBuilder(
                          stream: chatsRef
                              .where("senderId", isEqualTo: widget.userModel.id)
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasError ||
                                !snapshot.hasData ||
                                snapshot.data.docs.isEmpty) {
                              return Center(child: Text("No chats found"));
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              EasyLoading.show(status: "Loading");
                              return Container();
                            } else {
                              EasyLoading.dismiss();
                              return ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  shrinkWrap: false,
                                  padding: EdgeInsets.only(top: 0),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var data = snapshot.data.docs[index].data();
                                    if (receiversList.contains(data["receiverId"])) {
                                      return Container();
                                    } else {
                                      receiversList.add(data["receiverId"]);
                                      return ChatTile(index,data['time'].toString(), data["receiverId"],
                                          data["message"],widget.userModel);
                                    }
                                  });
                            }
                          }),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.to(CreateNewMessage(widget.userModel));
          },
          label: Row(children: [
            Text("Create new message"),
            Icon(
              Icons.send,
              color: Colors.white,
            ).marginOnly(left: 5),
          ]),
          backgroundColor: AppColors.orange,
        ));
  }
}

class ChatTile extends StatefulWidget {
  final int index;
  final String time;
  final String receiverId;
  final String message;
  final UserModel senderModel;


  ChatTile(this.index,this.time, this.receiverId, this.message, this.senderModel,{Key? key})
      : super(key: key);

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  bool isEven = false;
  UserModel receiverUser = UserModel();


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(MessageScreen(widget.senderModel,receiverUser), transition: Transition.zoom);
      },
      child: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 30, // Image radius
                  backgroundColor: isEven ? AppColors.orange : Colors.white,
                  backgroundImage: receiverUser.image!=null ? NetworkImage(receiverUser.image):AssetImage("assets/images/watch.png") as ImageProvider,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receiverUser.name ?? "Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.background,
                        fontFamily: "Gotham"),
                  ),
                  Text(
                    widget.message.characters.take(10).toString()+"...",
                    style: TextStyle(
                        color: AppColors.background, fontFamily: "Gotham"),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  MyDatUtil.getFormattedTime(context: context, time: widget.time.toString()),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ).marginOnly(left: 12, right: 12, top: 12),
    );
  }

  @override
  void initState() {

    getUser();
    if (widget.index.isEven) {
      setState(() {
        isEven = true;
      });
    } else {
      setState(() {
        isEven = false;
      });
    }
  }

  getUser() async {
    receiverUser = await DatabaseHelper().GetSpecificUser(widget.receiverId);
    setState(() {
      receiverUser;
    });
  }
}