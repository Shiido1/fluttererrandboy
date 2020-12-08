import 'package:flutter/material.dart';
import 'package:flutter_app/customers_request_screen.dart';
import 'package:flutter_app/errand_boy_registration_screen.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/germany.png'),
                radius: 95,
              ),
              // SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('Request:',style: TextStyle(color: Colors.white,)),
                      RaisedButton(
                        onPressed: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => CustomersRequestScreen()),
                          );
                        } , //CustomersRequestScreen()
                        color: Colors.yellow[800],
                        child: Text('Errandboy', style: TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold),),
                      )
                    ],
                  ),
                  SizedBox(width: 50,),
                  Column(
                    children: [
                      Text('Register as:',style: TextStyle(color: Colors.white,)),
                      RaisedButton(
                        onPressed: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ErrandBoyRegistrationScreen()),
                          );
                        } , //ErrandBoyRegistrationScreen()
                        color: Colors.yellow[800],
                        child: Text('Errandboy', style: TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold),),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
}
