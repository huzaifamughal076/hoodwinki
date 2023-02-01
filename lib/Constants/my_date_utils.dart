import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDatUtil {
  //For getting formatted Time
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time.toString()));
    return TimeOfDay.fromDateTime(date).format(context);
    // DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(time.toString()));
    // final DateFormat formatter = new DateFormat('h:mm a');
    // return formatter.format(date);

  }
  static String getFormattedYear(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time.toString()));
    return TimeOfDay.fromDateTime(date).format(context);
    // DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(time.toString()));
    // final DateFormat formatter = new DateFormat('h:mm a');
    // return formatter.format(date);

  }

  static String getLastMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return '${sent.day} ${_getMonth(sent)} ${sent.year}';
  }

  //Get month name from month no. index
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'N/A';
  }

  //Get last active Time
  static String getLastActiveTime({required BuildContext context, required String lastActive}){
    final int  i = int.parse(lastActive)??-1;
    //if time is not availabe return this below statement
    if(i==-1)return 'Last seen is not available';
    DateTime time= DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if(time.day ==now.day && time.month == now.month&&time.year==now.year){
      return 'Last seen today at ${formattedTime}';
    }
    if((now.difference(time).inHours/24).round()==1){
      return 'Last seen yesterday at ${formattedTime}';
    }
    String month = _getMonth(time);
    return 'Last seen on ${time.day} $month on $formattedTime';
  }
}
