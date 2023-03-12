import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Models/UserModel.dart';
import 'package:watchminter/Screens/Home/WatchDetailScreen.dart';

import 'ChatUserVisitingWatch.dart';


class ChattedUserWatches extends StatefulWidget {
  final data;
  UserModel userModel;
  ChattedUserWatches(this.data,this.userModel,{Key? key}) : super(key: key);

  @override
  State<ChattedUserWatches> createState() => _ChattedUserWatchesState();
}

class _ChattedUserWatchesState extends State<ChattedUserWatches> {
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        Get.to(ChatUserVisitingWatch(widget.data['watchId'],widget.userModel));
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

