
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../encryp/enc.dart';
import '../../login/login.dart';
import '../drawer/nava.dart';


class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {


  final _fomkey=GlobalKey<FormState>();

  final _name=TextEditingController();
  final _num=TextEditingController();
  final _ema=TextEditingController();
  final _pass=TextEditingController();

  bool isLoggedIn=false;

  @override
  void initState() {
    getPref().then((value){
      getData();

    });

    super.initState();
  }

  getData() async{

    setState(() {
      _name.text='${nem}';
      _ema.text='${email}';
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

  lougOut() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //String? UID=sharedPreferences.getString("id");
    // FirebaseMessaging.instance.unsubscribeFromTopic("users");
    // FirebaseMessaging.instance.unsubscribeFromTopic("users${UID}");

    sharedPreferences.remove("ID");
    sharedPreferences.remove("name");
    sharedPreferences.remove("email");
    sharedPreferences.remove("type");



    if(mounted){
      Navigator.pushReplacementNamed(context, Login.id);
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:const NavDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.brown.shade300,
        iconTheme: const IconThemeData(color: Colors.white),
        title:const Text('Edit Account',maxLines: 1,overflow:TextOverflow.ellipsis,style: TextStyle(color: Colors.white)),
      ),
      body:Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.brown.withOpacity(0.3),
          image:const DecorationImage(
            image: AssetImage('assets/images/ho.jpg'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //form
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          key: _fomkey,
                          child:Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                TextFormField(
                                    controller: _name,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.person_outline_outlined),
                                      labelText: 'Full Name',
                                      hintText: 'Full Name',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'Enter your Name';

                                      }
                                      return null;
                                    }
                                ),

                                const SizedBox(height: 10,),


                                TextFormField(
                                    controller: _ema,
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.email_outlined),
                                        labelText: 'Email',
                                        hintText: 'Email',
                                        border: OutlineInputBorder()
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

                                SizedBox(
                                  width:double.infinity,
                                  child: ElevatedButton(
                                      onPressed:() async {

                                        EasyLoading.show(status: 'Editing .....');

                                        if(_fomkey.currentState!.validate()) {
                                          var response = await http.post(
                                              Uri.parse(
                                                  'https://masiko.000webhostapp.com/api/login/edituser.php'),
                                              headers: {
                                                "Accept": "headers/json"
                                              },
                                              body: {
                                                "uid": '${ID}',
                                                "name": _name.text,
                                                "email": _ema.text,
                                              });


                                          if (response.statusCode == 200) {

                                            EasyLoading.showSuccess(' Account Edited.....');

                                            lougOut();
                                            EasyLoading.dismiss();
                                          } else {

                                            EasyLoading.dismiss();

                                          }

                                          EasyLoading.dismiss();

                                        }




                                      },
                                      child: Text('Update'.toUpperCase(),style: const TextStyle(color: Colors.white),)
                                  ),
                                ),

                                const SizedBox(height:40,),


                              ],
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
