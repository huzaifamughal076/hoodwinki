import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Global/firebase_ref.dart';
import 'package:watchminter/Models/UserModel.dart';
import 'package:watchminter/Models/WatchModel.dart';
import 'package:watchminter/Screens/AddWatchScreen.dart';
import 'package:watchminter/Screens/Home/WatchDetailScreen.dart';

class Collections extends StatefulWidget {
  UserModel userModel;
  Collections(this.userModel, {Key? key}) : super(key: key);
  @override
  State<Collections> createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.white),
          ),
          Container(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "My Collection",
                    style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 24,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w900),
                  ).marginOnly(left: 12, top: 50),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: watchesRef
                          .where("ownerId", isEqualTo: widget.userModel.id)
                          .where('escrow',isEqualTo: true)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data.docs.isEmpty) {
                          return Center(
                            child: Text("No watches found in your collection")
                          );
                        }else if(snapshot.connectionState ==
                            ConnectionState.waiting){
                          EasyLoading.show(status:"Loading");
                          return Container();
                        }
                        else {
                          EasyLoading.dismiss();
                          return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              primary: true,
                              itemCount:  snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return CollectionTiles(snapshot.data.docs[index]);
                              });
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(AddWatchScreen(widget.userModel), transition: Transition.zoom);
        },
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
          'Add watch',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.orange,
      ),
    );
  }

  @override
  void initState() {
EasyLoading.dismiss();
  }
}

//Extra work
class CollectionTiles extends StatefulWidget {
  final data;
  const CollectionTiles(this.data,{Key? key}) : super(key: key);

  @override
  State<CollectionTiles> createState() => _CollectionTilesState();
}

class _CollectionTilesState extends State<CollectionTiles> {

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          Get.to(()=>WatchDetailScreen(widget.data["watchId"]), transition: Transition.zoom);
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
                    child:FadeInImage.assetNetwork(
                      image: widget.data["displayImage"],
                      placeholder: "assets/images/watch.png",
                    ),
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
                  widget.data["brand"],
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
