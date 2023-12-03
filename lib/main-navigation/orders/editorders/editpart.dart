
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/ordersprovider.dart';

class EditOrderPart extends StatefulWidget {
  final String trid;
  final String tot;
  final String bal;
  const EditOrderPart({super.key,required this.trid, required this.tot, required this.bal});

  @override
  State<EditOrderPart> createState() => _EditOrderPartState();
}

class _EditOrderPartState extends State<EditOrderPart> {

  final _formKey=GlobalKey<FormState>();

  final _am=TextEditingController();
  //final _dateee=TextEditingController();
  final _priceCont=TextEditingController();
  final _catCont=TextEditingController();

  DateTime? _date;

  //
  _pickDate() async{
    DateTime? pickDate= await showDatePicker(
        context: context,
        initialDate:DateTime.now(),
        firstDate:DateTime(2023),
        lastDate:DateTime(2101));

    if(pickDate != null){

      String formattedDate = DateFormat('yyyy-MM-dd').format(pickDate);


      setState(() {
        _date=DateTime.tryParse(formattedDate);
      });
    }
  }

  //int? selectedOption;

  String? paid='full';
  String? part='part';

  @override
  Widget build(BuildContext context) {





    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding:  const EdgeInsets.all(20),
      decoration:  BoxDecoration(
        color: Colors.brown.withOpacity(0.7),
        // borderRadius:const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _am,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Enter payment'
                ),

              ),

              const SizedBox(height: 20.0,),
              //
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: <Widget>[
              //     RadioListTile<int>(
              //       title: const Text('part'),
              //       value: 1,
              //       groupValue: selectedOption,
              //       activeColor: Colors.teal, // Change the active radio button color here
              //       fillColor: MaterialStateProperty.all(Colors.teal), // Change the fill color when selected
              //       onChanged: (int? value) {
              //         setState(() {
              //           selectedOption = value;
              //           // print("Selected Option: $selectedOption");
              //         });
              //       },
              //     ),
              //     RadioListTile<int>(
              //       title: const Text('full'),
              //       value: 2,
              //       groupValue: selectedOption,
              //       activeColor: Colors.blue, // Change the active radio button color here
              //       fillColor: MaterialStateProperty.all(Colors.blue), // Change the fill color when selected
              //       onChanged: (int? value) {
              //         setState(() {
              //           selectedOption = value;
              //           // print("Selected Option: $selectedOption");
              //         });
              //       },
              //     ),
              //
              //   ],
              // ),

              Consumer<OrdersProvider>(
                  builder: (context, auth, child) {

                    return   ElevatedButton.icon(onPressed:(){

                      // full payment
                      if(_am.text != null  && int.parse(_am.text) == int.parse(widget.bal)){

                        var bal1= (int.parse(widget.bal)-int.parse(_am.text));

                        auth.editO(
                          context: context,
                          trid:widget.trid,
                          bal:bal1.toString(),
                        ).then((value){

                          Navigator.pop(context);

                        });

                      }

                      //part payment
                       else if(_am.text != null  && int.parse(_am.text) < int.parse(widget.bal)){


                          var balo= (int.parse(widget.bal) - int.parse(_am.text));

                        // print(balo);
                        // print(_am.text);
                        // print('This is partial payment');
                        //
                        auth.editP2(
                          context: context,
                          trid:widget.trid,
                          bal:balo.toString(),
                        ).then((value){
                          Navigator.pop(context);
                        });

                        //var net =int.parse(widget.tot)- int.parse(_am.text);


                      }


                      else{

                        //print('This is more than expected');

                        Navigator.pop(context);
                      }


                    }, icon:const Icon(Icons.save),
                        label:const Text('Edit')
                    );
                  }),

            ],
          ),
        ),
      ),
    );
  }
}
