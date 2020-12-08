import 'dart:collection';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class ErrandBoyRegistrationScreen extends StatefulWidget {

  @override
  _ErrandBoyRegistrationScreenState createState() => _ErrandBoyRegistrationScreenState();
}

const MaterialColor _buttonTextColor = MaterialColor(0xFFC41A3B, <int, Color>{
  50: Color(0xFFC41A3B),
  100: Color(0xFFC41A3B),
  200: Color(0xFFC41A3B),
  300: Color(0xFFC41A3B),
  400: Color(0xFFC41A3B),
  500: Color(0xFFC41A3B),
  600: Color(0xFFC41A3B),
  700: Color(0xFFC41A3B),
  800: Color(0xFFC41A3B),
  900: Color(0xFFC41A3B),

});

class _ErrandBoyRegistrationScreenState extends State<ErrandBoyRegistrationScreen> {
  TextEditingController controller;

  String surName;
  String firstName;
  String address;
  String dob;
  String phoneNo;
  String username;
  String password;
  File image;
  String imageLink;
  String text;
  var formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  bool data = false;




  Future<void> uploadEInfo() async {

    try {
      if (formKey.currentState.validate()) {
        StorageReference reference = FirebaseStorage.instance.ref().child('image');
        StorageUploadTask uploadTask = reference.putFile(image);
        var img = await(await uploadTask.onComplete).ref.getDownloadURL();
        String _imageLink = img.toString();
        setState(() {
          imageLink = _imageLink;
        });

        DatabaseReference dbReference = FirebaseDatabase.instance.reference()
            .child("Errand_boy info");
        String uploadId = dbReference
            .push()
            .key;

        HashMap _map = new HashMap();
        _map['_imageUrl'] = imageLink;
        _map['_surname'] = surName;
        _map['_first_name'] = firstName;
        _map['_address'] = address;
        _map['_date of birth'] = dob;
        _map['_phoneNo'] = phoneNo;
        _map['_username'] = username;
        _map['_password'] = password;

        dbReference.child(uploadId).set(_map);
        setState(() {
          data = true;
        });
      }
    } catch (e) {
      text = "Please check your network connection";
    }
  }

  getGallery(BuildContext context) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = picture;
    });
    Navigator.of(context).pop();
  }

  getCamera(BuildContext context) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      image = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showDialog(BuildContext context){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text('Select Passport Photo from', style: TextStyle(fontSize: 25.0),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              GestureDetector(
                child: Text('Camera'),
                onTap: (){
                  getCamera(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                child: Text('Gallery'),
                onTap: (){
                  getGallery(context);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1980),
      lastDate: DateTime(2100),
      textDirection: TextDirection.ltr,
      initialDatePickerMode: DatePickerMode.day,
      builder: (BuildContext context, Widget child){
        return Theme(
          data: ThemeData(
            primarySwatch: _buttonTextColor,
            primaryColor: Color(0xFFC41A3B),
            accentColor: Color(0xFFC41A3B),
          ),
          child: child,
        );
      });
    if (_datePicker != null && _datePicker != _date){
      setState(() {
        _date = _datePicker;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: Text('Register as Errandboy'),
     backgroundColor: Colors.blue,
     elevation: 0,
     ),
      body: Form(
        key:formKey,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          image != null ? CircleAvatar(
                            child: ClipOval(
                              child: Image.file(image,),
                            ),
                            radius: 65,
                          ):
                          CircleAvatar(
                            child: ClipRect(
                              child: Icon(Icons.person, size: 50,),
                            ),
                            radius: 65,
                          ),
                          SizedBox(height: 5.0,),
                          Padding(
                            padding: const EdgeInsets.only(right: 13.0),
                            child: FlatButton(
                              child: Text('Add Image',),
                              onPressed: (){
                                _showDialog(context);
                              },
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(25.0),
                              ),
                            ),
                          labelText: 'Surname'
                        ),
                        validator: (value){
                          if (value.isEmpty){
                            return 'input password';
                          } else{
                            surName = value;
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(25.0),
                              ),
                            ),
                              labelText: 'First name'
                          ),validator: (value){
                        if (value.isEmpty){
                          return 'input first-name';
                        } else{
                          firstName = value;
                        }
                      },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(25.0),
                              ),
                            ),
                              labelText: 'Home address'
                          ),
                        validator: (value){
                          if (value.isEmpty){
                            return 'input home address';
                          } else{
                            address = value;
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      Stack(
                        children:[
                          TextFormField(
                          enabled:false,
                          readOnly: true,
                            decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(25.0),
                                  ),
                                ),
                                labelText: 'Date of Birth',
                                hintText: (_date.toString().substring(0,10))
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.date_range),
                              onPressed: () => _selectDate(context),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(25.0),
                              ),
                            ),
                              labelText: 'Phone No'
                          ),
                        validator: (value){
                          if (value.isEmpty){
                            return 'input phone number';
                          } else{
                            phoneNo = value;
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(25.0),
                              ),
                            ),
                              labelText: 'Username'
                          ),
                        validator: (value){
                          if (value.isEmpty){
                            return 'input username';
                          } else{
                            username = value;
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(25.0),
                              ),
                          ),
                              labelText: 'Password'
                          ),
                          validator: (value){
                            if (value.isEmpty){
                              return 'input password';
                            } else{
                              password = value;
                            }
                          },

                      ),
                      SizedBox(height: 20.0),
                      RaisedButton(
                        onPressed: (){
                          uploadEInfo();
                        if (data != true){
                          Toast.show('connect your registration to network', context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        } else{
                          Toast.show("you've successfully registered", context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        }},
                        color: Colors.yellow[700],
                        child: Text('Done', style: TextStyle(color: Colors.black,fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
