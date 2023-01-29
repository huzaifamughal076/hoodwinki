import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Global/firebase_ref.dart';
import 'package:watchminter/Models/UserModel.dart';

class CreateNewMessage extends StatefulWidget {
  final UserModel userModel;

  const CreateNewMessage(this.userModel, {Key? key}) : super(key: key);

  @override
  State<CreateNewMessage> createState() => _CreateNewMessageState();
}

class _CreateNewMessageState extends State<CreateNewMessage> {
  final TextEditingController message = new TextEditingController();
  var recipientId;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Message"),
        backgroundColor: AppColors.orange,
      ),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "To: ",
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                  child: TextFormField(
                    validator: (id) {
                      if (id == null || id.isEmpty) {
                        return "Recipient required";
                      } else {
                        recipientId = id;
                      }
                    },
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: AppColors.background),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "User id",
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: AppColors.background, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: AppColors.orange, width: 1),
                      ),
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ).marginOnly(left: 12, right: 12),
                ),
              ],
            ).marginSymmetric(horizontal: 10),
            Text(
              "Message",
              style: TextStyle(fontSize: 16),
            ).marginSymmetric(horizontal: 10, vertical: 12),
            TextFormField(
              controller: message,
              maxLines: 10,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: AppColors.background),
              decoration: InputDecoration(
                isDense: true,
                hintText: "Message",
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: AppColors.background, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: AppColors.orange, width: 1),
                ),
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ).marginSymmetric(horizontal: 12),
            InkWell(
              onTap: () async {
                if (formKey.currentState != null &&
                    formKey.currentState!.validate()) {
                  if (message.text.isNotEmpty) {
                    DocumentSnapshot userData =
                        await usersRef.doc(recipientId).get();
                    if (!userData.exists) {
                      Get.snackbar("Error", "No such user found",
                          colorText: AppColors.white,
                          icon: Icon(Icons.error_outline, color: Colors.white),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.orange);
                    } else {
                      EasyLoading.show(status: "Sending");
                      await chatsRef.doc().set({
                        'message': message.text.toString(),
                        'time': DateTime.now().millisecondsSinceEpoch,
                        'senderId': widget.userModel.id,
                        'receiverId': recipientId,
                        'username': widget.userModel.name
                      });
                      EasyLoading.dismiss();
                      Get.back();
                    }
                  } else {
                    Get.snackbar("Error", "Message field is empty",
                        colorText: AppColors.white,
                        icon: Icon(Icons.error_outline, color: Colors.white),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.orange);
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Send",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Gotham",
                          color: Colors.white),
                    ),
                    Icon(
                      Icons.send,
                      color: AppColors.white,
                    ).marginOnly(left: 8)
                  ],
                ),
              ),
            ).marginOnly(top: 20, left: 12, right: 12),
          ],
        ).marginOnly(top: 12),
      ),
    );
  }
}
