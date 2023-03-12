import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Constants/my_date_utils.dart';
import 'package:watchminter/Global/firebase_ref.dart';
import 'package:watchminter/Models/ChatModel.dart';
import 'package:watchminter/Models/UserModel.dart';
import 'package:watchminter/Models/WatchHistoryModel.dart';
import 'package:watchminter/Models/WatchModel.dart';

import 'package:intl/intl.dart';
import 'package:watchminter/Screens/Home/CommunicationScreen.dart';

import '../Models/Message.dart';
import '../Screens/Home/HomeScreen.dart';

class DatabaseHelper {
  static List<ChatModel> chatted=[];
  static FirebaseStorage storage = FirebaseStorage.instance;
  static List<UserModel> ReviewsNeeded=[];
  // static var selected;

  Future<UserModel> SignUp(UserModel model) async {
    UserModel userModel = UserModel();
    await Firebase.initializeApp();
    String currentTime = DateTime.now().toString();

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: model.email,
        password: model.id,
      );
      var userid = userCredential.user!.uid;
      userModel = model;
      userModel.id = userid;
      userModel.createdAt = currentTime;
      userModel.rating=[];
      await usersRef.doc(userCredential.user!.uid).set(userModel.toMap());
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      Fluttertoast.showToast(msg: "Email Verification Link has been sent");
      return userModel;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.toString(),
          colorText: AppColors.white,
          icon: Icon(Icons.error_outline, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.orange);
      return userModel;
    }
  }

  Future<UserModel> SignIn(var email, var password) async {
    UserModel userModel = UserModel();
    await Firebase.initializeApp();
    try {
      FirebaseAuth _auth = await FirebaseAuth.instance;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      var userId = userCredential.user!.uid;

      DocumentSnapshot userData = await usersRef.doc(userId).get();

        double sum=0.0;
       var rating;
      await usersRef.doc(userId).get().then((val) async {
        List pointlist = List.from(val.data()!['Rating']);
        if(pointlist.isNotEmpty || pointlist.length!=0){
          for(var i in pointlist){
              print(i);
              sum += i;
          }
          print("SUM: "+sum.toString());
          rating = sum/pointlist.length;
          print("Rating is: "+rating.toString());
        }
        else{
          rating = 0.0;
        }


      });
      Map<String, dynamic> dataFromDB = {
        'id': userData["id"],
        'image':userData["image"],
        'Name': userData["Name"],
        'Email': userData["Email"],
        'DOB': userData["DOB"],
        'House_name_number': userData["House_name_number"],
        'Street': userData["Street"],
        'Town': userData["Town"],
        'Province': userData["Province"],
        'Zip': userData["Zip"],
        'Country': userData["Country"],
        'About': userData["About"],
        'Business details': userData["Business details"],
        'Type': userData["Type"],
        'Created at': userData["Created at"],
        "Rating": rating,
        "Verified": userData["Verified"],
        "CountryCode": userData["CountryCode"]
      };

      userModel = UserModel.fromMap(dataFromDB);
      print(userData["CountryCode"]);

      return userModel;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.toString(),
          colorText: AppColors.white,
          icon: Icon(Icons.error_outline, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.orange);
      return userModel;
    }
  }

 static Future rating(userId) async {

    List pointlist=[];
    var sum;
    var rating;
    print(userId);
    // await usersRef.doc(userId).get().then((val) async {
    //   pointlist = List.from(val.data()!['Rating']);
    //   for(var i in pointlist){
    //     sum += int.tryParse(pointlist[i]);
    //   }
    //   rating = sum/pointlist.length;
    // });

    await usersRef.doc(userId).get().then((val) async {
      List pointlist = List.from(val.data()!['Rating']);
      // widget.usermodel.rating = pointlist;
      // await usersRef.doc(userId).update(widget.usermodel.toMap());
      // Get.back();
      print(pointlist.length);
    });

    return rating;

  }

  Future AddWatch(WatchModel watchModel) async {
    await Firebase.initializeApp();
    WatchHistoryModel watchHistoryModel = WatchHistoryModel(
        ownerId: watchModel.ownerId, time: watchModel.createdAt);

    watchModel.watchId = UniqueKey().toString();
    var docId = watchesRef
        .doc()
        .id;

    watchModel.displayImage = await uploadfile(
      watchModel.images,
      docId,
    );
    await watchesRef.doc(docId).set(watchModel.toMap());
    await watchesRef
        .doc(docId)
        .collection("History")
        .doc()
        .set(watchHistoryModel.toMap());
  }

  Future<WatchModel> GetWatch(String watchId) async {
    WatchModel watchModel = WatchModel();
    var time;
    var docId;
    await Firebase.initializeApp();
    //Getting watch details
    await watchesRef.where("watchId", isEqualTo: watchId).get().then((value) {
      value.docs.forEach((doc) async {
        watchModel.brand = doc["brand"];
        watchModel.location = doc["location"];
        watchModel.price = doc["price"];
        watchModel.box = doc["box"];
        watchModel.condition = doc["condition"];
        watchModel.displayImage = doc["displayImage"];
        watchModel.forSale = doc["forSale"];
        time = doc["createdAt"];
        watchModel.model = doc["model"];
        watchModel.offeredBy = doc["offeredBy"];
        watchModel.ownerId = doc["ownerId"];
        watchModel.papers = doc["papers"];
        watchModel.serialNumber = doc["serialNumber"];
        watchModel.watchId = doc["watchId"];
        watchModel.verified = doc["verified"];
        docId = doc.id;
      });
    }).catchError((onError) {
      Get.snackbar("Error", onError.toString(),
          colorText: AppColors.white,
          icon: Icon(Icons.error_outline, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.orange);
      return watchModel;
    });
    //Getting watch images
    List<String> images = [];
    await watchesRef.doc(docId).collection("Images").get().then((value) {
      value.docs.forEach((element) {
        images.add(element["Img"].toString());
      });
      watchModel.images = images;
    }).catchError((onError) {
      Get.snackbar("Error", onError.toString(),
          colorText: AppColors.white,
          icon: Icon(Icons.error_outline, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.orange);
      return watchModel;
    });
    //Getting watch history
    List<WatchHistoryModel> historyList = [];
    await watchesRef.doc(docId).collection("History").orderBy("time",descending: false)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        WatchHistoryModel watchHistoryModel =
        WatchHistoryModel.fromMap(element);
        historyList.add(watchHistoryModel);
      });
      watchModel.history = historyList;
    }).catchError((onError) {
      Get.snackbar("Error", onError.toString(),
          colorText: AppColors.white,
          icon: Icon(Icons.error_outline, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.orange);
      return watchModel;
    });
    watchModel.createdAt =  MyDatUtil.getFormatedDateYear(time: time.toString());
    return watchModel;
  }

  Future<void> DeleteWatch(WatchModel _watchModel) async {
    // Fluttertoast.showToast(msg: "Fuction Called");
    EasyLoading.show();
    var docId;
    await watchesRef
        .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('watchId', isEqualTo: _watchModel.watchId).get().then((value) {
      value.docs.forEach((element) {
        print(element.id);
        docId = element.id;
      });
    });

    await watchesRef.doc(docId).delete();
    Fluttertoast.showToast(msg: "Watch Deleted");
    EasyLoading.dismiss();
    Get.back();
  }

  static Future<bool> userExists(userId) async {
    return (await usersRef
        .doc(userId)
        .get())
        .exists;
  }

  static Future<bool> usersInDeleted(userId) async {
    return (await FirebaseFirestore.instance.collection("Deleted Users")
        .doc(userId)
        .get())
        .exists;
  }

  Future<UserModel> GetSpecificUser(String userId) async {
    UserModel userModel = UserModel();
    late DocumentSnapshot userData;
    Future<bool> result = userExists(userId);
    print("User in User Ref" + result.toString());
    if (await result) {
      userData = await usersRef.doc(userId).get();
    }
    else {
      var _result = await usersInDeleted(userId);
      print("User in Deleted Ref" + result.toString());
      if (_result == true) {
        userData = await FirebaseFirestore.instance.collection("Deleted Users")
            .doc(userId)
            .get();
      } else {
        print("Somthing went wrong");
      }
    }

    double sum=0.0;
    var rating;
    await usersRef.doc(userId).get().then((val) async {
      List pointlist = List.from(val.data()!['Rating']);
      if(pointlist.isNotEmpty || pointlist.length!=0){
        for(var i in pointlist){
          print(i);
          sum += i;
        }
        print("SUM: "+sum.toString());
        rating = sum/pointlist.length;
        print("Rating is: "+rating.toString());
      }
      else{
        rating = 0.0;
      }


    });


    Map<String, dynamic> dataFromDB = {
      'id': userData["id"],
      'Name': userData["Name"],
      'image': userData["image"],
      'Email': userData["Email"],
      'DOB': userData["DOB"],
      'House_name_number': userData["House_name_number"],
      'Street': userData["Street"],
      'Town': userData["Town"],
      'Province': userData["Province"],
      'Zip': userData["Zip"],
      'Country': userData["Country"],
      'About': userData["About"],
      'Business details': userData["Business details"],
      'Type': userData["Type"],
      'Created at': userData["Created at"],
      "Rating": rating,
      "Verified": userData["Verified"],
      "CountryCode": userData["CountryCode"]
    };
    userModel = UserModel.fromMap(dataFromDB);

    return userModel;
  }

  Future UpdateWatch(WatchModel watchModel) async {
    await Firebase.initializeApp();
    var docID;
    // watchModel.escrow = true;
    await watchesRef
        .where("watchId", isEqualTo: watchModel.watchId)
        .get()
        .then((value) async {
      value.docs.forEach((element) {
        docID = element.id;
      });
      await watchesRef.doc(docID).set(watchModel.toMap());
      print(docID);
    });
  }

  Future EditWatch(display, WatchModel watchModel, images) async {
    await Firebase.initializeApp();
    var docID;
    watchModel.escrow = true;
    await watchesRef
        .where("watchId", isEqualTo: watchModel.watchId)
        .get()
        .then((value) async {
      value.docs.forEach((element) {
        docID = element.id;
      });

      if (images != null) {
        watchModel.images = images;
        watchModel.displayImage = await uploadfile(watchModel.images, docID);
        await watchesRef.doc(docID).set(watchModel.toMap());
      } else {
        watchModel.displayImage = display;
        await watchesRef.doc(docID).update(watchModel.toMap());
        await watchesRef.doc(docID).set(
            {'displayImage': display.toString()});
      }
      // watchModel.displayImage= watchModel.images[0];

      // print(docID);
    });
  }

  Future uploadfile(images, docId) async {
    await Firebase.initializeApp();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    bool first_call = false;
    var displayImage;
    for (var image in images) {
      var imageUrl;
      String imgUniqueName = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      Reference referenceDirImages = await referenceRoot
          .child('images/watch_images')
          .child("watch_" + imgUniqueName);
      try {
        await referenceDirImages.putFile(File(image.path));
        imageUrl = await referenceDirImages.getDownloadURL();
        if (!first_call) {
          displayImage = imageUrl;
          first_call = true;
        }
        await watchesRef
            .doc(docId)
            .collection("Images")
            .doc()
            .set({"Img": imageUrl});
      } catch (e) {
        print(e.toString());
        Get.snackbar("Error", e.toString(),
            colorText: AppColors.white,
            icon: Icon(Icons.error_outline, color: Colors.white),
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.orange);
      }
    }
    return displayImage;
  }

  // Future uploadUpdatedfile(images, docId) async {
  //   await Firebase.initializeApp();
  //   Reference referenceRoot = FirebaseStorage.instance.ref();
  //   bool first_call = false;
  //   var displayImage;
  //   for (var image in images) {
  //     var imageUrl;
  //     String imgUniqueName = DateTime.now().millisecondsSinceEpoch.toString();
  //     Reference referenceDirImages = await referenceRoot
  //         .child('images/watch_images')
  //         .child("watch_" + imgUniqueName);
  //     try {
  //       await referenceDirImages.putFile(File(image.path));
  //       imageUrl = await referenceDirImages.getDownloadURL();
  //       if (!first_call) {
  //         displayImage = imageUrl;
  //         first_call = true;
  //       }
  //       await watchesRef
  //           .doc(docId)
  //           .collection("Images")
  //           .doc()
  //           .set({"Img": imageUrl});
  //     } catch (e) {
  //       print(e.toString());
  //       Get.snackbar("Error", e.toString(),
  //           colorText: AppColors.white,
  //           icon: Icon(Icons.error_outline, color: Colors.white),
  //           snackPosition: SnackPosition.TOP,
  //           backgroundColor: AppColors.orange);
  //     }
  //   }
  //   return displayImage;
  // }

  Future<bool> SellWatch(WatchModel watchModel, buyerId) async {
    var docID;
    DateTime now = DateTime.now();
    String currentDate = DateFormat('d MMM y').format(now);
    DocumentSnapshot userData = await usersRef.doc(buyerId).get();
    if (userData.exists) {
      watchModel.ownerId = buyerId;

      await UpdateWatch(watchModel);
      watchesRef
          .where("watchId", isEqualTo: watchModel.watchId)
          .get()
          .then((value) async {
        value.docs.forEach((element) {
          docID = element.id;
        });
        WatchHistoryModel watchHistoryModel = WatchHistoryModel(
            ownerId: buyerId, buyerId: buyerId, time: DateTime.now().millisecondsSinceEpoch);
        await watchesRef.doc(docID).collection("History").doc().set(
            watchHistoryModel.toMap());
        print(docID);
        return true;
      });

      return true;
    } else {
      return false;
    }
  }

  static Future<void> resetPassword(var email, BuildContext context) async {
    await Firebase.initializeApp();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar(email, "link has been sent", colorText: Colors.white,
          backgroundColor: AppColors.orange);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  static Future<void> signOut() async {
    if (FirebaseAuth.instance.currentUser != null)
      try {
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        print(e.toString());
      }
  }

  Future<void> DeleteAccount() async {
    if (FirebaseAuth.instance.currentUser != null)
      try {
        UserModel _userModel = await GetSpecificUser(
            FirebaseAuth.instance.currentUser!.uid);
        FirebaseFirestore.instance.collection("Deleted Users").doc(
            _userModel.id).set(_userModel.toMap());
        usersRef.doc(_userModel.id).delete();
        await FirebaseAuth.instance.currentUser!.delete();
      } catch (e) {
        print(e.toString());
      }
  }

  Future<void> updateProfile(_image, UserModel userModel, Password) async {
    await Firebase.initializeApp();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userModel.email, password: Password).then((value) async {
        double sum=0.0;
        var rating;
        await usersRef.doc(userModel.id).get().then((val) async {
          List pointlist = List.from(val.data()!['Rating']);
          if(pointlist.isNotEmpty || pointlist.length!=0){
            for(var i in pointlist){
              print(i);
              sum += i;
            }
            print("SUM: "+sum.toString());
            rating = sum/pointlist.length;
            print("Rating is: "+rating.toString());
          }
          else{
            rating = 0.0;
          }

          userModel.rating = pointlist;
        });
        await usersRef.doc(userModel.id).update(userModel.toMap());
        userModel.rating = rating;
        if(_image!=null){
          UserModel m = await updateProfilePicture(File(_image));
          userModel.image = m.image;
        }
        final prefs = await SharedPreferences.getInstance();
        String data = jsonEncode(userModel.toMap());
        await prefs.setString("usersModel", data);
        EasyLoading.dismiss();
        Get.offAll(HomeScreen(userModel,0),
            transition: Transition.leftToRight);
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.toString(),
          colorText: AppColors.white,
          icon: Icon(Icons.error_outline, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.orange);
      EasyLoading.dismiss();
    }
  }

  Future<void> updateProfileWithNewPassword(_image, UserModel userModel, currentPassword, Password) async {
    await Firebase.initializeApp();
    try {
      if (currentPassword != null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: userModel.email, password: currentPassword).then((
            value) async {
          double sum=0.0;
          var rating;
          await usersRef.doc(userModel.id).get().then((val) async {
            List pointlist = List.from(val.data()!['Rating']);
            if(pointlist.isNotEmpty || pointlist.length!=0){
              for(var i in pointlist){
                print(i);
                sum += i;
              }
              print("SUM: "+sum.toString());
              rating = sum/pointlist.length;
              print("Rating is: "+rating.toString());
            }
            else{
              rating = 0.0;
            }
            userModel.rating = pointlist;
          });

          await FirebaseAuth.instance.currentUser!
              .updatePassword(Password)
              .then((value) async {
            await usersRef.doc(userModel.id).update(userModel.toMap());
            userModel.rating = rating;
            if(_image!=null){
              UserModel m = await updateProfilePicture(File(_image));
              userModel.image = m.image;
            }
            final prefs = await SharedPreferences.getInstance();
            String data = jsonEncode(userModel.toMap());
            await prefs.setString("usersModel", data);
            EasyLoading.dismiss();
            Get.offAll(HomeScreen(userModel,0),
                transition: Transition.leftToRight);
          });
        });
      } else {
        Fluttertoast.showToast(msg: "Please Check your Password");
        EasyLoading.dismiss();
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.toString(),
          colorText: AppColors.white,
          icon: Icon(Icons.error_outline, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.orange);
      print(e.toString());
      Fluttertoast.showToast(msg: "Check Fields");
      EasyLoading.dismiss();
    }
  }

  static Future<UserModel> updateProfilePicture(File file) async {
    UserModel userModel = UserModel();
    FirebaseStorage storage = FirebaseStorage.instance;
    final ext = file.path
        .split('.')
        .last;
    log("Extension" + ext);
    final ref = storage.ref().child(
        'profile_pictures/${FirebaseAuth.instance.currentUser!.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred${p0.bytesTransferred / 1000} kb');
    });
    //updating image in firebase firestore
    userModel.image = await ref.getDownloadURL();
    await usersRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'image': userModel.image});

    return userModel;
  }

  // chats(collection)-->conversation_Id(doc)-->messages (collection)-->message (doc)


  //To Send Messages

  static Future<void> sendMessage(id, Message message) async {
    // final time = DateTime
    //     .now()
    //     .millisecondsSinceEpoch
    //     .toString();

    final ref = await firestore
        .collection("Chats").doc().set(message.toJson());
    // await ref.doc(time).set(message.toJson());
  }


  static Future<void> sendNewMessage(receiverId,message,UserModel SenderModel)async{
    ChatModel SenderChatSide =ChatModel();
    ChatModel ReceiverChatSide =ChatModel();
    // ReceiverModel = await DatabaseHelper().GetSpecificUser(receiverId);

    Message messages=Message(
      read: "No",
      message: message.text.toString(),
      time: DateTime.now().millisecondsSinceEpoch,
      senderId: SenderModel.id,
      receiverId: receiverId,
      username: SenderModel.name,
    );
    await chatsRef.doc(SenderModel.id+receiverId).collection("message").doc().set(messages.toJson()).then((value) async{
      var chatId = SenderModel.id+receiverId;
      // Adding data on Chat Side
      SenderChatSide.id = receiverId;
      SenderChatSide.ChatId = chatId;
      //Adding Data on Receiver Side;
      ReceiverChatSide.id = SenderModel.id;
      ReceiverChatSide.ChatId= chatId;
      await usersRef.doc(SenderModel.id).collection("Chats").doc(receiverId).set(SenderChatSide.ChatMap());
      await usersRef.doc(receiverId).collection("Chats").doc(SenderModel.id).set(ReceiverChatSide.ChatMap());

    });

  }

  static Future<void> GetChatted(UserModel myuser)async {
    print("Chat Called");
    chatted.clear();
    await usersRef.doc(myuser.id).collection("Chats").get().then((value) {

      value.docs.forEach((element) async {
        // print(element.data()["id"]);
        // chatted = element.data()["id"];
        ChatModel chatModel = ChatModel();
        UserModel ReceiverModel = UserModel();
        chatModel.id = element.data()["id"];
        chatModel.ChatId = element.data()["ChatId"];
        ReceiverModel =  await DatabaseHelper().GetSpecificUser(chatModel.id);
        chatModel.name = ReceiverModel.name;
        chatModel.CountryCode = ReceiverModel.CountryCode;
        chatModel.email = ReceiverModel.email;
        chatModel.country = ReceiverModel.country;
        chatModel.zip = ReceiverModel.zip;
        chatModel.province = ReceiverModel.province;
        chatModel.town = ReceiverModel.town;
        chatModel.street = ReceiverModel.street;
        chatModel.house = ReceiverModel.house;
        chatModel.id = ReceiverModel.id;
        chatModel.about = ReceiverModel.about;
        chatModel.createdAt = ReceiverModel.createdAt;
        chatModel.image = ReceiverModel.image;
        chatModel.businessDetails = ReceiverModel.businessDetails;
        chatModel.dob = ReceiverModel.dob;
        chatModel.type = ReceiverModel.type;
        chatModel.idVerification = ReceiverModel.idVerification;
        chatted.add(chatModel);
      });
      for(var i in chatted){
        print(i.ChatId);
      }
    });


  }

  static Future<void> LoadSpecificChat(UserModel userModel)async{
    bool result = (await usersRef.doc(FirebaseAuth.instance.currentUser!.uid).collection("Chats").doc(userModel.id).get()).exists;
    if(result==true){
      ChatModel chatModel = ChatModel();
      UserModel ReceiverModel = UserModel();
      UserModel myUser = UserModel();
      await usersRef.doc(FirebaseAuth.instance.currentUser!.uid).collection("Chats").doc(userModel.id).get().then((value) async {
        print(value.data()!['id']);
        chatModel.id = value.data()!['id'];
        chatModel.ChatId = value.data()!['ChatId'];
        ReceiverModel =  await DatabaseHelper().GetSpecificUser(chatModel.id);
        chatModel.name = ReceiverModel.name;
        chatModel.CountryCode = ReceiverModel.CountryCode;
        chatModel.email = ReceiverModel.email;
        chatModel.country = ReceiverModel.country;
        chatModel.zip = ReceiverModel.zip;
        chatModel.province = ReceiverModel.province;
        chatModel.town = ReceiverModel.town;
        chatModel.street = ReceiverModel.street;
        chatModel.house = ReceiverModel.house;
        chatModel.id = ReceiverModel.id;
        chatModel.about = ReceiverModel.about;
        chatModel.createdAt = ReceiverModel.createdAt;
        chatModel.image = ReceiverModel.image;
        chatModel.businessDetails = ReceiverModel.businessDetails;
        chatModel.dob = ReceiverModel.dob;
        chatModel.type = ReceiverModel.type;
        chatModel.idVerification = ReceiverModel.idVerification;
      });
      myUser = await DatabaseHelper().GetSpecificUser(FirebaseAuth.instance.currentUser!.uid);
      Get.to(()=>CommunicationScreen(myUser, chatModel));
    }
    else{
      ChatModel chatModel = ChatModel();
      UserModel ReceiverModel = UserModel();
      UserModel myUser = UserModel();


      ReceiverModel =  await DatabaseHelper().GetSpecificUser(userModel.id);
        chatModel.id = ReceiverModel.id;
        // chatModel.ChatId = value.data()!['ChatId'];
        chatModel.name = ReceiverModel.name;
        chatModel.CountryCode = ReceiverModel.CountryCode;
        chatModel.email = ReceiverModel.email;
        chatModel.country = ReceiverModel.country;
        chatModel.zip = ReceiverModel.zip;
        chatModel.province = ReceiverModel.province;
        chatModel.town = ReceiverModel.town;
        chatModel.street = ReceiverModel.street;
        chatModel.house = ReceiverModel.house;
        chatModel.id = ReceiverModel.id;
        chatModel.about = ReceiverModel.about;
        chatModel.createdAt = ReceiverModel.createdAt;
        chatModel.image = ReceiverModel.image;
        chatModel.businessDetails = ReceiverModel.businessDetails;
        chatModel.dob = ReceiverModel.dob;
        chatModel.type = ReceiverModel.type;
        chatModel.idVerification = ReceiverModel.idVerification;

      myUser = await DatabaseHelper().GetSpecificUser(FirebaseAuth.instance.currentUser!.uid);
      Get.to(()=>CommunicationScreen(myUser, chatModel));
    }

  }

  static String getLastMessageTime({required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return '${sent.day} ${_getMonth(sent)}';
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

  //Get Reivews
  static Future SendNeedReviewFromBoth(sellerId,purchaserId)async{
    await usersRef.doc(sellerId).collection("Reviews").doc(purchaserId).set({"reviews":purchaserId});
    await usersRef.doc(purchaserId).collection("Reviews").doc(sellerId).set({"reviews":sellerId});
  }

  static Future NeedReviewFromPurchaser(sellerId,purchaserId)async{
    // await usersRef.doc(sellerId).collection("Reviews").doc(purchaserId).set({"reviews":purchaserId});
    await usersRef.doc(purchaserId).collection("Reviews").doc(sellerId).set({"reviews":sellerId});
  }
  static Future GetPendingReivews()async{
    ReviewsNeeded.clear();
    await usersRef.doc(FirebaseAuth.instance.currentUser!.uid).collection("Reviews").get().then((value)async{
      value.docs.forEach((element) async{
        UserModel userModel = await DatabaseHelper().GetSpecificUser(element.id);
        print(userModel.image.toString());
        ReviewsNeeded.add(userModel);
      });
    });
    ReviewsNeeded;
  }

  static  GetUpdatedMessageAlert()async{
    
    for(var i in chatted){
      await chatsRef.doc(i.ChatId).collection("message").snapshots().listen((event) {
        event.docs.forEach((element) {
          print(element.id.toString());
        });

      });
      
    }
  }

  static Future<void> updateMessageReadStatus(ChatId) async {
    print("CALLLED");
    firestore.collection("Chats/${ChatId}/message/").snapshots().listen((value) {
          value.docs.forEach((element) {
            element.data().updateAll((key, value) => {"read":"Yes"});
          });

    });
  }



}


