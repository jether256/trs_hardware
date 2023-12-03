import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trs_hardware/main-navigation/home/searchhome.dart';

import '../../encryp/enc.dart';
import '../../providers/cartprovider.dart';
import '../../providers/productprovider.dart';
import '../cart/getCart.dart';
import '../creditform/creditform.dart';
import '../drawer/nava.dart';
import '../product/editPro.dart';

class Home extends StatefulWidget {


  static const String id="home";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey=GlobalKey<FormState>();

  final _formated= NumberFormat();

  final _qt=TextEditingController();

  @override
  void initState() {
    super.initState();
    getPref();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartProvider>(context,listen: false);
      Provider.of<CartProvider>(context,listen: false).getCartCount();
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
    context.read<ProductProvider>().getProList();
    return Scaffold(
        drawer:const NavDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.brown.shade300,
          title:const Text('Home',style: TextStyle(color: Colors.white),),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14.0),
              child: InkWell(
                child:const Icon(Icons.search,color: Colors.white),
                onTap: (){

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SearchProduct()));
                },
              ),
            ),
          ],
        ),
      body:RefreshIndicator(
        onRefresh: () async{
          context.read<ProductProvider>().getProList();
        },
        child:Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.brown.withOpacity(0.3),
            image:const DecorationImage(
              image: AssetImage('assets/images/ho.jpg'),
              fit: BoxFit.cover,
              opacity: 0.2,
            ),
          ),
          child:Consumer<ProductProvider>(
            builder: (context,value,child){

              final cats=value.pro;

              if(value.isLoad){

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Image.asset('assets/images/hug.gif',height: 100,width: 100,)),

                    const SizedBox(height: 20,),

                    const Text('Loading.....',style: TextStyle(color: Colors.brown,fontWeight: FontWeight.bold,fontSize: 18),)
                  ],
                );

              }else if(value.isNet){

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Image.asset('assets/images/no_internet.png',height: 150,width: 150)),

                    const SizedBox(height: 20,),

                    const Text('No internet Connection',style: TextStyle(color: Colors.brown,fontWeight: FontWeight.bold,fontSize: 18),)
                  ],
                );

              }


              return  ListView.separated(
                itemCount:cats.length,
                itemBuilder: (BuildContext context, int index) {

                  String sprice=_formated.format(int.parse(decrypt(cats[index].price)));

                  return  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder:(context)=> EditProduct(
                            id:cats[index].id,
                            nem:decrypt(cats[index].name),
                            desc:decrypt(cats[index].descc),
                            price:decrypt(cats[index].price)
                        )));
                      },
                      leading: CircleAvatar(
                        child: Text(decrypt(cats[index].name)),

                      ),
                      title: Text(decrypt(cats[index].name)),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(decrypt(cats[index].descc),maxLines:1,overflow:TextOverflow.ellipsis,),
                          //Text("Shs $sprice"),
                          Text("Shs $sprice"),

                        ],
                      ),
                      trailing:Consumer<CartProvider>(
                          builder: (context, auth, child) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {


                            });
                            return IconButton(icon:const Icon(Icons.add),color: Colors.green, onPressed: () {

                              // auth.saveCart(context: context,proid:cats[index].id,price:decrypt(cats[index].price),uid:'$ID');


                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text('Enter Quantity',style:TextStyle(color:Colors.black),),
                                      actions: [


                                        Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            controller: _qt,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: 'Quantity',
                                              labelStyle:TextStyle(color:Colors.black),
                                            ),
                                              validator: (value){
                                                if(value!.isEmpty){
                                                  return 'Enter quantity';

                                                }
                                                return null;
                                              }
                                          ),
                                        ),

                                        MaterialButton(
                                          color: Colors.red,
                                          textColor: Colors.white,
                                          onPressed: () {

                                       if(_formKey.currentState!.validate()){


                                         if(_qt.text != null){

                                           auth.saveCart(context: context,proid:cats[index].id,price:decrypt(cats[index].price),uid:'$ID',qty:_qt.text);


                                         }

                                       }




                                          },
                                          child: const Text('Confirm'),
                                        ),


                                      ],
                                    );
                                  },
                                );






                            },);
                          }),
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
      ),
      floatingActionButton:Consumer<CartProvider>(
        builder: (context,value,child){

          final count=value.count;

          return  FloatingActionButton(
            backgroundColor: Colors.brown.shade300,
            child: Badge(
              label: Text('$count' == null ? '0':'$count',style: const TextStyle(color: Colors.white,fontSize: 10),),
              child: const Icon(Icons.shopping_cart,color: Colors.brown) ,
            ),
            onPressed: () {

              Navigator.push(context,MaterialPageRoute(builder: (context)=>const Cart()));
            },
          );
        },
      )
    );
  }

}
