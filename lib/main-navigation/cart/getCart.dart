
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/coloor.dart';
import '../../encryp/enc.dart';
import '../../providers/cartprovider.dart';
import '../creditform/creditform.dart';
import '../dashboard.dart';
import '../drawer/nava.dart';
import 'cartwidget.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {


  final _formated= NumberFormat();

  @override
  void initState() {
    super.initState();
    getPref();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartProvider>(context,listen: false);
      Provider.of<CartProvider>(context,listen: false).getCart();
      Provider.of<CartProvider>(context,listen: false).getTotal();
    });

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


  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
        builder:(context,value,child){


          final pros=value.sumPrice;

          //var s_price=int.parse(pros as String);
          String sprice=_formated.format(pros);

          return Scaffold(
            drawer:const NavDrawer(),
            appBar: AppBar(
              backgroundColor: Colors.brown.shade300,
              title: const Text('Cart'),
              actions:  [

                Consumer<CartProvider>(
                    builder: (context,value,child){

                      final count=value.count;

                      return Padding(
                        padding:const EdgeInsets.only(top: 15,right: 20),
                        child:InkWell(
                          child:Badge(
                            label:count== null ? const Text('0',style: TextStyle(color: Colors.white,fontSize: 10),):Text('$count',style: const TextStyle(color: Colors.white,fontSize: 10),),
                            child:const Icon(Icons.shopping_cart,color: Colors.white) ,
                          ),
                          onTap: (){


                          },
                        ),
                      );
                    }),
              ],
            ),
            body:  Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child:Container(
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.3),
                    image:const DecorationImage(
                      image: AssetImage('assets/images/ho.jpg'),
                      fit: BoxFit.cover,
                      opacity: 0.2,
                    ),
                  ),
                  child: CartWidget()
              ),
            ),

            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: pros== null
                ? const SizedBox()
                : Container(
              padding: const EdgeInsets.all(15),
              height: 106,
              // margin: const EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width,
              decoration:BoxDecoration(
                  color: Colors.green.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [


                  Consumer<CartProvider>(
                      builder: (context,value,child){

                        final total=value.sumPrice;

                        String sprice=_formated.format(total);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            const Text(
                              "Total Payment",
                              style: TextStyle(
                                  fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),
                            ),

                            Text(
                              sprice== null ? " Shs 0":"Shs $sprice",
                              style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),
                            ),


                          ],
                        );

                      }),

                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //color: Colors.green.shade700,
                      //shape: BoxShape.circle,
                      gradient:LinearGradient(
                        colors:[
                          greenGradient.darkShade,
                          greenGradient.lightShade,
                        ],
                      ),
                    ),
                    child:Consumer<CartProvider>(
                      builder:(context,value,child){


                        //check out button
                        return Consumer<CartProvider>(
                          builder: (context,out,child){

                            final total=out.sumPrice;

                            String sprice=_formated.format(total);

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                  colors:[
                                    greenGradient.darkShade,
                                    greenGradient.lightShade,
                                  ],
                                ),
                              ),
                              child:MaterialButton(
                                // color: Colors.green.shade700,
                                child:const Text("Continue",style: TextStyle(color: Colors.white),),
                                onPressed: () {

                                  ///route to shipping details
                                  //Navigator.pushNamed(context, ShippingDetails.id);
                                  //Navigator.pushReplacementNamed(context,ShippingDetails.id);

                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled:true,
                                      builder:(_)=>const CreditForm());
                                },
                              ) ,
                            );
                          },
                        );



                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
