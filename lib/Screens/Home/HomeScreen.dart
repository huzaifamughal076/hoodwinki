import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';
import 'package:watchminter/Models/UserModel.dart';
import 'package:watchminter/Screens/Home/SubScreens/Chat.dart';
import 'package:watchminter/Screens/Home/SubScreens/Collections.dart';
import 'package:watchminter/Screens/Home/SubScreens/MyProfile.dart';
import 'package:watchminter/Screens/Home/SubScreens/Search.dart';

import 'SubScreens/ChatScreen.dart';

class HomeScreen extends StatefulWidget {
  UserModel userModel;
   var _selectedIndex;
  HomeScreen(this.userModel,this._selectedIndex,{Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _page;
  var currentBackPressTime ;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold,);
  List<Widget> _widgetOptions() =>
      [
       Collections(widget.userModel),
        MyProfile(widget.userModel),
        ChatScreen(widget.userModel),
        Search(widget.userModel),
      ];

  void _onItemTapped(int index) {
    setState(() {
      widget._selectedIndex = index;
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Fluttertoast.showToast(msg: "Tap again to exit",textColor: Colors.black);
      Get.showSnackbar(
        GetSnackBar(
          title: "",
          message: 'Tap again to exit',
          backgroundColor: AppColors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }



  @override
  void initState() {
    _page=Collections(widget.userModel);
    DatabaseHelper.GetChatted(widget.userModel);
    DatabaseHelper.GetPendingReivews();
    DatabaseHelper.GetUpdatedMessageAlert();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        extendBody: false,
        backgroundColor: Color(0xffEEEEEE),
        body: Center(
          child: _widgetOptions().elementAt(widget._selectedIndex),
        ),

        bottomNavigationBar:
        BottomNavigationBar(
          elevation: 20,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.watch_outlined, size: 20,),
              label: 'Watches',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 20,),
              label: 'My Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined, size: 20,),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 20,),
              label: 'Search',
            ),

          ],

          currentIndex: widget._selectedIndex,
          selectedItemColor: Colors.orange,
          onTap: _onItemTapped,
        ),
      ),
    );
  }






      // bottomNavigationBar: CurvedNavigationBar(
      //   key: _bottomNavigationKey,
      //   index: 0,
      //   backgroundColor: AppColors.orange,
      //   height: 60,
      //   animationDuration: Duration(milliseconds: 400),
      //   color: AppColors.background,
      //   items: <Widget>[
      //     Icon(Icons.collections, size: 20,color: Colors.white,),
      //     Icon(Icons.person, size: 20,color: Colors.white,),
      //     Icon(Icons.message_outlined, size: 20,color: Colors.white,),
      //     Icon(Icons.search, size: 20,color: Colors.white,),
      //   ],
      //   onTap: (index) {
      //     if(index==0){
      //       setState(() {
      //         _page = Collections();
      //       });
      //     }
      //     if(index==1){
      //       setState(() {
      //         _page = MyProfile();
      //       });
      //     }
      //     if(index==2){
      //       setState(() {
      //         _page = Chat();
      //       });
      //     }
      //     if(index==3){
      //       setState(() {
      //         _page = Search();
      //       });
      //     }
      //   },
      // ),
      //   body: _page
    // );
  }

