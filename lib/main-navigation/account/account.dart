
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login/login.dart';
import '../../models/ordermodel.dart';
import '../../providers/ordersprovider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<OrdersProvider>(context,listen: false);
      //Provider.of<OrdersProvider>(context,listen: false).getDate(date:_selectDate.toString());
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

  DateTime _selectDate= DateTime.now();


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
      body:Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.brown.withOpacity(0.3),
          image:const DecorationImage(
            image: AssetImage('assets/images/ho.jpg'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat.yMMMMd().format(DateTime.now()),style:  TextStyle(color: Colors.grey.shade50),),
                  const Text('Today',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),

                  Container(
                    child:DatePicker(
                      DateTime.now(),
                      height: 100,
                      width: 80,
                      initialSelectedDate: DateTime.now(),
                      selectedTextColor: Colors.brown,
                      selectionColor: Colors.brown.shade100,
                      dateTextStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.grey),
                      monthTextStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.grey),
                      onDateChange: (date){

                        setState(() {
                          _selectDate=date;
                          //value.getDate(date:_selectDate.toString());
                          Provider.of<OrdersProvider>(context,listen: false).getDate(date:_selectDate.toString());
                        });

                      },
                    ),
                  ),



                ],
              ),
            ),
            Expanded(
              child:Consumer<OrdersProvider>(
                builder: (context,value,child){

                  final cats=value.datee;

                  // if(value.isLoad){
                  //
                  //   return Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Center(child: Image.asset('assets/images/hug.gif',height: 100,width: 100,)),
                  //
                  //       const SizedBox(height: 20,),
                  //
                  //       const Text('Loading.....',style: TextStyle(color: Colors.brown,fontWeight: FontWeight.bold,fontSize: 18),)
                  //     ],
                  //   );
                  //
                  // }
                   if(value.isNet){

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: Image.asset('assets/images/lost2.gif',height: 150,width: 150)),

                        const SizedBox(height: 20,),

                        const Text('No internet Connection',style: TextStyle(color: Colors.brown,fontWeight: FontWeight.bold,fontSize: 18),)
                      ],
                    );

                  }


                  return  ListView.separated(
                    itemCount:cats.length,
                    itemBuilder: (BuildContext context, int index) {

                      //String sprice=_formated.format(int.parse(cats[index].c_am));

                      return  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(

                          leading: CircleAvatar(
                            child: Text(cats[index].name),

                          ),
                          title: Text(cats[index].c_am),
                        ),
                      );

                    },
                    separatorBuilder: (BuildContext context, int index) {

                      return  Divider(color: Colors.grey.shade100,height:2);
                    },


                  );

                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
