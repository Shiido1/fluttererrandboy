import 'dart:collection';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';


class CustomersRequestScreen extends StatefulWidget {

  @override
  _CustomersRequestScreenState createState() => _CustomersRequestScreenState();
}

class _CustomersRequestScreenState extends State<CustomersRequestScreen> {
  TextEditingController controller;

  String wellDescriptionOfItem;
  String locationFrom;
  String locationTo;
  double noOfItem;
  double weightOfItem;
  double costOfErrand;
  String phoneNo;

  File image;
  String imageLink;
  static String repName;
  static String repNumber;

  var formKey = GlobalKey<FormState>();
  String text = '';
  var data;

  void showToast(String msg, {int duration, int gravity}) {
      Toast.show(msg, context,
          duration: duration, gravity: gravity);
      if (data != null) {
          text = "You've Successfully requested for an Errand boy";
      }else {
          text = "Connect your request to network..!";
      }if (image == null){
        text = 'Please insert image of your item';
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
        title: Text('Select Image Item'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              GestureDetector(
                child: Text('Gallery'),
                onTap: (){
                  getGallery(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                child: Text('Camera'),
                onTap: (){
                  getCamera(context);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _decideImage(){
    if (image == null){
      return Text ('No Image');
    } else {
      return Image.file(image, width: 400, height: 300,);
    }
  }
  

  double getCostOfErrandForNoItem(double numOfItem){

    costOfErrand = (numOfItem * 1000.0);
    if (numOfItem > 3 && numOfItem <= 5){
      costOfErrand = 3000.0;
    } else if (numOfItem >= 6 && numOfItem <= 10){
      costOfErrand = 3500.0;
    } else if (numOfItem >= 11 && numOfItem <= 15){
      costOfErrand = 4000.0;
    } else if (numOfItem >= 16 && numOfItem <= 20){
      costOfErrand = 4500.0;
    } else if (numOfItem >= 21 && numOfItem <= 25){
      costOfErrand = 5000.0;
    } else if (numOfItem >= 26 && numOfItem <= 30){
      costOfErrand = 5500.0;
    } else if (numOfItem >= 31 && numOfItem <= 35){
      costOfErrand = 6000.0;
    } else if (numOfItem >= 36 && numOfItem <= 40){
      costOfErrand = 6500.0;
    } else if (numOfItem >= 41 && numOfItem <= 45){
      costOfErrand = 7000.0;
    } else if (numOfItem >= 46 && numOfItem <= 50){
      costOfErrand = 7500.0;
    } else if (numOfItem > 50) {
      costOfErrand = (numOfItem * 1000.0) * 0.3 / 2;
    }
     return costOfErrand;
  }

  double getCostOfErrandForWeight(double weight){
   costOfErrand = weight * 100.0;
    return costOfErrand;
  }

  
  Future<void> upload() async {

     try{
       if (formKey.currentState.validate()) {
         StorageReference reference = FirebaseStorage.instance.ref().child(
             'image');
         StorageUploadTask uploadTask = reference.putFile(image);
         var img = await(await uploadTask.onComplete).ref.getDownloadURL();
         String _imageLink = img.toString();
         setState(() {
           imageLink = _imageLink;
         });

         DatabaseReference dbReference = FirebaseDatabase.instance.reference()
             .child("Customers request");
         String uploadId = dbReference
             .push()
             .key;
         HashMap map = new HashMap();
         map['imageUrl'] = imageLink;
         map['locationFrom'] = locationFrom;
         map['locationTo'] = locationTo;
         map['well description of item'] = wellDescriptionOfItem;
         map['No of item'] = noOfItem;
         map['weight of item'] = weightOfItem;
         map['cost of errand'] = costOfErrand;
         map['phoneNo'] = phoneNo;
         map['repName'] = repName;
         map['repNumber'] = repNumber;

        data = dbReference.child(uploadId).set(map);

       }
     }
     catch (e){
         throw Exception (e.messgae);
     }

  }


  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requesting Errandboy'),
        backgroundColor: Colors.blue[600],
        elevation: 0,
      ),

      body:Form(
        key: formKey,
        child: Container(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                        labelText: ' From:'
                                    ),
                                    validator: (value){
                                      if (value.isEmpty){
                                        return 'Please input location from';
                                      }
                                        locationFrom = value;
                                    },),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                      labelText: ' To:'
                                  ),
                                    validator: (value){
                                      if (value.isEmpty){
                                        return 'Please input location to';
                                      }
                                        locationTo = value;
                                    },),
                              ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),
                        TextFormField(
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(20.0),
                                ),
                              ),
                              labelText: 'Well description of item'
                          ),
                          validator: (value){
                            if (value.isEmpty){
                              return 'input description of item';
                            }
                              wellDescriptionOfItem = value;
                          },),

                        SizedBox(height: 10.0),
                        TextFormField(
                          keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                ),
                              labelText: 'number of item'
                          ),
                          validator: (noi) {
                            if (noi.isEmpty) {
                              return 'Input number of item';
                            }
                             setState(() {
                               noOfItem = double.parse(noi);
                             });
                          }),

                        SizedBox(height: 10.0),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(20.0),
                                ),
                              ),
                            hintText: 'Weight of item in kg'
                        ),
                      onSubmitted: (value){
                        setState(() {
                          weightOfItem = double.parse(value);
                        });
                      },),

                        SizedBox(height: 10.0),
                        TextFormField(
                          keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                ),
                              labelText: 'Phone Number'
                          ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Input phone number';
                              }
                                phoneNo = value;

                            }),

                        SizedBox(height: 10.0),
                        TextFormField(
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                ),
                              labelText: 'Name of recipient'
                          ),
                          validator: (value){
                            if (value.isEmpty){
                              return 'Input recipient name';
                              }
                              repName = value;
                              }),

                        SizedBox(height: 10.0),
                        TextFormField(
                          keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                ),
                              labelText: 'Recipient Phone number'
                          ),
                          validator: (value){
                            if (value.isEmpty){
                              return 'Input recipient phone number';
                            }
                              repNumber= value;
                              }),

                      costOfErrand == null ? Container() : Text('cost of errand:\u20A6'+
                                                      costOfErrand.toString()+''),
                      FlatButton(
                        onPressed: (){
                          if(formKey.currentState.validate()){
                            getCostOfErrandForNoItem(noOfItem);
                          }
                          if (weightOfItem != null) {
                            getCostOfErrandForWeight(weightOfItem);
                          }

                        },
                        color: Colors.yellow[500],
                        child: Text('Done', style: TextStyle(color: Colors.black,
                          fontSize: 15,),),),
                       SizedBox(height: 15,),
                       costOfErrand == null ? Container() : RaisedButton(
                         onPressed: (){upload(); showToast(text, duration:
                         Toast.LENGTH_LONG, gravity: Toast.BOTTOM);},
                         color: Colors.green[500],
                         child: Text('Send',
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: 15,),
                         ),
                       ),
                    ],
                  ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.camera_alt),
                          iconSize: 45.0,
                          onPressed: () {
                            _showDialog(context);
                          },
                        ),
                        _decideImage(),
                      ],
                    ),
                  ]
                ),
              ),
          ),
      )

      );
    
  }

}
