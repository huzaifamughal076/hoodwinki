import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:watchminter/Constants/my_date_utils.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';
import 'package:watchminter/ExternalWidgets/ChatTile.dart';
import 'package:watchminter/Global/firebase_ref.dart';
import 'package:watchminter/Models/ChatModel.dart';

import '../../../Constants/AppColors.dart';
import '../../../Models/UserModel.dart';
import '../../ChatScreens/CreateNewMessage.dart';
import '../CommunicationScreen.dart';


class ChatScreen extends StatefulWidget {
  UserModel myUser;
   ChatScreen(this.myUser,{Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var message;
  var time;
  String seen= "No";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        toolbarHeight: 60,
        backgroundColor: AppColors.orange,

      ),
      // body: StreamBuilder(
      //   stream: usersRef.doc(widget.myUser.id).collection("Chats").snapshots(),
      //   builder: (context,AsyncSnapshot snapshot) {
      //     // print(snapshot.data.docs[0]['ChatId'].toString());
      //     return ListView.builder(
      //       itemCount: snapshot.data.docs.length,
      //       itemBuilder: (context, index) {
      //         // return Text(snapshot.data.docs[index]["ChatId"]);
      //         final reference = snapshot.data.docs[index];
      //         // print("CHAT : "+reference["ChatId"]);
      //         UserModel ChattedUser = UserModel();
      //         return Text("data");
      //
      //     },);
      //
      // },),

        body: (DatabaseHelper.chatted.isNotEmpty)?ListView.builder(
          itemCount: DatabaseHelper.chatted.length,
          itemBuilder: (context, index) {

             return InkWell(
               onTap: () {
                 // Get.offAll(()=>MessageScreen(widget.senderModel,receiverUser), transition: Transition.zoom);
                 ChatModel chatModel = ChatModel();
                 chatModel.name = DatabaseHelper.chatted[index].name;
                 chatModel.CountryCode = DatabaseHelper.chatted[index].CountryCode;
                 chatModel.email = DatabaseHelper.chatted[index].email;
                 chatModel.country = DatabaseHelper.chatted[index].country;
                 chatModel.zip = DatabaseHelper.chatted[index].zip;
                 chatModel.province = DatabaseHelper.chatted[index].province;
                 chatModel.town = DatabaseHelper.chatted[index].town;
                 chatModel.street = DatabaseHelper.chatted[index].street;
                 chatModel.house = DatabaseHelper.chatted[index].house;
                 chatModel.id = DatabaseHelper.chatted[index].id;
                 chatModel.about = DatabaseHelper.chatted[index].about;
                 chatModel.createdAt = DatabaseHelper.chatted[index].createdAt;
                 chatModel.image = DatabaseHelper.chatted[index].image;
                 chatModel.businessDetails = DatabaseHelper.chatted[index].businessDetails;
                 chatModel.dob = DatabaseHelper.chatted[index].dob;
                 chatModel.type = DatabaseHelper.chatted[index].type;
                 chatModel.ChatId = DatabaseHelper.chatted[index].ChatId;
                 chatModel.idVerification = DatabaseHelper.chatted[index].idVerification;

                 Get.to(()=>CommunicationScreen(widget.myUser,chatModel));
               },
               child: Row(
                 children: [
                   Expanded(
                     flex: 1,
                     child: Align(
                       alignment: Alignment.centerLeft,
                       child: CircleAvatar(
                         radius: 30, // Image radius
                          backgroundColor: Colors.white,
                         backgroundImage: DatabaseHelper.chatted[index].image!=null ? NetworkImage(DatabaseHelper.chatted[index].image):const AssetImage("assets/images/watch.png") as ImageProvider,
                       ),
                     ),
                   ),
                   Expanded(
                     flex: 2,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                             Text(
                               DatabaseHelper.chatted[index].name ?? "Name",
                               style: const TextStyle(
                                   fontWeight: FontWeight.bold,
                                   color: AppColors.background,
                                   fontFamily: "Gotham"),
                             ),
                             StreamBuilder(
                               stream: getMessageStatusonCurrentIndex(DatabaseHelper.chatted[index].ChatId,index),
                               builder: (context, snapshot) {
                               return (DatabaseHelper.chatted[index].read=="No") ?Container(
                                 height: 10,
                                 width: 10,
                                 decoration: BoxDecoration(color: AppColors.orange,borderRadius: BorderRadius.circular(20),),).marginOnly(left: 10)
                                   :Container(
                                 height: 10,
                                 width: 10,
                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),),).marginOnly(left: 10);
                             },),
                           ],
                         ),
                         // Text(
                         //   getMessageonCurrentIndex(DatabaseHelper.chatted[index].ChatId).toString(),
                         //   style: const TextStyle(
                         //       color: AppColors.background, fontFamily: "Gotham"),
                         // )
                         StreamBuilder(
                           stream: getMessageonCurrentIndex(DatabaseHelper.chatted[index].ChatId,index),
                           builder: (context, snapshot) {
                             return Text(DatabaseHelper.chatted[index].message??".....");
                         },)
                       ],
                     ),
                   ),

                    Expanded(
                     flex: 1,
                     child: Align(
                       alignment: Alignment.bottomRight,
                       child: StreamBuilder(
                         stream: getTime(DatabaseHelper.chatted[index].ChatId,index),
                         builder: (context, snapshot) {
                           return  ((time!=null)?Text(
                             // MyDatUtil.getFormattedTime(context: context, time: widget.chatModel[''].toString()),
                               (DatabaseHelper.chatted[index].messageDeliverTime!=null ||
                                   DatabaseHelper.chatted[index].messageDeliverTime !="")?MyDatUtil.getFormattedTime(context: context, time: DatabaseHelper.chatted[index].messageDeliverTime).toString()??"":"N/A",
                             style: const TextStyle(color: Colors.grey),
                           ):Text("N/A"));

                         },
                       )
                     ),
                   ),
                 ],
               ).marginOnly(left: 12, right: 12, top: 12),
             );
            // return Text(DatabaseHelper.chatted[index].name);
        },
        ):Center(child: Text("No Chats"),),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.to(CreateNewMessage(widget.myUser));
          },
          label: Row(children: [
            const Text("Create new message"),
            const Icon(
              Icons.send,
              color: Colors.white,
            ).marginOnly(left: 5),
          ]),
          backgroundColor: AppColors.orange,
        )
    );
  }

  @override
  void initState() {
    if(DatabaseHelper.chatted.isNotEmpty){
      EasyLoading.show();
    }
    getChat();
    DatabaseHelper.GetUpdatedMessageAlert();
  }

  getChat()async{
    EasyLoading.show();
   await DatabaseHelper.GetChatted(widget.myUser).then((value) {
     Future.delayed(Duration(milliseconds: 2000),(){
       setState(() {
         DatabaseHelper.chatted;
       });
       EasyLoading.dismiss();
     });
   });

  }
  getMessageonCurrentIndex<String>(ChatId,index) async* {
    // EasyLoading.show();
     await chatsRef.doc(ChatId).collection("message").orderBy('time',descending: true).get().then((value) {
       message = value.docs[0]['message'];
       DatabaseHelper.chatted[index].message = message;
       getMessageStatusonCurrentIndex(ChatId,index);
       EasyLoading.dismiss();

     });

  }

  getMessageStatusonCurrentIndex<String>(ChatId,index) async* {
    // EasyLoading.show();
    await chatsRef.doc(ChatId).collection("message").orderBy('time',descending: true).get().then((value) {
      String id = value.docs[index]['receiverId'];
       if(id ==FirebaseAuth.instance.currentUser!.uid){
         DatabaseHelper.chatted[index].read = value.docs[index]['read'];
         // setState(() {
         //   DatabaseHelper.chatted[index].read;
         // });
       }else{
         DatabaseHelper.chatted[index].read ="Yes";
         print(value.docs[index]["receiverId"]);
       }

      // print(FirebaseAuth.instance.currentUser!.uid);
      // print(id);
      //   if(id==FirebaseAuth.instance.currentUser!.uid){
      //     DatabaseHelper.chatted[index].read = value.docs[0]['read'];
      //     setState(() {
      //       DatabaseHelper.chatted[index].read;
      //     });
      //     print(DatabaseHelper.chatted[index].read);
      //     print(value.docs[index]['receiverId']);
      //
      //   }else{
      //
      //     DatabaseHelper.chatted[index].read = value.docs[0]['read'];
      //     // print(value.docs[0]['read']);
      //     // print(value.docs[index]['receiverId']);
      //     // print(DatabaseHelper.chatted[index].read);
      //   }


     });

  }


  getTime<String>(ChatId,index)async*{
    await chatsRef.doc(ChatId).collection("message").orderBy('time',descending: true).get().then((value) {
      time = value.docs[0]['time'].toString();
      setState(() {
        DatabaseHelper.chatted[index].messageDeliverTime = time;
      });
    });
  }
}
