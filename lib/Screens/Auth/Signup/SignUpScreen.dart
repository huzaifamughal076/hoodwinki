import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Database/DatabaseHelper.dart';
import 'package:watchminter/Models/UserModel.dart';
import 'package:watchminter/Screens/Auth/Signup/SignUpSectionTwo.dart';
import 'package:watchminter/Screens/Home/HomeScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var name, email, password, confirmPassword, dob;
  var houseNumber, street, town, province, zip, country;
  var emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.white
                //     image: DecorationImage(
                //   fit: BoxFit.cover,
                //   // colorFilter: new ColorFilter.mode(
                //   //     Colors.black.withOpacity(0.1), BlendMode.dstATop),
                //   image: new AssetImage("assets/images/blacknwhite_bg.jpg"),
                // )
                ),
          ),
          SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Join our community",
                      style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 24,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w900),
                    ).marginOnly(left: 12, top: 50),
                  ),
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            validator: (Name) {
                              if (Name == null || Name.isEmpty) {
                                return "Name Required";
                              } else {
                                name = Name;
                                return null;
                              }
                            },
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Name",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              // disabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(25.0),
                              //   borderSide: const BorderSide(
                              //       color: Colors.transparent, width: 0),
                              // ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ).marginOnly(left: 12, right: 12, top: 40),
                          TextFormField(
                            validator: (Email) {
                              if (Email == null || Email.isEmpty) {
                                return "Email Required";
                              } else if (!emailValid.hasMatch(Email)) {
                                return "Provided email is not correct";
                              } else {
                                email = Email;
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Email",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              // disabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(25.0),
                              //   borderSide: const BorderSide(
                              //       color: Colors.transparent, width: 0),
                              // ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ).marginOnly(left: 12, right: 12, top: 20),
                          TextFormField(
                            validator: (Password) {
                              if (Password == null || Password.isEmpty) {
                                return "Password required";
                              } else if (Password.length < 6) {
                                return "Password should be greater than 6 characters";
                              } else {
                                password = Password;
                                return null;
                              }
                            },
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Password",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              // disabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(25.0),
                              //   borderSide: const BorderSide(
                              //       color: Colors.transparent, width: 0),
                              // ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ).marginOnly(left: 12, right: 12, top: 20),
                          TextFormField(
                            validator: (ConfirmPassword) {
                              if (ConfirmPassword == null ||
                                  ConfirmPassword.isEmpty) {
                                return "Re enter your password here";
                              } else if (password != null &&
                                  ConfirmPassword != password) {
                                return "Passwords don't match";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Confirm Password",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              // disabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(25.0),
                              //   borderSide: const BorderSide(
                              //       color: Colors.transparent, width: 0),
                              // ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ).marginOnly(left: 12, right: 12, top: 20),
                          TextFormField(
                            validator: (DOB) {
                              if (DOB == null || DOB.isEmpty) {
                                return "Date of birth required";
                              } else {
                                dob = DOB;
                                return null;
                              }
                            },
                            keyboardType: TextInputType.datetime,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "DOB (MM/DD/YYYY)",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              // disabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(25.0),
                              //   borderSide: const BorderSide(
                              //       color: Colors.transparent, width: 0),
                              // ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ).marginOnly(
                              left: 12, right: 12, top: 20, bottom: 40),
                        ],
                      ),
                    ),
                  ).marginOnly(left: 12, right: 12, top: 40),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Address Details",
                        style:
                            TextStyle(color: Colors.grey, fontFamily: 'Gotham'),
                      )).marginOnly(top: 30, left: 12),
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (House) {
                              if (House == null || House.isEmpty) {
                                return "House name/number required";
                              } else {
                                houseNumber = House;
                                return null;
                              }
                            },
                            keyboardType: TextInputType.streetAddress,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "House name / number",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              // disabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(25.0),
                              //   borderSide: const BorderSide(
                              //       color: Colors.transparent, width: 0),
                              // ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ).marginOnly(left: 12, right: 12, top: 20),
                          TextFormField(
                            validator: (Street) {
                              if (Street == null || Street.isEmpty) {
                                return "Street required";
                              } else {
                                street = Street;
                                return null;
                              }
                            },
                            keyboardType: TextInputType.streetAddress,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Street",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              // disabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(25.0),
                              //   borderSide: const BorderSide(
                              //       color: Colors.transparent, width: 0),
                              // ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ).marginOnly(left: 12, right: 12, top: 20),
                          TextFormField(
                            validator: (Town) {
                              if (Town == null || Town.isEmpty) {
                                return "Town required";
                              } else {
                                town = Town;
                                return null;
                              }
                            },
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Town",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              // disabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(25.0),
                              //   borderSide: const BorderSide(
                              //       color: Colors.transparent, width: 0),
                              // ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ).marginOnly(left: 12, right: 12, top: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: (Province) {
                                    if (Province == null || Province.isEmpty) {
                                      return "Province required";
                                    } else {
                                      province = Province;
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.streetAddress,
                                  style: const TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Province",
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: AppColors.background,
                                          width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: AppColors.orange, width: 1),
                                    ),
                                    // disabledBorder: OutlineInputBorder(
                                    //   borderRadius: BorderRadius.circular(25.0),
                                    //   borderSide: const BorderSide(
                                    //       color: Colors.transparent, width: 0),
                                    // ),
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                  ),
                                ).marginOnly(
                                  right: 6,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  validator: (Zip) {
                                    if (Zip == null || Zip.isEmpty) {
                                      return "Zip required";
                                    } else {
                                      zip = Zip;
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.streetAddress,
                                  style: const TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Post code / zip code",
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: AppColors.background,
                                          width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: AppColors.orange, width: 1),
                                    ),
                                    // disabledBorder: OutlineInputBorder(
                                    //   borderRadius: BorderRadius.circular(25.0),
                                    //   borderSide: const BorderSide(
                                    //       color: Colors.transparent, width: 0),
                                    // ),
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                  ),
                                ).marginOnly(
                                  left: 6,
                                ),
                              )
                            ],
                          ).marginOnly(left: 12, right: 12, top: 20),
                          TextFormField(
                            validator: (Country) {
                              if (Country == null || Country.isEmpty) {
                                return "Country required";
                              } else {
                                country = Country;
                                return null;
                              }
                            },
                            keyboardType: TextInputType.streetAddress,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Country",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.background, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: AppColors.orange, width: 1),
                              ),
                              // disabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(25.0),
                              //   borderSide: const BorderSide(
                              //       color: Colors.transparent, width: 0),
                              // ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ).marginOnly(
                              left: 12, right: 12, top: 20, bottom: 20),
                        ],
                      ),
                    ),
                  ).marginOnly(left: 12, right: 12, top: 8),
                  InkWell(
                    onTap: () async {
                      if (formKey.currentState != null &&
                          formKey.currentState!.validate()) {
                        var userModel=UserModel(id: password,name: name,email: email,dob: dob,house: houseNumber,street: street,town: town,province: province,zip: zip,country: country);
                        if (userModel == null) {

                        } else {
                          Get.to(SignUpSectionTwo(userModel),
                              transition: Transition.leftToRight);
                        }
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Continue",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Gotham",
                                color: Colors.white),
                          ),
                          Image.asset(
                            "assets/images/next.png",
                            height: 15,
                            width: 20,
                          ).marginOnly(left: 10)
                        ],
                      ),
                    ).marginOnly(left: 12, right: 12, top: 40, bottom: 12),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
