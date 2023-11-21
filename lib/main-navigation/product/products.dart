
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trs_hardware/main-navigation/product/editPro.dart';

import '../../encryp/enc.dart';
import '../../providers/productprovider.dart';
import '../drawer/nava.dart';
import 'addpro.dart';

class Products extends StatefulWidget {
  static const String id="products-screen";
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      Provider.of<ProductProvider>(context,listen: false).getProList();
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:const NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.brown.shade300,
        title: const Text('All Products',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed:(){

              //route to add product
              Navigator.push(context, MaterialPageRoute(builder:(context)=>const addProduct()));
            },
            icon:const Icon(Icons.add),
          )
        ],
        // bottom:PreferredSize(
        //   preferredSize: const Size.fromHeight(50),
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: TextField(
        //       decoration: InputDecoration(
        //         border:OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(4),
        //           borderSide: BorderSide.none
        //         ),
        //         filled: true,
        //         fillColor: Colors.brown.shade50
        //       ),
        //     ),
        //   ),
        // ),
      ),
      body:RefreshIndicator(
        onRefresh: () async{
          context.read<ProductProvider>().getProList();
        },
        child: Container(
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
                          child:Image.asset('assets/images/no_internet.png'),
                        ),
                      );



                    }
                );

              }


              return  ListView.separated(
                itemCount:cats.length,
                itemBuilder: (BuildContext context, int index) {

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
                          Text(decrypt(cats[index].price)),

                        ],
                      ),
                      trailing:Consumer<ProductProvider>(
                          builder: (context, auth, child) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {


                            });
                            return IconButton(icon:const Icon(Icons.delete),color: Colors.red, onPressed: () {

                              auth.delPro(context: context,id:cats[index].id).then((value){
                                context.read<ProductProvider>().getProList();
                              });

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
    );
  }
}

