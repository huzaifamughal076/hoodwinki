import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Constants/my_date_utils.dart';
import '../Models/Message.dart';


class MessageCard extends StatefulWidget {
  final message;
   MessageCard(this.message,{Key? key}) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser!.uid == widget.message['senderId']
        ? _greenMessage()
        : _blueMessage();
  }

  //sender or another user
  Widget _blueMessage() {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Align(
          child: SizedBox(
            width: 310,
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                // side: const BorderSide(color: Colors.purple),
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(10),
                  bottomRight: const Radius.circular(10),
                ),
              ),
              child: ListTile(
                title: Text(
                  widget.message['username'].toString(),
                  style: const TextStyle(fontSize: 15),
                ),
                subtitle: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        widget.message['message'].toString(),
                        softWrap: true,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * .04),
                      child: Text(
                        MyDatUtil.getFormattedTime(
                            context: context, time: widget.message['time'].toString()),
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  //our or user message
  Widget _greenMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Align(
        child: SizedBox(
          width: 310,
          child: Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              // side: const BorderSide(color: Colors.purple),
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(10),
                bottomRight: const Radius.circular(10),
              ),
            ),
            child: ListTile(
              title: Text(
                widget.message['username'].toString(),
                style: const TextStyle(fontSize: 15),
              ),
              subtitle: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      widget.message['message'].toString(),
                      softWrap: true,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .04),
                    child: Text(
                      MyDatUtil.getFormattedTime(
                          context: context, time: widget.message['time'].toString()),
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  }

