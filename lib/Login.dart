import 'package:LoginTesting/FormScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'MainPage.dart';


class  Login extends StatefulWidget {


//var pref
// Login(this.pref);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String Year,Month;
  List year = ["2018","2019","2020","2021"];
  List month = ["Jan","Feb","March","April","May"];

  TextEditingController username,password;
  String msg='';
  Future<List> _Login() async{
    // final reponse = awit http.post("http://uetpswr.cisnr.")
    final response =await http.post("http://dgwce.cisnr.com/API/authenticate.php",body:{
      "u" :username.text,
      "p": password.text,
      // "pref": pref,
    });
    // print(username.text);
    print(response.body);
    var result=response.body.toString();
    // print(response.body);
    if(response.body == "true"){
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => MainPage(username:username.text,Year:Year,Month:Month)));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FormScreen()));
      }
    else{
      setState(() {
        msg="INCORRECT USERNAME OR PASSWORD";
        print(msg);
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = new TextEditingController();
    password = new TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    debugShowCheckedModeBanner:false;


    return Scaffold(

      //different properties
      backgroundColor:Colors.grey[300],
      body:SingleChildScrollView(

        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 90, 0, 10),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset("assets/logo.png",width: 150,height: 150,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("METRO",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                    Text("CURE",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w300),),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(18,35,18,25),
                  padding: EdgeInsets.fromLTRB(15,15,15,0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(padding:EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text("Enter your Username and Password!",style:TextStyle(fontSize: 15,letterSpacing: 0.5),)),
                      Container(
                        margin: EdgeInsets.fromLTRB(0,20, 0, 5),
                        height: 40,
                        child: TextField(
                          controller: username,
                          decoration: InputDecoration(
                            hintText: "username",
                            contentPadding: const EdgeInsets.symmetric(vertical:2,horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black26, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0,10, 0, 15),
                        height: 40,
                        child: TextField(
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical:2,horizontal: 10),
                            hintText: "Password",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black26, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38),
                            ),
                          ),
                        ),
                      ),

                      Text(
                        msg,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.red,
                          letterSpacing: 0.5,
                        ),

                      ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.only(left: 8,right: 8),
                child: DropdownButton(
                  hint: Text("Select  Year"),
                  dropdownColor: Colors.blueGrey,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 40,
                  isExpanded: true,
                  underline: SizedBox(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  value: Year,
                  onChanged: (newValue)
                  {
                    setState(() {
                      Year = newValue;
                    });
                  },
                  items: year.map((valueItem)
                  {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );

                  }).toList(),
                ),
              ),
            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 8,right: 8),
                          child: DropdownButton(
                            hint: Text("Select  Month"),
                            dropdownColor: Colors.blueGrey,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 40,
                            isExpanded: true,
                            underline: SizedBox(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                            value: Month,
                            onChanged: (newValue)
                            {
                              setState(() {
                                Month = newValue;
                              });
                            },
                            items: month.map((valueItem)
                            {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem),
                              );

                            }).toList(),
                          ),
                        ),
                      ),


                      ButtonTheme(
                        minWidth: 100.0,
                        height: 40.0,
                        child: FlatButton(
                          color: Colors.blue[700],
                          onPressed: (){
                            _Login();


                          },

                          child: Text(
                            'Log In',
                            style: TextStyle(
                                color:Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
  ],
          ),
        ),
            ]
      ),
          ),
        ),
      ),


    );


  }
}