import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../Constants/AppColors.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  final controllerSubject = TextEditingController();
  final controllerMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        title: Text("Contact Us"),),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Image.asset("assets/images/watch.png", width: 200,)),
          const Text("If you have any queries, please e mail on this mail")
              .marginOnly(top: 20),

          // Text("nfo-hoodwinke@gmail.com"),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 20,),
              InkWell(
                onTap: () async {
                  await Clipboard.setData(
                      ClipboardData(text: "Info-hoodwinke@gmail.com"));
                  Get.snackbar("Copy Successfull", "Id copied to clipboard",
                      colorText: AppColors.white,
                      icon: Icon(Icons.error_outline, color: Colors.white),
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: AppColors.orange);
                },
                child: Text(
                  "Info-hoodwinke@gmail.com",
                  style: TextStyle(color: AppColors.orange, letterSpacing: 2,),
                ).marginOnly(top: 10),
              ),
            ],
          ),


        ],
      ),
    );
  }
}
