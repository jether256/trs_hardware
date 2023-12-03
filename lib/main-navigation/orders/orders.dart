
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trs_hardware/main-navigation/orders/partialyywidget.dart';

import '../../login/login.dart';
import '../../providers/ordersprovider.dart';
import '../cart/cartwidget.dart';
import '../drawer/nava.dart';
import '../search.dart';
import 'creditwidget.dart';
import 'fullypaidwidget.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  @override
  void initState() {
    // TODO: implement initState
    getPref();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<OrdersProvider>(context,listen: false).getallCreditCount();
    });
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
    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer:const NavDrawer(),
        appBar:AppBar(
          backgroundColor: Colors.brown.shade300,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14.0),
              child: InkWell(
                child:const Icon(Icons.search,color: Colors.white),
                onTap: (){

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Search()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14.0),
              child: InkWell(
                child:const Icon(Icons.logout,color: Colors.white),
                onTap: (){

                  lougOut();
                },
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.brown,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(
                icon: Consumer<OrdersProvider>(
                  builder: (context,value,child) {
                    final count = value.countAll;

                    // if(value.isLoad){
                    //
                    //   return const Badge(
                    //         label: Text('0', style: TextStyle(color: Colors.white,
                    //             fontSize: 10),),
                    //         child: Icon(Icons.credit_card, color: Colors.white),
                    //       );
                    // }
                    return  Badge(
                      label:count== null ?  const Text('0', style: TextStyle(color: Colors.white,
                          fontSize: 10),):Text('$count',style: const TextStyle(color: Colors.white,fontSize: 10),),
                      child: const Icon(Icons.credit_card, color: Colors.white),
                    );

                  }),
                text: "Credit Sales",

              ),
               Tab(
                icon: Consumer<OrdersProvider>(
                    builder: (context,value,child) {
                      final count = value.countPart;

                      // if(value.isLoad){
                      //
                      //   return const Badge(
                      //         label: Text('0', style: TextStyle(color: Colors.white,
                      //             fontSize: 10),),
                      //         child: Icon(Icons.credit_card, color: Colors.white),
                      //       );
                      // }
                      return  Badge(
                        label:count== null ?  const Text('0', style: TextStyle(color: Colors.white,
                            fontSize: 10),):Text('$count',style: const TextStyle(color: Colors.white,fontSize: 10),),
                        child: const Icon(Icons.shopping_bag, color: Colors.white),
                      );

                    }),
                text: "Partially Paid ",
              ),
              Tab(
                icon: Consumer<OrdersProvider>(
                    builder: (context,value,child) {
                      final count = value.countFull;

                      // if(value.isLoad){
                      //
                      //   return const Badge(
                      //         label: Text('0', style: TextStyle(color: Colors.white,
                      //             fontSize: 10),),
                      //         child: Icon(Icons.credit_card, color: Colors.white),
                      //       );
                      // }
                      return  Badge(
                        label:count== null ?  const Text('0', style: TextStyle(color: Colors.white,
                            fontSize: 10),):Text('$count',style: const TextStyle(color: Colors.white,fontSize: 10),),
                        child: const Icon(Icons.paid_outlined, color: Colors.white),
                      );

                    }),
                text: "Fully Paid ",
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CreditWidget(),
             PartiallyPaidWidget(),
            FullPaidWidget(),
          ],
        ),
      ),
    );
  }

  }

