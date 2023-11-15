
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login/login.dart';
import '../drawer/nava.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {

  @override
  void initState() {
    // TODO: implement initState
    getPref();
    super.initState();
  }

  String? ID,nem,email;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      ID= sharedPreferences.getString("ID");
      nem= sharedPreferences.getString("name");
      email= sharedPreferences.getString("email");
    });
  }

  lougOut() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //String? UID=sharedPreferences.getString("id");
    // FirebaseMessaging.instance.unsubscribeFromTopic("users");
    // FirebaseMessaging.instance.unsubscribeFromTopic("users${UID}");

    sharedPreferences.remove("ID");
    sharedPreferences.remove("name");
    sharedPreferences.remove("email");
    sharedPreferences.remove("type");



    if(mounted){
      Navigator.pushReplacementNamed(context, Login.id);
    }

  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer:const NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.brown.shade300,
        title: const Text('Account'),
        actions:  [

      Padding(
      padding:const EdgeInsets.only(top: 15,right: 20),
      child:InkWell(
        child:const Icon(Icons.logout,color: Colors.white),
        onTap: (){

          lougOut();
        },
      ),
    ),
        ],
      ),
      body:const Center(child: Text('Account')),
    );
  }
}
