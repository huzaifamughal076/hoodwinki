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
import 'package:watchminter/Global/firebase_ref.dart';
import 'package:watchminter/Models/UserModel.dart';
import 'package:watchminter/Models/WatchHistoryModel.dart';
import 'package:watchminter/Models/WatchModel.dart';

import 'package:intl/intl.dart';

import '../Models/Message.dart';
import '../Screens/Home/HomeScreen.dart';

class DatabaseHelper {
  static FirebaseStorage storage = FirebaseStorage.instance;

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
      Map<String, dynamic> dataFromDB = {
        'id': userData["id"],
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
        "Rating": userData['Rating'],
        "Verified": userData["Verified"]
      };

      userModel = UserModel.fromMap(dataFromDB);

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
    var docId;
    await Firebase.initializeApp();
    //Getting watch details
    await watchesRef.where("watchId", isEqualTo: watchId).get().then((value) {
      value.docs.forEach((doc) {
        watchModel.brand = doc["brand"];
        watchModel.location = doc["location"];
        watchModel.price = doc["price"];
        watchModel.box = doc["box"];
        watchModel.condition = doc["condition"];
        watchModel.displayImage = doc["displayImage"];
        watchModel.forSale = doc["forSale"];
        watchModel.createdAt = doc["createdAt"];
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
    await watchesRef.doc(docId).collection("History").orderBy("time")
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
      "Rating": userData['Rating'],
      "Verified": userData["Verified"],
    };
    userModel = UserModel.fromMap(dataFromDB);

    return userModel;
  }

  Future UpdateWatch(WatchModel watchModel) async {
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
            ownerId: buyerId, buyerId: buyerId, time: currentDate);
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
        await usersRef.doc(userModel.id).update(userModel.toMap());
        UserModel m = await updateProfilePicture(File(_image));
        userModel.image = m.image;
        final prefs = await SharedPreferences.getInstance();
        String data = jsonEncode(userModel.toMap());
        await prefs.setString("usersModel", data);
        EasyLoading.dismiss();
        Get.offAll(HomeScreen(userModel),
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

  Future<void> updateProfileWithNewPassword(_image, UserModel userModel,
      currentPassword, Password) async {
    await Firebase.initializeApp();
    try {
      if (currentPassword != null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: userModel.email, password: currentPassword).then((
            value) async {
          await FirebaseAuth.instance.currentUser!
              .updatePassword(Password)
              .then((value) async {
            await usersRef.doc(userModel.id).update(userModel.toMap());
            UserModel m = await updateProfilePicture(File(_image));
            userModel.image = m.image;
            final prefs = await SharedPreferences.getInstance();
            String data = jsonEncode(userModel.toMap());
            await prefs.setString("usersModel", data);
            EasyLoading.dismiss();
            Get.offAll(HomeScreen(userModel),
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
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    final ref = firestore
        .collection("Chats").doc().set(message.toJson());
    // await ref.doc(time).set(message.toJson());
  }




}


