
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../encryp/enc.dart';
import '../main-navigation/dashboard.dart';

class Login extends StatefulWidget {

  static const String id="login-page";

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey=GlobalKey<FormState>();

  final _ema=TextEditingController();
  final _pass=TextEditingController();

  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }


  login() async {

    var response=await http.post(Uri.parse('https://holomboko.000webhostapp.com/api/login/login.php'),

        body:{"mail":encrypt(_ema.text),"pass":encrypt(_pass.text),"type":encrypt('admin'),});

    if (response.statusCode == 200) {

      var userData = json.decode(response.body);

      //Set json data to string variables

      String ID=userData['ID'];
      String name=decrypt(userData['name']);
      String email=decrypt(userData['email']);
      // String pass=decrypt(userData['pass']);
      String type=decrypt(userData['type']);


      if (userData == "ERROR") {

        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Wrong Email or Password"),
                backgroundColor: Colors.red.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

        }

      }else{


        //Pass string variables into shared prefrences
        SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
        sharedPreferences.setString("ID",ID);
        sharedPreferences.setString("name",name);
        sharedPreferences.setString("email", email);
        // sharedPreferences.setString("pass", pass);
        sharedPreferences.setString("type", type);

        String? UID=sharedPreferences.getString("ID");

        // FirebaseMessaging.instance.subscribeToTopic("users");
        // FirebaseMessaging.instance.subscribeToTopic("users${UID}");

        if(context.mounted){

          Navigator.pushReplacementNamed(context,Dashboard.id);

          //EasyLoading.showSuccess(' Logged in...');


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Logged In"),
                backgroundColor: Colors.green.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );


        }



        print(userData);
      }
    }else{

      return null;
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
                        Text('Login',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),)
                      ],
                    ),



                    const SizedBox(height: 20,),

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

                    const Align(
                        alignment: Alignment.centerRight,
                        child:Text('Forgot password',style: TextStyle(color: Colors.brown),),
                    ),
                    const SizedBox(height: 20,),
                    MaterialButton(
                      color: Colors.brown,
                      onPressed:(){


                        login();

                      },
                    child:const Text('Login',style: TextStyle(color: Colors.white),),)

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
