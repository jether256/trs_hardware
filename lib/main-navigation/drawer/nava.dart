
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/coloor.dart';
import '../../login/login.dart';
import '../account/account.dart';
import '../dashboard.dart';
import '../product/addpro.dart';
import '../product/products.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {

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
    return Drawer(
      backgroundColor: conBack2,
      child: ListView(
        padding: EdgeInsets.zero,

        children: [
          UserAccountsDrawerHeader(
              accountName:Text('${nem}'),
              accountEmail:Text('${email}'),
            currentAccountPicture: const CircleAvatar(
              child: ClipOval(
                child:Icon(Icons.person),
              ),
            ),
            decoration:  BoxDecoration(
              color: Colors.brown.withOpacity(0.2),
              image:const DecorationImage(
                image: AssetImage('assets/images/ho.jpg'),
                fit: BoxFit.cover,
                opacity: 0.4,
              ),
            ),
          ),

          ListTile(

            leading: const Icon(Icons.dashboard_outlined,color: Colors.brown,),
            title:const Text('Dashboard',style: TextStyle(color: Colors.white),),
            onTap: (){

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  const Dashboard(),
                  )
              );
            },
          ),

          //products
          ExpansionTile(
            backgroundColor: Colors.brown.shade100,
            leading:Image.asset('assets/images/hammer.png',width: 30,),
            title:const Text('Products',style: TextStyle(color: Colors.white),),
            children: [

              ListTile(
                title: const Center(child: Text('All Products',style: TextStyle(color: Colors.white),)),
                onTap: (){

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  const Products() ,
                      )
                  );

                },
              ),

              ListTile(
                title: const Center(child: Text('Add Product',style: TextStyle(color: Colors.white),)),
                onTap: (){

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  const addProduct() ,
                      )
                  );
                },
              ),

            ],
          ),

          //transactions
          ExpansionTile(
            backgroundColor: Colors.brown.shade100,
            leading:Image.asset('assets/images/salary.png',width: 30,),
            title:const Text('Transactions',style: TextStyle(color: Colors.white),),
            children: [

              ListTile(
                title: const Center(child: Text('All Transactions',style: TextStyle(color: Colors.white),)),
                onTap: (){

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  const Products() ,
                      )
                  );

                },
              ),

              ListTile(
                title: const Center(child: Text('Product on Credit',style: TextStyle(color: Colors.white),)),
                onTap: (){

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  const addProduct() ,
                      )
                  );
                },
              ),

            ],
          ),

          //account
          ListTile(

            leading: const Icon(Icons.person,color: Colors.brown,),
            title:const Text('Account',style: TextStyle(color: Colors.white),),
            onTap: (){

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  const Account(),
                  )
              );
            },
          ),

          ListTile(

            leading: const Icon(Icons.notifications,color: Colors.brown,),
            title:const Text('Notifications',style: TextStyle(color: Colors.white),),
            onTap: (){

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  const Account(),
                  )
              );
            },
          ),

          ListTile(

            leading: const Icon(Icons.notifications,color: Colors.brown,),
            title:const Text('Log Out',style: TextStyle(color: Colors.white),),
            onTap: (){

              lougOut();
            },
          ),
        ],
      ),
    );
  }
}
