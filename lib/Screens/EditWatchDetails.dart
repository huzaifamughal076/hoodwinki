import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watchminter/Constants/AppColors.dart';
import 'package:watchminter/Models/WatchModel.dart';

class EditWatchDetails extends StatefulWidget {
  WatchModel watchModel;

  EditWatchDetails(this.watchModel, {Key? key}) : super(key: key);

  @override
  State<EditWatchDetails> createState() => _EditWatchDetailsState();
}

class _EditWatchDetailsState extends State<EditWatchDetails> {
  List<String> conditionList = ['New', 'Very Good', 'Good', 'Fair'];
  List<String> yesno = ['No', 'Yes'];
  var selectedPapersOption;
  var selectedBoxOption;
  var brandName, model, serialNumber, condition;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.watchModel.brand == null) {
      widget.watchModel.brand = "";
    }
    if (widget.watchModel.model == null) {
      widget.watchModel.model = "";
    }
    if (widget.watchModel.serialNumber == null) {
      widget.watchModel.serialNumber = "";
    }
    if (widget.watchModel.condition == null) {
      widget.watchModel.condition = conditionList[0];
    }
    if (widget.watchModel.papers == null) {
      widget.watchModel.papers = yesno[0];
    }
    if (widget.watchModel.box == null) {
      widget.watchModel.box = yesno[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.white
                ),
          ),
          SingleChildScrollView(
              child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(color: AppColors.orange),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Edit watch details",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Gotham"),
                      ).marginOnly(top: 30, left: 12)),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Watch Id",
                      style: TextStyle(
                          color: AppColors.background, fontFamily: "Gotham"),
                    )),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        style: const TextStyle(color: AppColors.background),
                        initialValue: "xxxxx-xxxxx-xxxx",
                        decoration: InputDecoration(
                          isDense: true,
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
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Brand",
                      style: TextStyle(
                          color: AppColors.background, fontFamily: "Gotham"),
                    )),
                    Expanded(
                      child: TextFormField(
                        validator: (Brand) {
                          brandName = Brand;
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: AppColors.background),
                        initialValue: widget.watchModel.brand,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Brand Name",
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
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Model",
                      style: TextStyle(
                          color: AppColors.background, fontFamily: "Gotham"),
                    )),
                    Expanded(
                      child: TextFormField(
                        validator: (Model) {
                          model = Model;
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: AppColors.background),
                        initialValue: widget.watchModel.model,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Model",
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
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Serial",
                      style: TextStyle(
                          color: AppColors.background, fontFamily: "Gotham"),
                    )),
                    Expanded(
                      child: TextFormField(
                        validator: (serial) {
                          serialNumber = serial;
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: AppColors.background),
                        initialValue: widget.watchModel.serialNumber,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Serial Number",
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
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Condition",
                      style: TextStyle(
                          color: AppColors.background, fontFamily: "Gotham"),
                    )),
                    Expanded(
                      child: DropdownButtonFormField(
                        elevation: 8,
                        isExpanded: true,
                        iconSize: 0.0,
                        hint: Text('Select Condition'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.arrow_drop_down),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: conditionList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                                //alignment: Alignment.centerRight,
                                child: Text(value)),
                          );
                        }).toList(),
                        value: widget.watchModel.condition,
                        onChanged: (newValue) {
                          setState(() {
                           // condition = newValue as String;
                            widget.watchModel.condition = newValue as String;
                          });
                        },
                      ),
                    )
                  ],
                ).marginAll(12),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Original papers",
                      style: TextStyle(
                          color: AppColors.background, fontFamily: "Gotham"),
                    )),
                    Expanded(
                      child: DropdownButtonFormField(
                        elevation: 8,
                        isExpanded: true,
                        iconSize: 0.0,
                        hint: Text('Select option'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.arrow_drop_down),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: yesno.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                                //alignment: Alignment.centerRight,
                                child: Text(value)),
                          );
                        }).toList(),
                        value: widget.watchModel.papers,
                        onChanged: (newValue) {
                          setState(() {
                           // selectedPapersOption = newValue as String;
                            widget.watchModel.papers = newValue as String;
                          });
                        },
                      ),
                    )
                  ],
                ).marginAll(12),
                selectedPapersOption == 'Yes'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Upload papers",
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Gotham'),
                          ),
                          Row(children: [
                            Text(
                              "Selected file ",
                              style: TextStyle(
                                  color: Colors.black, fontFamily: 'Gotham'),
                            ),
                            Icon(Icons.upload_file)
                          ])
                        ],
                      ).marginAll(12)
                    : Container(),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Original Box",
                      style: TextStyle(
                          color: AppColors.background, fontFamily: "Gotham"),
                    )),
                    Expanded(
                      child: DropdownButtonFormField(
                        elevation: 8,
                        isExpanded: true,
                        iconSize: 0.0,
                        hint: Text('Select option'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.arrow_drop_down),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: yesno.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                                //alignment: Alignment.centerRight,
                                child: Text(value)),
                          );
                        }).toList(),
                        value: widget.watchModel.box,
                        onChanged: (newValue) {
                          setState(() {
                            //selectedBoxOption = newValue as String;
                            widget.watchModel.box = newValue as String;
                          });
                        },
                      ),
                    )
                  ],
                ).marginAll(12),
                selectedBoxOption == 'Yes'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Upload pictures",
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Gotham'),
                          ),
                          Row(children: [
                            Text(
                              "Selected file ",
                              style: TextStyle(
                                  color: Colors.black, fontFamily: 'Gotham'),
                            ),
                            Icon(Icons.upload_file)
                          ])
                        ],
                      ).marginAll(12)
                    : Container(),
                Material(
                  elevation: 20,
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                    onTap: () {
                      Get.focusScope!.unfocus();

                      if (formKey.currentState != null &&
                          formKey.currentState!.validate()) {
                        widget.watchModel.brand = brandName;
                        widget.watchModel.model = model;
                        widget.watchModel.serialNumber = serialNumber;
                         // widget.watchModel.condition=condition;
                         // widget.watchModel.papers=selectedPapersOption;
                         // widget.watchModel.box=selectedBoxOption;
                        Get.back(result: widget.watchModel);
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Save changes",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Gotham",
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ).marginOnly(left: 12, right: 12, top: 22),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
