
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/cartprovider.dart';

class CreditForm extends StatefulWidget {
  const CreditForm({super.key});

  @override
  State<CreditForm> createState() => _CreditFormState();
}

class _CreditFormState extends State<CreditForm> {


  final _name=TextEditingController();
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



  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [

            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Name of Business/Owner'
              ),
            ),

            const SizedBox(height: 20.0,),

           Row(
            children: [
              Expanded(
                  child:Text(_date != null ? _date.toString():'Select Date'),
              ),
              IconButton(icon:const Icon(Icons.calendar_month), onPressed: ()=>_pickDate(),),
            ],
          ),

            Consumer<CartProvider>(
                builder: (context, auth, child) {
                  // WidgetsBinding.instance!.addPostFrameCallback((_) {
                  //
                  //   //Provider.of<UserProvider>(context,listen: false).registerUser(email:_ema.text, password:_pass.text, firstName:f, lastName: lastName, address: address, phone: phone, country: country);
                  // });
                  return   ElevatedButton.icon(onPressed:(){


                    if(_name.text != null && _date != null){


                      auth.confirmm(
                          context: context,
                          name:_name.text,
                          date:_date.toString(),
                      );

                    }else{

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Please enter name and date"),
                            backgroundColor: Colors.red.withOpacity(0.9),
                            elevation: 10, //shadow
                          )
                      );

                    }


                  }, icon:const Icon(Icons.add),
                      label:const Text('Confirm')
                  );
                }),




          ],
        ),
      ),
    );
  }
}


