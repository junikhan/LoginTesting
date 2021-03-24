import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';





class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  
  var unique_id;
  // var img = Image(
  //     image: AssetImage(
  //       'assets/logo.png',
  //     ),
  //     fit: BoxFit.cover);
  Widget txt = Text('No Image Selected',
      textAlign: TextAlign.center,
      style:
      TextStyle(fontSize: 12, letterSpacing: 0.4, color: Colors.grey[500]));
  String valueChoose;
  List listitems = [
    "1:MCO with RC",
    "2:MCO",
    "3:Lock Open With Rc",
    "4:Estimated Locked ",
    "5:Estimated Defective with RC",
    "6:Estimated Defective",
    "7:RC(Round Complete",
    "8:Defective Status Removal"
  ];
  String valueChoose1;
  List listitems1 = [
    "Normal",
    "Direct hook",
    "Overshoot",
    "Tilted",
    "Not in Use",
    "Meter slowed",
    "Meter Bypassed",
    "Neutral Cut",
    "PVC Inside",
    "No Meter",
    "Meter Damaged",
    "Meter Stopped",
    "Display Washed",
    "At Height",
    "No Electricity",
    "Inaccessable",
    "Incorrect Tarrif",
    "Meter Changed",
    "Not in FWDList",
    "PDISC",
    "TDISC"
  ];
  String FileName = "",
      Status = "",
      _name = "",
      _CNIC = "",
      _sector = "",
      _house = "",
      _phase = "",
      base64Image = "",
      _complaint = "";

  Future<File> file;
  File tmpFile;
  Position position;
  var locationerr = "";

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String errMessage = "Error Uploading Image";
  var wait = true;
  Widget _buildNameField() {
    _getLocation();
    return TextFormField(
      decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(
              minWidth: 20, minHeight: 40, maxWidth: 150, maxHeight: 150),
          labelStyle: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              letterSpacing: 1,
              fontWeight: FontWeight.w500),
          hintText: "Enter Reference Number",
          hintStyle: TextStyle(
              fontSize: 12, color: Colors.grey[500], letterSpacing: 0.6),
          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          isDense: true,
          labelText: 'Reference Number',
          prefixIcon: Padding(
              padding: EdgeInsets.only(right: 7),
              child: Icon(Icons.person, size: 25))),
      keyboardType: TextInputType.phone,
      maxLines: 1,
      minLines: 1,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Reference Number is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _dropDown() {
    return DropdownButton(
      hint: Text("Status Code"),
      dropdownColor: Colors.white,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 20,
      isExpanded: false,
      underline: SizedBox(),
      style: TextStyle(
        color: Colors.blueGrey,
        fontSize: 15,
      ),
      value: valueChoose1,
      onChanged: (newValue) {
        setState(() {
          valueChoose1 = newValue;
        });
      },
      items: listitems1.map((valueItem) {
        return DropdownMenuItem(
          value: valueItem,
          child: Text(valueItem),
        );
      }).toList(),
    );
  }

  //dropdown
  Widget _dropDownStatus() {
    return DropdownButton(
      hint: Text("Select"),
      dropdownColor: Colors.white,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 20,
      isExpanded: false,
      underline: SizedBox(),
      style: TextStyle(
        color: Colors.blueGrey,
        fontSize: 15,
      ),
      value: valueChoose,
      onChanged: (newValue) {
        setState(() {
          valueChoose = newValue;
        });
      },
      items: listitems.map((valueItem) {
        return DropdownMenuItem(
          value: valueItem,
          child: Text(valueItem),
        );
      }).toList(),
    );
  }
  //dropdown end

  Widget _buildCNICField() {
    return TextFormField(
      decoration: InputDecoration(
          labelStyle: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              letterSpacing: 1),
          contentPadding: EdgeInsets.all(0.0),
          prefixIconConstraints: BoxConstraints(
              minWidth: 35, minHeight: 40, maxWidth: 150, maxHeight: 150),
          isDense: true,
          prefixIcon: Padding(
              padding: EdgeInsets.only(right: 7),
              child: Icon(FontAwesomeIcons.phone, size: 18)),
          hintStyle: TextStyle(
              fontSize: 12, color: Colors.grey[500], letterSpacing: 0.5),
          labelText: 'Meter Reading',
          hintText: 'Enter Reading'),
      keyboardType: TextInputType.phone,
      minLines: 1,
      maxLines: 1,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Meter Number Required';
        }
        return null;
      },
      // if (!RegExp(r"[0-9]{5}-[0-9]{7}-[0-9]{1}$").hasMatch(value)) {
      //   return 'Invalid CNIC number';
      // }
      // return null;
      // },
      onSaved: (String value) {
        _CNIC = value;
      },
    );
  }

  // sector address close

  //phase No close

  Widget _buildImageField() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: BorderSide(color: Colors.grey[300])),
      color: Colors.grey[200],
      onPressed: chooseImage,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        "Choose Image",
        style: TextStyle(
            color: Colors.black54,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1),
      ),
    );
  }

  //************
  Widget _buildImageField2() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: BorderSide(color: Colors.grey[300])),
      color: Colors.grey[200],
      onPressed: chooseImage,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        "Choose Image",
        style: TextStyle(
            color: Colors.black54,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1),
      ),
    );
  }

  //************
  Future<void> showImageDialogue(ctx) async {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("Add an Image"),
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return Container(
                height: height * 0.07,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          file = ImagePicker.pickImage(
                              source: ImageSource.camera,
                              maxHeight: 1024,
                              maxWidth: 768,
                              imageQuality: 96);
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Take a photo"),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          file = ImagePicker.pickImage(
                            source: ImageSource.gallery,
                            maxHeight: 1024,
                            maxWidth: 768,
                            imageQuality: 96,
                          );
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Choose from gallery"),
                    )
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }

  Widget chooseImage() {
    showImageDialogue(context);
  }

  void _getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Widget showImage() {
    return FutureBuilder<File>(
        future: file,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            tmpFile = snapshot.data;
            base64Image = base64Encode(snapshot.data.readAsBytesSync());
            if (tmpFile != null) {
              FileName = tmpFile.path.split('/').last;
            }
            return Text(
              "Reading.png",
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            );
          } else if (snapshot.error != null) {
            return const Text(
              'Error Picking Image',
              textAlign: TextAlign.center,
            );
          } else {
            return txt;
          }
        });
  }

  @override
  Widget build(BuildContext context) {

    showLoaderDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(
                margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
          ],
        ),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    Future UploadData() async {
      var pid;
      // var address;
      String url = "http://dgwce.cisnr.com/API/upload.php";
      final response = await http.post(url, body: {
        "Reference No": _name,
        "Meter Reading": _CNIC,
        "image": base64Image,
        "Imagename": FileName,
        "lat": (position.latitude).toString(),
        "long": (position.longitude).toString(),
        "des": _complaint,
      });
      pid = jsonDecode(response.body);
      // address = jsonDecode(response.body);
      if (response.body != "[false]") {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => showMyDialog(pid.toString());
        Navigator.pop(context);
        showMyDialog(context, pid.toString());
        // showMyDialog(context, address.toString());
      }
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 30, 20, 0),
        padding: EdgeInsets.all(0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Text("Please fill in the details below to proceed!",
                    style: TextStyle(
                        letterSpacing: -0.1,
                        fontSize: 14,
                        color: Colors.grey[500]),
                    textAlign: TextAlign.start),
              ),
              SizedBox(
                width: 50,
              ),
              _dropDown(),
              _dropDownStatus(),
              // SizedBox(
              //   height: 15,
              // ),
              // _dropDownStatus(),
              SizedBox(
                height: 15,
              ),
              _buildNameField(),
              SizedBox(
                height: 25,
              ),
              _buildCNICField(),

              SizedBox(
                height: 15,
              ),
              Row(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 0),
                  child: _buildImageField(),
                ),
                SizedBox(
                  width: 5,
                ),
                showImage(),
              ]),

              Text(
                locationerr,
                style: TextStyle(color: Colors.red),
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.86,
                  height: 45,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.orange[700])),
                    color: Colors.orange[700].withOpacity(0.9),
                    onPressed: () {
                      if (tmpFile == null) {
                        setState(() {
                          txt = Text('No Image Selected',
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center);
                        });
                        return;
                      }
                      if (position == null) {
                        setState(() {
                          errMessage = "Location Required";
                          print(errMessage);
                        });
                        _getLocation();
                      }
                      if (!_formkey.currentState.validate()) {
                        return;
                      }
                      _formkey.currentState.save();
                      showLoaderDialog(context);
                      UploadData();
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: -0.1,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 15,
              // ),
              // Center(
              //   child: SizedBox(
              //     width: MediaQuery.of(context).size.width * 0.86,
              //     height: 45,
              //     child: RaisedButton(
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(50.0),
              //           side: BorderSide(color: Colors.black12)),
              //       color: Colors.black54.withOpacity(0.6),
              //       // color: Colors.,
              //       padding: EdgeInsets.all(0),
              //       textColor: Colors.white,
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => FormScreen2()));
              //       },
              //       child: Text(
              //         "Off Peak",
              //         style: TextStyle(
              //             letterSpacing: -0.1,
              //             fontSize: 16,
              //             fontWeight: FontWeight.w600),
              //       ),
              //     ),
              //   ),
              // )
              // Text(Status,textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),

    );



  }

  void showMyDialog(BuildContext context, String string) {}
  
  

 
//  **********

//  **

  
}
