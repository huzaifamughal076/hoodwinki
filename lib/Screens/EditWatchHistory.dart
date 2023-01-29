import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watchminter/Constants/AppColors.dart';

class EditWatchHistory extends StatefulWidget {
  const EditWatchHistory({Key? key}) : super(key: key);

  @override
  State<EditWatchHistory> createState() => _EditWatchHistoryState();
}

class _EditWatchHistoryState extends State<EditWatchHistory> {
  var counter=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white
            //     image: DecorationImage(
            //   fit: BoxFit.cover,
            //   image: new AssetImage("assets/images/blacknwhite_bg.jpg"),
            // )
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(color: AppColors.orange),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Watch History",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Gotham"),
                      ).marginOnly(top: 30, left: 12)),
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.7,
                  child: ListView.builder(
                      itemCount: counter,
                      itemBuilder: (BuildContext context, int index) {
                      return OwnerDetail();
                      }),

                ),
                Material(
                  elevation: 20,
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                    onTap: () {
                      Get.focusScope!.unfocus();
                      setState(() {
                        counter=counter+1;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Add Qwner",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Gotham",
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ).marginOnly(left: 12, right: 12, top: 12),
                Material(
                  elevation: 20,
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                    onTap: () {
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Save history",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Gotham",
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ).marginOnly(left: 12, right: 12, top: 12),
              ],
            ),
          )
        ],
      ),
    );
  }
}
class OwnerDetail extends StatefulWidget {
  const OwnerDetail({Key? key}) : super(key: key);

  @override
  State<OwnerDetail> createState() => _OwnerDetailState();
}

class _OwnerDetailState extends State<OwnerDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.5,
            child: TextFormField(
              keyboardType: TextInputType.text,
              style: const TextStyle(color: AppColors.background),
              decoration: InputDecoration(
                isDense: true,
                hintText: "Owner name",
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
                      color: AppColors.background, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                      color: AppColors.background, width: 1),
                ),
                // disabledBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(25.0),
                //   borderSide: const BorderSide(
                //       color: Colors.transparent, width: 0),
                // ),
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.4,
            child: TextFormField(
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.background),
              decoration: InputDecoration(
                isDense: true,
                hintText: "Date",
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
                      color: AppColors.background, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                      color: AppColors.background, width: 1),
                ),
                // disabledBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(25.0),
                //   borderSide: const BorderSide(
                //       color: Colors.transparent, width: 0),
                // ),
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          )
        ],
      ).marginAll(12),
    );
  }
}
