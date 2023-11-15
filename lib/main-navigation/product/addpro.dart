
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/productprovider.dart';
class addProduct extends StatefulWidget {
  const addProduct({super.key});

  @override
  State<addProduct> createState() => _addProductState();
}

class _addProductState extends State<addProduct> {

  final _nameCont=TextEditingController();
  final _descCont=TextEditingController();
  final _priceCont=TextEditingController();
  final _catCont=TextEditingController();



  final _formKey=GlobalKey<FormState>();

  final List<String> _collections=[
    'Iron Sheets',
    'Nails',
    'Wheelbarrows'
  ];

  String? dropDownValue;

  String? name;
  String? desc;
  double? price;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade300,
        title: const Text('Add Product',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
              onPressed:(){},
              icon:const Icon(Icons.logout),
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
      body:ListView(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
        children: [

          Form(
            key: _formKey,
            child: Column(
              children: [
                //name
                TextFormField(
                  controller:_nameCont,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300
                      )
                    )
                  ),
                  validator: (value){
                    if(value!.isEmpty){

                      return 'Enter Product name';
                    }
                    setState(() {
                      name=value;
                    });
                    return null;
                  },
                ),

                //description
                TextFormField(
                  controller:_descCont,
                  decoration: InputDecoration(
                      labelText: 'About the product',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade300
                          )
                      )
                  ),
                  validator: (value){
                    if(value!.isEmpty){

                      return 'Enter Product Description';
                    }
                    setState(() {
                      desc=value;
                    });
                    return null;
                  },
                ),

                //price
                TextFormField(
                  controller:_priceCont,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Price*',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade300
                          )
                      )
                  ),
                  validator: (value){
                    if(value!.isEmpty){

                      return 'Enter Price';
                    }
                    setState(() {
                      price=double.parse(value);
                    });
                    return null;
                  },
                ),

                // Container(
                //   child: Row(
                //     children: [
                //       Text('Product Category',style: TextStyle(color: Colors.grey.shade300),),
                //       const SizedBox(width: 10,),
                //       DropdownButton<String>(
                //         hint: const Text('Select Category'),
                //           value: dropDownValue,
                //           icon: const Icon(Icons.arrow_drop_down),
                //           onChanged:(String? value){
                //           setState(() {
                //             dropDownValue=value;
                //           });
                //           },
                //         items:_collections?.map<DropdownMenuItem<String>>((String value){
                //
                //           return DropdownMenuItem(
                //               value: value,
                //             child: Text(value),
                //           );
                //         }).toList(),
                //       ),
                //
                //     ],
                //   ),
                // ),

                const SizedBox(height: 20,),


                Consumer<ProductProvider>(
                    builder: (context, auth, child) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {

                        //Provider.of<UserProvider>(context,listen: false).registerUser(email:_ema.text, password:_pass.text, firstName:f, lastName: lastName, address: address, phone: phone, country: country);
                      });
                      return Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.brown.shade300),
                          onPressed: (){


                            if(_formKey.currentState!.validate()){

                              //continue if the textfields are not empty
                              if (
                              _nameCont.text !=''||
                                  _descCont.text !='' || _priceCont.text !=''
                              ) {

                                //post edittext data to product save function from the ProductProvider
                                auth.savePro(
                                    context: context, name:_nameCont.text, desc:_descCont.text, price:_priceCont.text);

                                //set text fields to empty after
                                _nameCont.text =='';
                                _descCont.text =='';
                                _priceCont.text=='';

                              }


                            }

                          }, child:const Text('Save Product',style: TextStyle(color: Colors.white),),
                        ),
                      );
                    }),



              ],
            ),
          )

        ],
      ),

    );
  }
}
