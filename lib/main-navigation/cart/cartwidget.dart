
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/coloor.dart';
import '../../encryp/enc.dart';
import '../../providers/cartprovider.dart';
import '../dashboard.dart';


class CartWidget extends StatefulWidget {



  const CartWidget({Key? key, }) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {

  final _formated= NumberFormat();



  bool positive = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      Provider.of<CartProvider>(context,listen: false).getCart();
    });
  }



  @override
  Widget build(BuildContext context) {

    return  RefreshIndicator(
      onRefresh: () async{
        context.read<CartProvider>().getCart();
      },
      child: Container(
        child: Consumer<CartProvider>(
          builder: (context,value,child){

            final pros=value.cart;

            // if(value.isLoad){
            //
            //   return   Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Center(child: Image.asset('assets/images/hug.gif',height: 100,width: 100,)),
            //
            //           const SizedBox(height: 20,),
            //
            //           const Text('Loading.....',style: TextStyle(color: Colors.brown,fontWeight: FontWeight.bold,fontSize: 18),)
            //         ],
            //       );
            //
            // }

              if(value.isNet){

              return Container(
                  decoration:const BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: AssetImage('assets/images/no_internet.png',),fit: BoxFit.cover
                      )

                  ),
                  child: const Center(
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child:Text('No internet Connection',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,) ,
                        ),

                        SizedBox(height: 20,),
                      ],
                    ),
                  )
              );
            }

            else{

              return pros.isEmpty ?  Container(
                  decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.2),
                      image: const DecorationImage(
                          image: AssetImage('assets/images/Empty_cart.png',),fit: BoxFit.cover
                      )

                  ),
                  child: Center(
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child:Text('Cart is empty! Please continue shopping!!!!',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,) ,
                        ),

                        const SizedBox(height: 20,),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              colors:[
                                greenGradient.darkShade,
                                greenGradient.lightShade,
                              ],
                            ),
                          ),
                          child: MaterialButton(
                            //color: Colors.green.shade700,
                            child:const Text("Shop",style: TextStyle(color: Colors.white),),
                            onPressed: () {


                              Navigator.pushNamed(context,Dashboard.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
              ): ListView.builder(
                  itemCount: pros.length,
                  itemBuilder:(context,index){
                    var s_price=int.parse(pros[index].price);
                    String sprice=_formated.format(s_price);

                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                      child: Container(
                        height:140,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(5),
                        margin:const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4)
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width-183,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text(decrypt(pros[index].name),style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                                      Row(
                                        children: [


                                          Consumer<CartProvider>(
                                              builder: (context, shop, child) {
                                                WidgetsBinding.instance!.addPostFrameCallback((_) {

                                                  //Provider.of<UserProvider>(context,listen: false).registerUser(email:_ema.text, password:_pass.text, firstName:f, lastName: lastName, address: address, phone: phone, country: country);
                                                });
                                                return IconButton(
                                                    icon: const Icon(
                                                      Icons.add_circle,
                                                      color:Colors.green,
                                                    ),
                                                    onPressed: () {
                                                      shop.updateQuanity(catid:pros[index].id, quant: 'adding',context: context);
                                                    });
                                              }),




                                          Text(pros[index].quantity,style: const TextStyle(color:Colors.black ),),



                                          Consumer<CartProvider>(
                                              builder: (context, shop, child) {
                                                WidgetsBinding.instance!.addPostFrameCallback((_) {

                                                  //Provider.of<UserProvider>(context,listen: false).registerUser(email:_ema.text, password:_pass.text, firstName:f, lastName: lastName, address: address, phone: phone, country: country);
                                                });
                                                return IconButton(
                                                    icon: const Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      shop.updateQuanity( catid:pros[index].id, quant: 'sub',context:context);
                                                    });
                                              }),



                                        ],
                                      ),
                                      // Text(
                                      //   "IDR " + price.format(int.parse(x.price)),
                                      //   style: boldTextStyle.copyWith(fontSize: 16),
                                      // ),
                                      Text('Price:${sprice} Shs',style:const TextStyle(color:Colors.black,fontSize: 15),)
                                    ],
                                  ),
                                ),

                                Consumer<CartProvider>(
                                    builder: (context, shop, child) {
                                      WidgetsBinding.instance!.addPostFrameCallback((_) {

                                        //Provider.of<UserProvider>(context,listen: false).registerUser(email:_ema.text, password:_pass.text, firstName:f, lastName: lastName, address: address, phone: phone, country: country);
                                      });
                                      return IconButton(onPressed: (){

                                        shop.deleteCartItem(catid:pros[index].id, context:context);

                                      }, icon:const Icon(Icons.delete,color: Colors.red,));
                                    }),


                              ],
                            ),
                          ],
                        ),
                      ),
                    );



                  }
              );
            }


          },
        ),
      ),
    );
  }
}


// auth.alertDialog(
// context:context,
// title:'Product',
// content:'Product image not selected',
// ),