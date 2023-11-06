
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trs_hardware/constants/coloor.dart';
import 'package:trs_hardware/login/login.dart';

import 'login/regsiter.dart';
import 'main-navigation/dashboard.dart';


class SplashScreen extends StatefulWidget {

  static const String id="splash-screen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState

    Timer(const Duration(seconds: 3),(){

      getPref1();
      //route to login page
      //Navigator.pushReplacementNamed(context,Login.id);
      //Navigator.pushReplacementNamed(context,Register.id);

    });
    super.initState();
  }


  String? ID1;
  //String? Type;

  getPref1() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    setState(() {
      ID1=sharedPreferences.getString("ID");
      ID1== null ? sessionLogout():sessionLogin();

    });
  }


  sessionLogout() {
    Navigator.pushReplacementNamed(context,Login.id);
  }

  sessionLogin() {

    Navigator.pushReplacementNamed(context,Dashboard.id);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          color: Colors.brown.withOpacity(0.2),
          image:const DecorationImage(
            image: AssetImage('assets/images/ho.jpg'),
            fit: BoxFit.cover,
            opacity: 0.4,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.center,
                child: Icon(Icons.hardware,size: 80,color:Colors.brown,)
            ),

            SizedBox(height: 10,),

            Text('Trs Hardware',style: TextStyle(fontSize: 40,color: Colors.brown),)


          ],
        ),
      ),
    );
  }
}
