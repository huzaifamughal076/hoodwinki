import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../../Constants/AppColors.dart';

class WatchImageViewScreen extends StatefulWidget {
  List imageFileList = [];
   WatchImageViewScreen(this.imageFileList,{Key? key}) : super(key: key);

  @override
  State<WatchImageViewScreen> createState() => _WatchImageViewScreenState();
}

class _WatchImageViewScreenState extends State<WatchImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider(
        options: CarouselOptions(
            enableInfiniteScroll: false,
            scrollPhysics: const BouncingScrollPhysics(),
            viewportFraction: 1.0),
        items: widget.imageFileList!.isNotEmpty?widget.imageFileList?.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Image.file(File(i)));
            },
          );
        }).toList():[1].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(color: AppColors.white),
                  child: Image.asset(
                    "assets/images/watch.png",
                  ));
            },
          );
        }).toList(),
      ),
    );
  }
}
