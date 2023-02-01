import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:watchminter/Screens/Home/SubScreens/Collections.dart';

import '../../../Constants/AppColors.dart';
import '../../../Global/firebase_ref.dart';
import '../../../Models/UserModel.dart';
import '../../../Models/WatchModel.dart';
import '../UserDetailTiles.dart';


class Search extends StatefulWidget {
  UserModel _userModel;
  Search(this._userModel,{Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with WidgetsBindingObserver {
//For Storing all Users
  var _usersList = [];
  var _searchUserList=[];

  var _watchList = [];
  var _searchWatchList = [];



  //FOr Storing search status
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          if(_isSearching){
            _isSearching==false;
          }
        });
        FocusScope.of(context).unfocus();

      },
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.white
                  ),
                ),
                SingleChildScrollView(
                  child: Column(children: [

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: BoxDecoration(color: AppColors.orange),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Search",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: "Gotham"),
                          ).marginOnly(top: 30, left: 12)),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      child: TextFormField(
                        onTap: (){
                          if(!_isSearching){
                            setState(() {
                              _isSearching=!_isSearching;
                            });
                          }
                        },
                        onChanged: ((val) {
                          //searching logic.
                          _searchWatchList.clear();
                          _searchUserList.clear();
                          for (var i in _watchList) {
                            if (i['brand']
                                .toLowerCase()
                                .contains(val.toLowerCase()) ||
                                i['location']
                                    .toLowerCase()
                                    .contains(val.toLowerCase())||
                                i['model']
                                    .toLowerCase()
                                    .contains(val.toLowerCase())||
                                i['serialNumber']
                                    .toLowerCase()
                                    .contains(val.toLowerCase())) {
                              _searchWatchList.add(i);
                            }
                            setState(() {
                              _searchWatchList;
                            });
                          }
                          for (var i in _usersList) {
                            if (i['Name']
                                .toLowerCase()
                                .contains(val.toLowerCase()) ||
                                i['id']
                                    .toLowerCase()
                                    .contains(val.toLowerCase())||
                                i['Email']
                                    .toLowerCase()
                                    .contains(val.toLowerCase())||
                                i['Province']
                                    .toLowerCase()
                                    .contains(val.toLowerCase())||
                                i['Country']
                                    .toLowerCase()
                                    .contains(val.toLowerCase())||
                                i['Business details']
                                    .toLowerCase()
                                    .contains(val.toLowerCase())
                            ) {
                              _searchUserList.add(i);
                            }
                            setState(() {
                              _searchUserList;
                            });
                          }
                        }),
                        // focusNode: focusNodePassword,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: AppColors.background),
                        decoration: InputDecoration(
                          suffixIcon:
                          _isSearching
                              ?InkWell(
                              onTap: (){
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _isSearching=!_isSearching;
                                });
                              },
                              child: Icon(CupertinoIcons.clear_circled_solid,color: AppColors.orange,))
                              :Icon(Icons.search,color: Colors.grey,),
                          isDense: true,
                          hintText: "Search",
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: AppColors.background, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: AppColors.background, width: 0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: AppColors.orange, width: 1),
                          ),
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),

                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Text("Watches",style: TextStyle(color: Colors.black54,fontSize:18),)),
                    StreamBuilder(
                      stream: watchesRef
                          .where("ownerId",isNotEqualTo: widget._userModel.id)
                          .snapshots(),
                      builder: (context,AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                        //if is data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return Center(child: CircularProgressIndicator());

                        //if data is loaded
                          case ConnectionState.active:
                          case ConnectionState.done:
                            _watchList.clear();

                            final data = snapshot.data?.docs;
                            print(data.length);

                            _watchList = data??[];

                            if (_searchWatchList.isNotEmpty) {
                              return GridView.builder(
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  primary: true,
                                  itemCount:  _searchWatchList.length,
                                  itemBuilder: (context, index) {
                                    return CollectionTiles(_searchWatchList[index]);
                                  });
                            } else {
                              return Center(
                                child: Text("No Watch Found",style: TextStyle(color: Colors.black54),),
                              );
                            }
                        }
                      },
                    ),
                    SizedBox(height: 15,),
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Text("Users",style: TextStyle(color: Colors.black54,fontSize:18),)),
                    StreamBuilder(
                      stream: usersRef.where("id",isNotEqualTo: widget._userModel.id).snapshots(),
                      builder: (context,AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                        //if is data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return Center(child: CircularProgressIndicator());
                        //if data is loaded
                          case ConnectionState.active:
                          case ConnectionState.done:
                            _usersList.clear();

                            final data = snapshot.data?.docs;
                            print(data.length);

                            _usersList = data??[];

                            if (_searchUserList.isNotEmpty) {
                              return GridView.builder(
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  primary: true,
                                  itemCount:  _searchUserList.length,
                                  itemBuilder: (context, index) {
                                    return UserDetailTiles(_searchUserList[index]);
                                  });
                            } else {
                              return Center(
                                child: Text("No User Found",style: TextStyle(color: Colors.black54),),
                              );
                            }
                        }
                      },
                    ),


                  ],
                  ),
                ),
              ]),

        ),

      ),
    );

  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    EasyLoading.dismiss();

  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      Future.delayed(Duration(seconds: 2),(){
        EasyLoading.dismiss();
      });
    }
  }
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    EasyLoading.dismiss();
  }
}