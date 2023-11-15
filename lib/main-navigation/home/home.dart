
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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


  final _formated= NumberFormat();


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

                return GridView.builder(
                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:2,
                      childAspectRatio: 1/1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder:(context,index){

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color:Colors.brown.shade100,
                              borderRadius: BorderRadius.circular(4)
                          ),
                          child:Image.asset('assets/images/hug.gif'),
                        ),
                      );



                    }
                );

              }else if(value.isNet){

                return GridView.builder(
                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:2,
                      childAspectRatio: 1/1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder:(context,index){

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color:Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4)
                          ),
                          child:Image.asset('assets/images/lost2.gif'),
                        ),
                      );



                    }
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

                              auth.saveCart(context: context,proid:cats[index].id,price:decrypt(cats[index].price),uid:'$ID');

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
