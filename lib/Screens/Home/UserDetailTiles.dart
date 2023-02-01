import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:watchminter/Screens/Home/OtherUserProfileScreen.dart';
import 'package:watchminter/Screens/ViewProfile.dart';

import '../../Constants/AppColors.dart';



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
          Get.to(()=>OtherUserProfileScreen(widget.data));
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
                    child: ClipRRect(
                      // borderRadius:
                      // BorderRadius.circular(MediaQuery.of(context).size.height * .2),
                      child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.height * .15,
                          height: MediaQuery.of(context).size.height * .15,
                          fit: BoxFit.cover,
                          imageUrl: widget.data['image']??"assets/images/watch.png",
                          placeholder: (context, url) =>Image.asset("assets/images/watch.png"),
                          errorWidget: (context, url, error) =>Container(color: AppColors.orange,child: Image.asset("assets/images/watch.png"))
                      ),
                    ),
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