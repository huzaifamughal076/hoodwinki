import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watchminter/Models/ChatModel.dart';

import '../Constants/AppColors.dart';
import '../Constants/my_date_utils.dart';

class ChatTile extends StatefulWidget {
  final chatModel;
  ChatTile(this.chatModel,{Key? key}) : super(key: key);

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.offAll(()=>MessageScreen(widget.senderModel,receiverUser), transition: Transition.zoom);
      },
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 30, // Image radius
                // backgroundColor: isEven ? AppColors.orange : Colors.white,
                 backgroundImage: widget.chatModel['image']!=null ? NetworkImage(widget.chatModel['image']):const AssetImage("assets/images/watch.png") as ImageProvider,
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
                  widget.chatModel['name'] ?? "Name",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.background,
                      fontFamily: "Gotham"),
                ),
                Text(
                  widget.chatModel['id'],
                  style: const TextStyle(
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
                // MyDatUtil.getFormattedTime(context: context, time: widget.chatModel[''].toString()),
                "Time",
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ).marginOnly(left: 12, right: 12, top: 12),
    );
  }
}
