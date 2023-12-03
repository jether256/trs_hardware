import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/url/url.dart';
import '../../encryp/enc.dart';
import '../../models/productmodel.dart';
import '../../providers/cartprovider.dart';
import '../../providers/productprovider.dart';
import '../product/editPro.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {

  final _formKey=GlobalKey<FormState>();
  final _qt=TextEditingController();

  final _formated= NumberFormat();


  final _sear=TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    getPro();

  }

  bool isLoading = false;
  bool isNet = false;

  String? ID,nem,email;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      ID= sharedPreferences.getString("ID");
      nem= sharedPreferences.getString("name");
      email= sharedPreferences.getString("email");
    });
  }



  List<ProductModel> _listHouse = [];

  List<ProductModel> pros = [];


  getPro() async {


    var response = await http.get(
        Uri.parse(BaseUrl.getPro),
        headers: {"Accept": "headers/json"});

    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map product in data) {
          _listHouse.add(ProductModel.fromJson(product));
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
        if (element.name.toLowerCase().contains(text) || element.descc.toLowerCase().contains(text) || element.price.toLowerCase().contains(text) ) {
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
                    const Text('There are no products Your looking for',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ],
                ),
              ),
            ):
            ListView.builder(
              physics:const BouncingScrollPhysics(),
              itemCount:pros.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index){


                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: (){

                      Navigator.push(context, MaterialPageRoute(builder:(context)=> EditProduct(
                          id:pros[index].id,
                          nem:decrypt(pros[index].name),
                          desc:decrypt(pros[index].descc),
                          price:decrypt(pros[index].price)
                      )));
                    },
                    leading: CircleAvatar(
                      child: Text(decrypt(pros[index].name)),

                    ),
                    title: Text(decrypt(pros[index].name)),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(decrypt(pros[index].descc),maxLines:1,overflow:TextOverflow.ellipsis,),
                        Text(decrypt(pros[index].price)),

                      ],
                    ),
                    trailing:Consumer<CartProvider>(
                        builder: (context, auth, child) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {


                          });
                          return IconButton(icon:const Icon(Icons.add),color: Colors.green, onPressed: () {

                            //auth.saveCart(context: context,proid:pros[index].id,price:decrypt(pros[index].price),uid:'$ID');

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

                                            auth.saveCart(context: context,proid:pros[index].id,price:decrypt(pros[index].price),uid:'$ID',qty:_qt.text);


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
            ),
          ),
        ),
      ),
    );
  }
}
