import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';
import 'package:watchminter/Screens/Home/SubScreens/Collections.dart';

import '../../Constants/AppColors.dart';
import '../../Global/firebase_ref.dart';
import '../../Models/UserModel.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<UserModel> ReviewsNeeded=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: const BoxDecoration(color: AppColors.orange),
            child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                  },
                  child: Text(
                    "Reviews",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Gotham"),
                  ).marginOnly(top: 30, left: 12),
                )),
          ),


          (ReviewsNeeded.isNotEmpty)?Expanded(
            child: GridView.builder(
              itemCount: ReviewsNeeded.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {

                    showDialog(context: context, builder: (context) {
                      return RatingDialog(
                        initialRating: 2,
                        starColor: AppColors.orange,
                        image: Image.asset("assets/images/hood.png",height: 50,),
                        message: const Text("Please rate the client",textAlign: TextAlign.center,style: TextStyle(color: AppColors.grey,fontSize: 12),),
                        starSize: 30.0,
                        title: const Text("Rating",textAlign: TextAlign.center,style: TextStyle(color: AppColors.orange),),
                        submitButtonText: 'Submit',
                        showCloseButton: true,
                        enableComment: false,
                        onCancelled: ()async{
                          Navigator.of(context);
                          // await DatabaseHelper.SendNeedReviewFromBoth(FirebaseAuth.instance.currentUser!.uid,BuyerModel.id);
                          // await DatabaseHelper.SendNeedReview(FirebaseAuth.instance.currentUser!.uid);
                          Fluttertoast.showToast(msg: "Please be Sure to Review him later");
                        },
                        onSubmitted: (RatingDialogResponse ) async {
                          if (kDebugMode) {
                            print('rating: ${RatingDialogResponse.rating}');
                          }
                          await usersRef.doc(ReviewsNeeded[index].id).get().then((val) async {
                            List pointlist = List.from(val.data()!['Rating']);
                            pointlist.add(RatingDialogResponse.rating);
                            ReviewsNeeded[index].rating = pointlist;
                            await usersRef.doc(ReviewsNeeded[index].id).update(ReviewsNeeded[index].toMap());
                            // await DatabaseHelper.NeedReviewFromPurchaser(FirebaseAuth.instance.currentUser!.uid,widget.reviewUserModel.id);
                          });
                          String id = ReviewsNeeded[index].id;
                          print(id);
                          ReviewsNeeded.removeAt(index);
                          setState(() {
                            ReviewsNeeded;
                          });
                          try{
                            await usersRef.doc(FirebaseAuth.instance.currentUser!.uid).collection("Reviews").doc(id).delete();

                          }on FirebaseAuthException catch(e){
                            print(e.message.toString());


                          }
                        },
                      );
                    });
                  },
                  child: UserReviewTile(ReviewsNeeded[index],index));
            },),
          ): Expanded(child: Center(child: Text("No Reviews"),))




      ],),

    );
  }

  @override
  void initState() {
    // DatabaseHelper.SendNeedReview(FirebaseAuth.instance.currentUser!.uid);
    GetPendingReivews();

  }
  GetPendingReivews()async{
    EasyLoading.show();
    ReviewsNeeded.clear();
    await usersRef.doc(FirebaseAuth.instance.currentUser!.uid).collection("Reviews").get().then((value)async{
      value.docs.forEach((element) async{
        UserModel userModel = await DatabaseHelper().GetSpecificUser(element.id);
        print(userModel.image.toString());
        ReviewsNeeded.add(userModel);
        setState(() {
          ReviewsNeeded;
        });
      });
    });

    Future.delayed(Duration(seconds: 1),(){
      EasyLoading.dismiss();
    });
  }

}

class UserReviewTile extends StatefulWidget {
  int index;
  UserModel reviewUserModel;
   UserReviewTile(this.reviewUserModel,this.index,{Key? key}) : super(key: key);

  @override
  State<UserReviewTile> createState() => _UserReviewTileState();
}

class _UserReviewTileState extends State<UserReviewTile> {

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
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
                  child:(widget.reviewUserModel.image==null)?Image.asset("assets/images/watch.png"):FadeInImage.assetNetwork(
                    image: widget.reviewUserModel.image,
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
                        widget.reviewUserModel.name,
                        style: TextStyle(
                            fontFamily: "Gotham", fontWeight: FontWeight.bold),
                      )),
                ))
          ],
        ),
      ),
    ).marginAll(12);
  }

  @override
  void initState() {
    setState(() {

    });
  }
}

