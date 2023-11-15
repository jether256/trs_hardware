
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trs_hardware/main-navigation/product/products.dart';

import '../constants/coloor.dart';
import '../login/login.dart';
import '../providers/cartprovider.dart';
import 'account/account.dart';
import 'cart/getCart.dart';
import 'drawer/nava.dart';
import 'home/home.dart';
import 'orders/orders.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartProvider>(context,listen: false).getCartCount();
    });
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
    const Cart(),
    const Orders(),
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
      // drawer:const NavDrawer(),
      // appBar: AppBar(
      //   backgroundColor: Colors.brown.shade300,
      //   title:const Text('Ts Hardware',style: TextStyle(color: Colors.white),),
      // ),
      body: _widgetOptionsLogged[_selectedIndex],
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   backgroundColor: Colors.brown,
      //   foregroundColor: conBack2,
      //   child: const Icon(Icons.add),
      // ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        notchMargin: 5.0,
        shape: const CircularNotchedRectangle(),
        color: Colors.brown.shade300,
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            IconButton(

              onPressed: () {

                _onItemTapped(0);
              },
              icon:Icon(_selectedIndex== 0 ? Icons.home:Icons.home_outlined,color:_selectedIndex== 0 ? Colors.brown.shade50:Colors.brown,size: _selectedIndex == 0 ? 30:23),

            ),



            IconButton(
              onPressed: () {

                _onItemTapped(1);
              },
              icon:Consumer<CartProvider>(
                  builder: (context,value,child){

                    final count=value.count;

                    return Badge(
                      label: Text('$count' == null ? '0':'$count',style: const TextStyle(color: Colors.white,fontSize: 10),),
                      child:Icon(_selectedIndex== 1 ?Icons.shopping_cart:Icons.shopping_cart_outlined,color:_selectedIndex== 1 ? Colors.brown.shade50:Colors.brown,size: _selectedIndex == 1 ? 30:23) ,
                    );
                  }),
            ),

            IconButton(
                onPressed: () {

                  _onItemTapped(2);
                },
                icon:Icon(_selectedIndex== 2 ? Icons.dashboard:Icons.dashboard_outlined,color:_selectedIndex== 2 ? Colors.brown.shade50:Colors.brown,size: _selectedIndex == 2 ? 30:23)
            ),




            IconButton(
                onPressed: () {

                  _onItemTapped(3);
                },
                icon:Icon(_selectedIndex== 3 ? CupertinoIcons.person:Icons.person,color:_selectedIndex== 3 ? Colors.brown.shade50:Colors.brown,size: _selectedIndex == 3 ? 30:23)
            ),

          ],
        ),
      ),
    );
  }
}


