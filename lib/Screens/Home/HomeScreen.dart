import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Models/UserModel.dart';
import 'package:watchminter/Screens/Home/SubScreens/Chat.dart';
import 'package:watchminter/Screens/Home/SubScreens/Collections.dart';
import 'package:watchminter/Screens/Home/SubScreens/MyProfile.dart';
import 'package:watchminter/Screens/Home/SubScreens/Search.dart';

class HomeScreen extends StatefulWidget {
  UserModel userModel;
  HomeScreen(this.userModel,{Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _page;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold,);
  List<Widget> _widgetOptions() =>
      [
       Collections(widget.userModel),
        MyProfile(widget.userModel),
        Chat(widget.userModel),
        Search(widget.userModel),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  void initState() {
    _page=Collections(widget.userModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: Color(0xffEEEEEE),
      body: Center(
        child: _widgetOptions().elementAt(_selectedIndex),
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

        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
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

