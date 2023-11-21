
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/url/url.dart';
import '../models/ordermodel.dart';
import 'orders/editorder.dart';
import 'orders/orderdetails/ordedetails.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {


  final _formated= NumberFormat();


  final _sear=TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrder();

  }

  bool isLoading = false;
  bool isNet = false;




  List<OrderModel> _listHouse = [];

  List<OrderModel> pros = [];


  getOrder() async {


    SharedPreferences pref= await SharedPreferences.getInstance();
    String? ID=pref.getString('ID');

    var response = await http.post(
        Uri.parse(BaseUrl.getOrders),
        headers: {"Accept": "headers/json"},
        body:{'id':ID!}
    );
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map product in data) {
          _listHouse.add(OrderModel.fromJson(product));
        }
      });
    }





  }



  searchHouse(String text) {
    pros.clear();
    if (text.isEmpty) {
      setState(() {});
    } else {
      _listHouse.forEach((element) {
        if (element.pay_d.toLowerCase().contains(text) || element.c_am.toLowerCase().contains(text) || element.tr_id.toLowerCase().contains(text) || element.bal.toLowerCase().contains(text) || element.name.toLowerCase().contains(text) ) {
          pros.add(element);
        }
      });
      setState(() {});
    }
  }





  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:Colors.grey[100],
        appBar:AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.brown.shade300,
          bottom:  PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child:Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Column(
                children: [
                  Row(
                      children: [

                        Expanded(
                          child:Container(
                            child:TextField(
                              onChanged:searchHouse,
                              controller:_sear,
                              decoration: InputDecoration(
                                hintText: 'Search a Order',
                                prefixIcon: const Icon(Icons.search,color:Colors.grey ,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor:Colors.grey.shade200,
                              ),

                            ),

                          ),
                        ),
                      ]
                  ),

                  const SizedBox(height: 20,),
                ],
              ),

            ),
          ) ,

        ),
        body:Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image:DecorationImage(
              image: AssetImage('assets/images/ho.jpg'),
              fit: BoxFit.cover,
              opacity: 0.2,
            ),
          ),
          child:Padding(
            padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0),
            child:
            _sear.text.isEmpty || pros.length == 0 ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/hammer.png',height: 100,width: 100,),
                    const Text('There are no Orders Your looking for',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ],
                ),
              ),
            ):
            ListView.builder(
              physics:const BouncingScrollPhysics(),
              itemCount:pros.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index){



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


                              // showModalBottomSheet(
                              //     context: context,
                              //     isScrollControlled:true,
                              //     builder:(_)=> EditOrder(trid:pros[index].tr_id,tot:pros[index].c_am));


                              // showCupertinoDialog(context: context, builder:(BuildContext context){
                              //
                              //   return CupertinoAlertDialog(
                              //     insetAnimationDuration: const Duration(milliseconds: 100),
                              //     title:const Text('Are you sure'),
                              //     content: const Text('update status'),
                              //     actions:  [
                              //       CupertinoDialogAction(child:const Text('ok'),onPressed: (){
                              //
                              //         Navigator.pop(context);
                              //
                              //       },)
                              //     ],
                              //   );
                              // });

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
                          title:InkWell(
                              onTap: (){

                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled:true,
                                    builder:(_)=> EditOrder(trid:pros[index].tr_id,tot:pros[index].c_am));

                              },
                              child: const Text('Edit',style: TextStyle(color: Colors.black,fontSize: 18),)
                          ),
                          subtitle:const Text('More details',style: TextStyle(color: Colors.black,fontSize: 12),) ,
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

              },
            ),
          ),
        ),
      ),
    );
  }
}
