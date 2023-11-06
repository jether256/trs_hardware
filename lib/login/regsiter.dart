
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/url/url.dart';
import '../encryp/enc.dart';

class Register extends StatefulWidget {

  static const String id="reg-page";

  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey=GlobalKey<FormState>();

  final _name=TextEditingController();
  final _ema=TextEditingController();
  final _pass=TextEditingController();

  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }



  register() async {
    // controllers should not be empty to avoid send null values to the database
    if(
    _name.text!='' &&
        _ema.text!=''&& _pass.text!=''){

      var response = await http.post(
          Uri.parse("https://holomboko.000webhostapp.com/api/login/register.php"
          ),

          //headers can be left out since CORS doesn't affect apps but it will affect A flutter web app,
          //so just to be safe include them.
          headers: {"Accept": "headers/json"},
          body: {
            "name": encrypt(_name.text),
            "mail": encrypt(_ema.text),
            "pass": encrypt(_pass.text),
            "type": encrypt('admin'),
            //"type": encryp("employee"),
          });


      if (response.statusCode == 200) {

        // decode json data passed in the http body

        // var userData = jsonDecode(response.body);
        var userData = json.decode(
            response.body);

        if (userData == "ERROR") {

          //choose another email.This one already exists
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Email already exists"),
                backgroundColor: Colors.red.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );


        }else {

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Succesfully registered"),
                backgroundColor: Colors.green.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );


          print(userData);
        }
      }

    }


  }




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration:  BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              image:const DecorationImage(
                image: AssetImage('assets/images/ho.jpg'),
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [


                    //logo,tile and subtitle
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.hardware,size: 70,color: Colors.brown,)
                        ),

                        SizedBox(height: 10,),
                        Text('Welcome to TRS Hardware',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.brown),),
                        Text('Register',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),)
                      ],
                    ),



                    const SizedBox(height: 20,),

                    //first name
                    TextFormField(
                        controller: _name,
                        cursorColor: Colors.brown.shade200,
                        decoration: InputDecoration(
                            hintText: 'Name',
                            prefixIcon:const Icon(Icons.person,size: 18,color:Colors.grey,),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(color: Colors.brown),
                            )
                        ),

                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter your Name';

                          }
                          return null;
                        }

                    ),


                    const SizedBox(height: 10,),
                    //email
                    TextFormField(
                        controller: _ema,
                        cursorColor: Colors.brown.shade200,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: const Icon(Icons.email,size: 18,color:Colors.grey,),
                            filled: true,
                            fillColor:Colors.grey.shade200,
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(color: Colors.brown),
                            )
                        ),
                        validator: (value){
                          if(value!.isEmpty){

                            return 'Enter Email';
                          }
                          bool _isValid= (EmailValidator.validate(value));
                          if(_isValid==false){
                            return 'Enter Valid Email Address';

                          }
                          return null;

                        }
                    ),

                    const SizedBox(height: 10,),

                    //password
                    TextFormField(
                        controller: _pass,
                        cursorColor: Colors.brown.shade200,
                        obscureText: _secureText,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon:const Icon(Icons.lock,size: 18,color: Colors.grey,),
                            suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: _secureText
                                  ? const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                                size: 20,
                              )
                                  : const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            filled: true,
                            fillColor:Colors.grey.shade200,
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(color: Colors.brown),
                            )
                        ),

                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter your Password';

                          }
                          return null;
                        }

                    ),

                    const SizedBox(height: 20,),

                    MaterialButton(
                      color: Colors.brown,
                      onPressed:(){


                        if(_formKey.currentState!.validate()){

                          ///login
                          register();

                        }

                      },
                      child:const Text('Register',style: TextStyle(color: Colors.white),),)

                  ],
                ),
              ),
            ),
          ),
        ),
      ) ,
    );
  }
}
