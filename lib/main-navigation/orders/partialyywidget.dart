
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/ordersprovider.dart';
import 'orderdetails/ordedetails.dart';

class PartiallyPaidWidget extends StatefulWidget {
  const PartiallyPaidWidget({super.key});

  @override
  State<PartiallyPaidWidget> createState() => _PartiallyPaidWidgetState();
}

class _PartiallyPaidWidgetState extends State<PartiallyPaidWidget> {

  final _formated= NumberFormat();



  bool positive = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      Provider.of<OrdersProvider>(context,listen: false).getPart();
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: const BoxDecoration(
        image:DecorationImage(
          image: AssetImage('assets/images/ho.jpg'),
          fit: BoxFit.cover,
          opacity: 0.2,
        ),
      ),
      child: Consumer<OrdersProvider>(
        builder: (context,value,child){

          final pros=value.part;

          if(value.isLoad){

            return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Image.asset('assets/images/hug.gif',height: 100,width: 100,)),

                const SizedBox(height: 20,),

                const Text('Loading.....',style: TextStyle(color: Colors.brown,fontWeight: FontWeight.bold,fontSize: 18),)
              ],
            );

          }

          else if(value.isNet){

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

          else{

            return  pros.isEmpty ? Container(
                decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.2),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/Empty_cart.png',),fit: BoxFit.cover
                    )
                ),
                child: const Center(
                  child:Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child:Text('There currently no credit sales',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,) ,
                      ),
                    ],
                  ),
                )
            ):ListView.builder(
                itemCount: pros.length,
                itemBuilder:(context,index){
                  var s_price=int.parse(pros[index].c_am);
                  String sprice=_formated.format(s_price);

                  var s_pricee=int.parse(pros[index].bal);
                  String spricee=_formated.format(s_price);

                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom:3,top: 3),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.brown.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(width: 1.0,style: BorderStyle.solid,strokeAlign: BorderSide.strokeAlignInside,color: Colors.brown)
                      ),
                      child:Column(
                        children: [
                          ListTile(
                            horizontalTitleGap: 0,
                            onTap: (){

                              //route to order details
                              Navigator.push(context, MaterialPageRoute(builder:(context)=> OrderDetails(
                                  trid:pros[index].tr_id
                              )));
                            },
                            leading:InkWell(
                              onTap: (){


                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 14,
                                child: Icon(Icons.space_dashboard_sharp,size: 18,
                                    color: pros[index].sta =='Not paid' ? Colors.red:
                                    pros[index].sta =='paid' ? Colors.amber[200]:Colors.green
                                ),
                              ),
                            ),
                            title: Text(pros[index].sta,style:  TextStyle(fontSize: 12,
                                color: pros[index].sta  =='Not paid' ? Colors.red:
                                pros[index].sta  =='paid' ? Colors.amber[200]:Colors.green
                                ,fontWeight: FontWeight.bold),),
                            subtitle: Text(pros[index].name,maxLines: 2,overflow: TextOverflow.ellipsis,),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Text('Order ID:${pros[index].tr_id}',style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),

                                Text('Date:${pros[index].date}',style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                Text('Amount:Shs${sprice}',style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                              ],
                            ),

                          ),
                          ExpansionTile (
                            title:const Text('More details...',style: TextStyle(color: Colors.black,fontSize: 12),),
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(left:12,right: 12,top: 8,bottom: 8),
                                child: Container(
                                  // elevation: 8,
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text('Payment Date: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                                            Text( pros[index].pay_d,style: const TextStyle(color: Colors.black),)
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            const Text('Balance: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                                            Flexible(child: Text('Shs${spricee}',style: const TextStyle(color: Colors.black),maxLines: 2,))
                                          ],
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),

                        ],
                      ),
                      // child: Column(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //
                      //     ///row 1
                      //     Row(children: [
                      //       const Icon(Icons.space_dashboard_sharp),
                      //     const SizedBox(width:10),
                      //
                      //       const Expanded(
                      //         child: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //
                      //             Text('Processsing',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      //
                      //             Text('27/07/2023')
                      //
                      //           ],
                      //         ),
                      //       ),
                      //
                      //       IconButton(onPressed:(){
                      //
                      //       }, icon:const Icon(Icons.navigate_next,size: 16,))
                      //
                      //     ],),
                      //
                      //     const SizedBox(height: 10,),
                      //     /// row 2
                      //     Row(
                      //       children: [
                      //
                      //         Expanded(
                      //           child: Row(
                      //             children: [
                      //             const Icon(Icons.space_dashboard_sharp),
                      //             const SizedBox(width:10),
                      //
                      //             Expanded(
                      //               child: Column(
                      //                 mainAxisSize: MainAxisSize.min,
                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                      //                 children: [
                      //
                      //                   const Text('Order ID',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      //
                      //                   Text(pros[index].c_am)
                      //
                      //                 ],
                      //               ),
                      //             ),
                      //
                      //
                      //
                      //           ],),
                      //         ),
                      //
                      //         Expanded(
                      //           child: Row(
                      //             children: [
                      //               const Icon(Icons.space_dashboard_sharp),
                      //               const SizedBox(width:10),
                      //
                      //               Expanded(
                      //                 child: Column(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                   children: [
                      //
                      //                     const Text('Amount',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      //
                      //                     Text('Shs ${sprice} ',)
                      //
                      //                   ],
                      //                 ),
                      //               ),
                      //
                      //
                      //
                      //             ],),
                      //         ),
                      //       ],
                      //     ),
                      //
                      //   ],
                      // ),
                    ),
                  );



                }
            );
          }


        },
      ),
    );
  }
}
