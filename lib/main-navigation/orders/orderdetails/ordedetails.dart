
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../encryp/enc.dart';
import '../../../models/orderdetailsmodel.dart';
import '../../../providers/ordersprovider.dart';

class OrderDetails extends StatefulWidget {
  final String trid;
  const OrderDetails({super.key, required this.trid});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  final _formated= NumberFormat();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      Provider.of<OrdersProvider>(context,listen: false).getDetails(widget.trid);

    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     // drawer:const NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.brown.shade300,
        title: Text(widget.trid,style: const TextStyle(color: Colors.white),),
      ),
      body:Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image:DecorationImage(
            image: AssetImage('assets/images/ho.jpg'),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: Consumer<OrdersProvider>(
          builder: (context,value,child){

            final pros=value.details;

            // if(value.isLoad){
            //
            //   return  Column(
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

            else{

              return ListView.builder(
                  itemCount: pros.length,
                  itemBuilder:(context,index){
                    var s_price=int.parse(pros[index].price);
                    String sprice=_formated.format(s_price);


                    var t_price=int.parse(pros[index].price) * int.parse(pros[index].quantity);
                    String tprice=_formated.format(int.parse(pros[index].price) * int.parse(pros[index].quantity));


                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 2),
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

                              title: Text(decrypt(pros[index].name),style:  const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              subtitle: Text('Qty: ${pros[index].quantity}',maxLines: 2,overflow: TextOverflow.ellipsis,),
                              trailing:Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Price Shs: $sprice',style: const TextStyle(fontSize: 12),),
                                  Text('Total Shs: ${_formated.format(int.parse(pros[index].price) * int.parse(pros[index].quantity))}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12),),
                                ],
                              ),
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
