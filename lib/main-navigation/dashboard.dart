
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trs_hardware/main-navigation/product/products.dart';

import '../constants/coloor.dart';
import '../login/login.dart';
import 'account/account.dart';
import 'drawer/nava.dart';
import 'home/home.dart';

class Dashboard extends StatefulWidget {

  static const String id="dashboard";
  
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  bool isLoggedIn=false;

  @override
  void initState() {
    // TODO: implement initState
    getPref();
    _checkLoginStatus();
    super.initState();
  }

  _checkLoginStatus() async {
    SharedPreferences localStorage= await SharedPreferences.getInstance();
    var Id=localStorage.getString('id');

    if(Id != null){

      setState(() {
        isLoggedIn=true;
      });
    }

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


  int _selectedIndex=0;

  static final List<Widget> _widgetOptionsLogged=<Widget>[
    const Home(),
    const Products(),
    const Account(),
    const Account(),
  ];

  void _onItemTapped(int index){

    setState(() {
      _selectedIndex=index;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:const NavDrawer(),
      appBar: AppBar(
        title:const Text('Ts Hardware',style: TextStyle(color: Colors.brown),),
      ),
      body: _widgetOptionsLogged[_selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.brown,
        foregroundColor: conBack2,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 90,
        notchMargin: 5.0,
        shape: const CircularNotchedRectangle(),
        color: Colors.brown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 10,top: 10),
              child: InkWell(
                onTap: (){
                  _onItemTapped(0);
                },
                child: const Column(
                  children: [
                    Icon(Icons.home,color: Colors.white,),
                    Text('Home',style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
            ),


             Padding(
              padding: const EdgeInsets.only(left: 10,top: 10),
              child: InkWell(
                onTap: (){
                  _onItemTapped(1);
                },
                child: const Column(
                  children: [
                    Icon(Icons.shopping_cart,color: Colors.white,),
                    Text('Orders',style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10,top: 10),
              child: InkWell(
                onTap: (){
                  _onItemTapped(2);
                },
                child: const Column(
                  children: [
                    Icon(Icons.home,color: Colors.white,),
                    Text('Home',style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(left: 10,top: 10),
              child: InkWell(
                onTap: (){
                  _onItemTapped(3);
                },
                child: const Column(
                  children: [
                    Icon(Icons.person,color: Colors.white,),
                    Text('Account',style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
