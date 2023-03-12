import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Global/firebase_ref.dart';
import 'package:watchminter/Models/UserModel.dart';
import 'package:watchminter/Screens/Home/ChattedUserProfile.dart';
import 'package:watchminter/Screens/Home/HomeScreen.dart';
import 'package:watchminter/Screens/Home/OtherUserProfileScreen.dart';
import 'package:watchminter/Screens/ViewProfile.dart';
import '../../Constants/my_date_utils.dart';
import '../../Database/DatabaseHelper.dart';
import '../../ExternalWidgets/messageCard.dart';
import '../../Models/ChatModel.dart';
import '../../Models/Message.dart';
import 'SubScreens/Chat.dart';

class CommunicationScreen extends StatefulWidget {
    UserModel myUser;
    ChatModel chatModel;

  CommunicationScreen(this.myUser,this.chatModel,{Key? key}): super(key: key);

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  var _list = [];
  final _textController = TextEditingController();
  var text;

  @override
  void initState() {
    super.initState();
    readed();
    setState(() {
    });
  }
  readed()async{
   DatabaseHelper.updateMessageReadStatus(widget.chatModel.ChatId);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //If emoji are shown and back button is been pressed hide does emoji's
        onWillPop: () {
          // Get.offAll(HomeScreen(widget.senderModel,2));
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: const BoxDecoration(color: AppColors.orange),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        // Get.to(ViewProfile(widget.receiverModel),
                        //     transition: Transition.zoom);
                        Get.to(()=>ChattedUserProfile(widget.myUser,widget.chatModel));
                      },
                      child: Text(
                        widget.chatModel.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Gotham"),
                      ).marginOnly(top: 30, left: 12),
                    )),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: chatsRef.doc(widget.chatModel.ChatId??("${widget.myUser.id+widget.chatModel.id}") ).collection("message").orderBy('time',descending: true).snapshots(),
                  builder: (context,AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                    //if is data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(child: SizedBox());

                    //if data is loaded
                      case ConnectionState.active:
                      case ConnectionState.done:
                        _list.clear();
                        final data = snapshot.data?.docs;
                        _list = data??[];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
                              itemBuilder: (context, index) {
                                  // return MessageCard(_list[index],widget.receiverModel);
                                 // print(snapshot.data.docs[index]['read'].toString());

                                 // print(snapshot.data.docs[index].id);

                                if(snapshot.data.docs[index]['senderId']!=FirebaseAuth.instance.currentUser!.uid){
                                  chatsRef.doc(widget.chatModel.ChatId).collection("message").doc(snapshot.data.docs[index].id).update({"read":"Yes"});
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Align(
                                  child: SizedBox(
                                  width: 310,
                                  child: Card(
                                  elevation: 2.0,
                                  shape: const RoundedRectangleBorder(
                                  // side: const BorderSide(color: Colors.purple),
                                  borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  ),
                                  ),
                                  child: ListTile(
                                  title: Text(
                                    snapshot.data.docs[index]['username'],
                                  style: const TextStyle(fontSize: 15),
                                    ),
                                    subtitle: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                    SizedBox(
                                    width: 200,
                                    child: Text(
                                    snapshot.data.docs[index]['message'],
                                    softWrap: true,
                                    style: const TextStyle(fontSize: 15),
                                    ),
                                    ),
                                    Padding(
                                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .04),
                                    child: Text(
                                    MyDatUtil.getFormattedTime(
                                    context: context, time: snapshot.data.docs[index]['time'].toString()),
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                    ),
                                    ],
                                    ),
                                    ),
                                    ),
                                    ),
                                    ),
                                    );
                                });
                        } else {
                          return const Center(
                            child: Text(
                              "Say! Hii ",
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }
                    }
                  },
                ),
              ),
              _ChatInput(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _ChatInput() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            Expanded(
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(10),
                child: TextFormField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.white,
                    hintText: 'Message',
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0,
                        bottom: 8.0,
                        top: 8.0,
                        right: 14.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.orange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.orange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.orange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.orange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    return null;
                  },
                  onSaved: (value) {
                    //message.text = value!;
                  },
                ),
              ).marginOnly(left: 14.0, top: 0, right: 14.0),
            ),
            IconButton(
              onPressed: () async{
                text= _textController.text;
                _textController.clear();
                if(text==null){
                  Get.snackbar("Error", "Message field is empty",
                      colorText: AppColors.white,
                      icon: const Icon(Icons.error_outline, color: Colors.white),
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: AppColors.orange);
                }else{
                      // await DatabaseHelper.sendNewMessage(widget.chatModel.id,text.toString(),widget.myUser);
                  if(widget.chatModel.ChatId!=null){
                    await chatsRef.doc(widget.chatModel.ChatId).collection("message").doc().set({
                      'message': text.toString(),
                      'time': DateTime.now().millisecondsSinceEpoch,
                      'senderId': widget.myUser.id,
                      'receiverId': widget.chatModel.id,
                      'username': widget.myUser.name,
                      'read': "No",
                    });
                  }
                  else{
                    // print("else Runed");
                    // print(widget.chatModel.ChatId);
                    // print(widget.chatModel.id);
                    // print(widget.chatModel.name);
                    var controller = TextEditingController();
                    controller.text = text;

                    await DatabaseHelper.sendNewMessage(widget.chatModel.id, controller, widget.myUser);
                    // await chatsRef.doc(widget.myUser.id+widget.chatModel.id).collection("message").doc().set({
                    //   'message': text.toString(),
                    //   'time': DateTime.now().millisecondsSinceEpoch,
                    //   'senderId': widget.myUser.id,
                    //   'receiverId': widget.chatModel.id,
                    //   'username': widget.myUser.name
                    // });
                  }

                  // await chatsRef.doc(widget.chatModel.ChatId).collection("message").set({
                  //   'message': text.toString(),
                  //   'time': DateTime.now().millisecondsSinceEpoch,
                  //   'senderId': widget.senderModel.id,
                  //   'receiverId': widget.receiverModel.id,
                  //   'username': widget.senderModel.name
                  // });

                 }

              },
              icon: const Icon(
                Icons.send_sharp,
                color: AppColors.orange,
              ),
            ),
          ],
        ).marginOnly(bottom: 30)
    );
  }

}

class MessageTile extends StatefulWidget {
  const MessageTile({Key? key}) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    child: Image.asset("assets/images/watch.png",
                        fit: BoxFit.fill),
                    radius: 20,
                    backgroundColor: Colors.orange,
                  )),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    const Text(
                      "Hi saw your rolex submariner just posted. Would you consider selling",
                      style: TextStyle(
                          color: AppColors.background,
                          fontSize: 18,
                          fontFamily: "Gotham"),
                    ).marginOnly(left: 8, right: 18, top: 18),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: const Text(
                        "12:00 PM",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: "Gotham"),
                      ).marginOnly(right: 12),
                    )
                  ],
                ),
              ),
            ],
          ),
        )).marginOnly(top: 12, left: 20, right: 20);
  }
}
