import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';
import 'package:http/http.dart' as http;
import 'package:watchminter/Models/UserModel.dart';

import '../../../Home/HomeScreen.dart';

class Verify extends StatefulWidget {
  UserModel userModel;
  Verify(this.userModel,{Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

@override
void initState(){
  EasyLoading.dismiss();
}

class _VerifyState extends State<Verify> {
  bool pickedOrNot =false;
  String imageUrl ='';
  var pickedFile;
  var compressed;
  UploadTask? uploadTask;
  XFile?  file;
  Future SelectImage()async{
    final ImagePicker _picker = ImagePicker();
    await Firebase.initializeApp();
    file = await _picker.pickImage(source: ImageSource.camera,maxWidth: 2000,maxHeight: 2000,imageQuality: 20,preferredCameraDevice: CameraDevice.rear);
    if(file!=null) {
      setState(() {
        pickedFile = file;
        pickedOrNot = true;
      });
      compressImage(File(pickedFile!.path));
    }
    else
    {
      Get.snackbar("Alert", "You haven't selected any picture");
    }
  }

  void compressImage(File file) async {
    // Get file path
    // eg:- "Volume/VM/abcd.jpeg"
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 1000,
        minHeight: 1000,
        quality: 10);
    setState(() {
      compressed =  compressedImage;
      final bytes = compressed.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;
      print("Kilobytes:"+kb.toString());
      print("Megabytes:"+mb.toString());
    });
    print("Image Compressed Successfully");
    // Get.to(SelfieTaker(files: pickedFile, customUser: widget.customUser));
    print(compressedImage!.lengthSync());
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.dismiss();
    return Scaffold(
        backgroundColor: Colors.orange,

        body:pickedOrNot?Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height*0.5,
                  child: Image.file(
                    File(pickedFile!.path!),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            //
            // Padding(
            //   padding: EdgeInsets.all(8),
            //   child: buildProgress(),
            // ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: (){
                        SelectImage();
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xff7E8BAC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text("Retake",style: TextStyle(fontSize: 18,color: Colors.white),)),
                      ).marginOnly(top: 12),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: (){
                         Get.to(CardScanner(file,widget.userModel));
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text("Next",style: TextStyle(fontSize: 18,color: Colors.white),)),
                      ).marginOnly(top: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
            :Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Icon(Icons.credit_card,size: 30,)),
              Text("Scan ID Card", style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),),
              InkWell(
                onTap: ()async{
                  // Get.to(CardScanner(),transition: Transition.fade);
                  await SelectImage();

                },
                child: Container(
                  width: 100,
                  height: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xff7E8BAC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text("Scan",style: TextStyle(fontSize: 18,color: Colors.white),)),
                ).marginOnly(top: 12),
              ),

            ]
        )
    );
  }
}

//Card Scanner Class


class CardScanner extends StatefulWidget {
  UserModel userModel;
  final selfiePic;
  CardScanner(this.selfiePic,this.userModel,{Key? key}) : super(key: key);

  @override
  State<CardScanner> createState() => _CardScannerState();
}

class _CardScannerState extends State<CardScanner> {
  bool loading = false;
  bool pickedOrNot =false;
  String imageUrl ='';
  String selfieUrl='';
  var pickedFile;
  var compressed;
  UploadTask? uploadTask;
  XFile?  file;
  Future SelectImage()async{
    final ImagePicker _picker = ImagePicker();
    await Firebase.initializeApp();
    file = await _picker.pickImage(source: ImageSource.camera,maxWidth: 3000,maxHeight: 3000,imageQuality: 20,preferredCameraDevice: CameraDevice.front);
    if(file!=null) {
      setState(() {
        pickedFile = file;
        pickedOrNot = true;
      });
      compressImage(File(pickedFile!.path));
    }
    else
    {
      Get.snackbar("Alert", "You haven't selected any picture");
    }
  }
  void compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 1000,
        minHeight: 1000,
        quality: 10);
    setState(() {
      compressed =  compressedImage;
      final bytes = compressed.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;
      print("Kilobytes:"+kb.toString());
      print("Megabytes:"+mb.toString());
    });
    print("Image Compressed Successfully");
    print(compressedImage!.lengthSync());
  }

  Future<bool> uploadfile()async {
    await Firebase.initializeApp();
    if (compressed == null && widget.selfiePic == null) {
      // Fluttertoast.showToast(
      //     msg: "Something went wrong retake the images");
      return false;
    }
    //Create a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images/');
    String uniqueFileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    //create a reference for image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(
        "card_" + uniqueFileName);
    Reference referenceImageToUpload2 = referenceDirImages.child(
        "Selfie_" + uniqueFileName);

    //Handle error/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(compressed!.path));
      await referenceImageToUpload2.putFile(File(widget.selfiePic!.path));
      //Success get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();
      selfieUrl = await referenceImageToUpload2.getDownloadURL();
      //Get.offAll(NewScreen(customUser: widget.customUser,));
      print("Image URL 1:"+imageUrl);
      print("Image URL 2:"+selfieUrl);

      setState(() {
        loading = false;
      });
      return true;
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      setState(() {
        loading = false;
      });
      return false;
      //errors
    }
  }

  verifyImagesWithAPI()async{
    var url = Uri.parse("https://api-us.faceplusplus.com/facepp/v3/compare");
    setState(() {
      loading = true;
    });
    var response = await http.post(url,body: {
      'api_key': '0BXoYubCsBdeJwYv6ung0kSSu8ipF9P8',
      'api_secret':'xPuHN3-nDYprOhvkRQZFnH1rRW69IPpM',
      'image_url1': imageUrl,
      'image_url2':selfieUrl
    });
    if(response.statusCode==200){
      var decodedResponse=jsonDecode(response.body.toString());
      // var requestid=decodedResponse['request_id'];
      var confidence=decodedResponse['confidence'];
      if(confidence >=65)
      {
        widget.userModel.idVerification = "Yes";
        UserModel userModel=await  DatabaseHelper().SignUp(widget.userModel);
        if(userModel.id==null){
          EasyLoading.dismiss();
          print("Sign up failed");
        }else{
          EasyLoading.dismiss();
          Get.offAll(HomeScreen(userModel),
              transition: Transition.leftToRight);
        }
      }
      else{
        Fluttertoast.showToast(msg: "Please retake the photos");
      }
      setState(() {
        loading = false;
      });


      print("response: "+confidence.toString());
    }else{
      Fluttertoast.showToast(msg: "Please retake the photo's");
      print("responseeeeeeee: "+response.statusCode.toString());
      print("responseeeeeeee: "+response.body.toString());

      setState(() {
        loading = false;
      });

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff616E8F),
        body:pickedOrNot?Stack(
          children: [

            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height*0.5,
                  child: Image.file(
                    File(pickedFile!.path!),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            //
            // Padding(
            //   padding: EdgeInsets.all(8),
            //   child: buildProgress(),
            // ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: (){
                        SelectImage();
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xff7E8BAC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text("Retake",style: TextStyle(fontSize: 18,color: Colors.white),)),
                      ).marginOnly(top: 12),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: loading?InkWell(
                      onTap: ()async{
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xff7E8BAC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text("Processing",style: TextStyle(fontSize: 18,color: Colors.white),)),
                      ).marginOnly(top: 12),
                    ):InkWell(
                      onTap: ()async{
                        setState(() {
                          loading=true;
                        });
                        bool result=await uploadfile();
                        if(result==true){
                          await verifyImagesWithAPI();

                        }
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xff7E8BAC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text("Done",style: TextStyle(fontSize: 18,color: Colors.white),)),
                      ).marginOnly(top: 12),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
                visible: loading,
                child: Center(child: CircularProgressIndicator(color: Color(0xff7E8BAC),),))

          ],
        )
            :Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Icon(Icons.person,size: 30,)),
              Text("Scan Face", style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),),
              InkWell(
                onTap: ()async{
                  // Get.to(CardScanner(),transition: Transition.fade);
                  await SelectImage();

                },
                child: Container(
                  width: 100,
                  height: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xff7E8BAC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text("Scan",style: TextStyle(fontSize: 18,color: Colors.white),)),
                ).marginOnly(top: 12),
              ),

            ]
        )
    );

  }
}

