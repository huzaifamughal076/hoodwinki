import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:watchminter/Screens/Home/OtherUserProfileScreen.dart';
import 'package:watchminter/Screens/ViewProfile.dart';



class UserDetailTiles extends StatefulWidget {
  final data;
  const UserDetailTiles(this.data,{Key? key}) : super(key: key);

  @override
  State<UserDetailTiles> createState() => _UserDetailTilesState();
}

class _UserDetailTilesState extends State<UserDetailTiles> {



  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          Get.to(OtherUserProfileScreen(widget.data));
        },
        child: Container(
          width: 200,
          height: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.transparent),
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Icon(Icons.person,size: 80,color: Colors.black54,),
                    // child:FadeInImage.assetNetwork(
                    //   image: Icon(Icons.person).toString(),
                    //   placeholder: "assets/images/watch.png",
                    // ),
                    // Image.asset("assets/images/watch.png"),
                  )),
              Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                    ),
                    child: Center(
                        child: Text(
                          widget.data["Name"],
                          style: TextStyle(
                              fontFamily: "Gotham", fontWeight: FontWeight.bold),
                        )),
                  ))
            ],
          ),
        ),
      ),
    ).marginAll(12);
  }

  @override
  void initState() {
    // print("displayImage: "+widget.data["displayImage"].toString());
  }
}