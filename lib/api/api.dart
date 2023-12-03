
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trs_hardware/main-navigation/dashboard.dart';
import 'package:trs_hardware/main-navigation/product/products.dart';
import 'dart:convert';
import '../encryp/enc.dart';
import 'package:trs_hardware/api/url/url.dart';

import '../login/forget.dart';
import '../login/login.dart';
import '../login/loginCheck.dart';
import '../main-navigation/cart/getCart.dart';
import '../main-navigation/home/home.dart';
import '../models/cartmodel.dart';
import '../models/orderdetailsmodel.dart';
import '../models/ordermodel.dart';
import '../models/productmodel.dart';


class ApiCall{



  ///send Mail
  Future  sentMail( String email,BuildContext context) async {

    var response = await http.post(
      Uri.parse(
          BaseUrl.sendMail),
      //headers can be left out since CORS doesn't affect apps but it will affect A flutter web app,
      //so just to be safe include them.
      headers: {"Accept": "headers/json"},
      body:{
        "mail":email,
      },
    );


    if(response.statusCode==200){

      var userData=json.decode(response.body);

      if(context.mounted){// context is needed for the navigator and snackbar to work

        // check if the email already exists else register user
        if(userData=="Ye"){


          ///route to check email evrification code page after verification

          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginCheck(mail:email)));

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Email Sent"),
                backgroundColor: Colors.brown.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

        }

        else if(userData=="Fail"){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Failed to send Email"),
                backgroundColor: Colors.red.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

        }

        else if(userData=="No"){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Email doesn't exist"),
                backgroundColor: Colors.red.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

        }


      }

    }else{

      return null;
    }
    
  }



  ///verify password function
  Future  PassVeri( String email, String code, BuildContext context) async {

    var response = await http.post(
      Uri.parse(
          BaseUrl.passVerify),
      //headers can be left out since CORS doesn't affect apps but it will affect A flutter web app,
      //so just to be safe include them.
      headers: {"Accept": "headers/json"},
      body:{
        "email":email,
        "key":code,
      },
    );


    if(response.statusCode==200){

      var userData=json.decode(response.body);

      if(context.mounted){// context is needed for the navigator and snackbar to work

        // check if the email already exists else register user
        if(userData=="ye"){


          ///route to password reset page after after verification
          //Navigator.pushNamed(context,ForgotPassword.id);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword(mail:email)));

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Verification Successfully Set new Password"),
                backgroundColor: Colors.brown.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

        }

        else if(userData=="no"){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Wrong Code"),
                backgroundColor: Colors.red.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

        }


      }

    }else{

      return null;
    }





  }



  ///password reset
  Future<Map<String,dynamic>?> Reset(String password,BuildContext context, String email) async{

    var response = await http.post(
      Uri.parse(BaseUrl.passReset),
      headers: {"Accept": "headers/json"},
      body:{
        "mail": email,
        "pass": password,
      }
      ,
    );

    if (response.statusCode == 200) {

      var userData = json.decode(response.body);





      if (userData == "Yes") {

        if(context.mounted){

          ///route to login page after password reset
          //Navigator.pushNamed(context, Login.id);
          Navigator.pushReplacementNamed(context,Login.id);

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Password reset"),
                backgroundColor: Colors.brown.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

        }

      } else if(userData=="No"){


        if(context.mounted){

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Password reset failed"),
                backgroundColor: Colors.red.withOpacity(0.9),
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






  ///save product
  Future<Map<String,dynamic>?> ProSave(BuildContext context,String name,String desc,String price ) async{

    var response = await http.post(
      Uri.parse(BaseUrl.addPro),
      headers: {"Accept": "headers/json"},
      body:{
        "name": encrypt(name),
        "descc": encrypt(desc),
        "price": encrypt(price),
      }
      ,
    );

    if (response.statusCode == 200) {

      var userData = json.decode(response.body);

      if (userData == "ERROR") {

        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Product already saved"),
                backgroundColor: Colors.red.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

        }

      }else{


        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Saved"),
                backgroundColor: Colors.brown.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

          Navigator.pushReplacementNamed(context,Products.id);
        }



        print(userData);
      }
    }else{

      return null;
    }
    return null;

  }

  ///edit product
  Future<Map<String,dynamic>?> ProEdit(BuildContext context,String name,String desc,String price, String id ) async{

    var response = await http.post(
      Uri.parse(BaseUrl.editPro),
      headers: {"Accept": "headers/json"},
      body:{
        "id":id,
        "name": encrypt(name),
        "descc": encrypt(desc),
        "price": encrypt(price),
      }
      ,
    );

    if (response.statusCode == 200) {

      //var userData = json.decode(response.body);

      if(context.mounted){


        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Product edited "),
              backgroundColor: Colors.brown.withOpacity(0.9),
              elevation: 10, //shadow
            )
        );

        Navigator.pushReplacementNamed(context,Products.id);

      }

    }else{

      return null;
    }
    return null;

  }

  ///del product
  Future<Map<String,dynamic>?> delProo(BuildContext context,String id ) async{

    var response = await http.post(
      Uri.parse(BaseUrl.deletePro),
      headers: {"Accept": "headers/json"},
      body:{
        "id":id,
      }
      ,
    );

    if (response.statusCode == 200) {

      var userData = json.decode(response.body);

      if(context.mounted){


        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Product deleted "),
              backgroundColor: Colors.brown.withOpacity(0.9),
              elevation: 10, //shadow
            )
        );

        Navigator.pushReplacementNamed(context,Products.id);

      }
    }else{

      return null;
    }
    return null;

  }


 ///get products
Future<List<ProductModel>?> getPro() async {

  var response = await http.get(
      Uri.parse(BaseUrl.getPro),
      headers: {"Accept": "headers/json"});

  if (response.statusCode == 200) {

    return productFromJson(
        json.decode(response.body)
    );

  } else {

    return null;

  }


}







///Cart functions

  Future<Map<String,dynamic>?>  addCart(BuildContext context, String proid, String price, String uid, String qty) async{

    var response = await http.post(
      Uri.parse(BaseUrl.addCart),
      headers: {"Accept": "headers/json"},
      body:{
        "proid":proid,
        "quant":qty,
        "price":price,
        "uid":uid,
      }
      ,
    );

    if (response.statusCode == 200) {

      var userData = json.decode(response.body);

      if (userData == "ERROR") {

        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Already in the cart"),
                backgroundColor: Colors.red.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );
          Navigator.pop(context);
        }

      }else{


        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Added to cart"),
                backgroundColor: Colors.brown.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );
          Navigator.pop(context);

          //Navigator.pushReplacementNamed(context,Dashboard.id);
        }



        print(userData);
      }
    }else{

      return null;
    }
    return null;

  }

  ///get Cart products
  Future<List<CartModel>?> getCartt() async {

    SharedPreferences pref= await SharedPreferences.getInstance();
    String? ID=pref.getString('ID');

    var response = await http.post(
        Uri.parse(BaseUrl.getCart),
        headers: {"Accept": "headers/json"},
        body:{'uid':ID!}
    );

    if (response.statusCode == 200) {
      return cartFromJson(
          json.decode(response.body)
      );
    } else {
      return null;
    }
  }


  ///delete from cart
  Future<Map<String,dynamic>?> delCart(String catid,BuildContext context) async {

    var response = await http.post(Uri.parse(BaseUrl.delCart),
        //headers can be left out since CORS doesn't affect apps but it will affect A flutter web app,
        //so just to be safe include them.
        headers: {"Accept": "headers/json"},
        body: {
          "catid":catid,
        });


    if (response.statusCode == 200) {

      if(context.mounted){

        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: const Text("Deleted"),
        //       backgroundColor: Colors.red.withOpacity(0.9),
        //       elevation: 10, //shadow
        //     )
        // );

        // final snackBar = SnackBar(
        //   elevation: 0,
        //   behavior: SnackBarBehavior.floating,
        //   backgroundColor: Colors.transparent,
        //   content: AwesomeSnackbarContent(
        //     title: 'Deleted',
        //     message:
        //     'Deleted',
        //     contentType: ContentType.success,
        //   ),
        // );
        //
        // ScaffoldMessenger.of(context)
        //   ..hideCurrentSnackBar()
        //   ..showSnackBar(snackBar);
      }


    }


  }




  ///get Total Price
  Future getCartTotal() async {

    SharedPreferences pref= await SharedPreferences.getInstance();
    String? ID=pref.getString('ID');

    var response = await http.post(
        Uri.parse(BaseUrl.totalCart),
        headers: {"Accept": "headers/json"},
        body:{'uid':ID!}
    );

    if (response.statusCode == 200) {
      final data= jsonDecode(response.body);

      return int.parse(data);

    } else {

      return null;
    }

  }


  ///get cart Count
  Future getCount() async {

    SharedPreferences pref= await SharedPreferences.getInstance();
    String? ID=pref.getString('ID');

    var response = await http.post(
        Uri.parse(BaseUrl.cartCount),
        headers: {"Accept": "headers/json"},
        body:{'uid':ID}
    );

    if (response.statusCode == 200) {
      final data= jsonDecode(response.body);

      return data;


    } else {

      return null;
    }

  }


  ///update quantity cart
  Future<Map<String,dynamic>?> updateQaunt(String catid, String quant, BuildContext context) async {

    var response = await http.post(Uri.parse(BaseUrl.upDateCart),
        //headers can be left out since CORS doesn't affect apps but it will affect A flutter web app,
        //so just to be safe include them.
        headers: {"Accept": "headers/json"},
        body: {
          "catid":catid,
          "quant": quant,
        });


    if (response.statusCode == 200) {
      var userData = json.decode(response.body);

      print(userData);
    }


  }


  ///confrim
  Future<Map<String,dynamic>?> Konfirm(BuildContext context,String name) async{


    EasyLoading.show(status: 'Saving.....');

    SharedPreferences pref= await SharedPreferences.getInstance();
    String? ID=pref.getString('ID');

    var response = await http.post(
      Uri.parse(BaseUrl.confirm),
      headers: {"Accept": "headers/json"},
      body:{
        "uid": ID,
        // "date": date,
        "name":name,
        // "now":DateFormat('yyyy/MM/dd').format(DateTime.now())
      }
      ,
    );

    if (response.statusCode == 200) {

      var userData = json.decode(response.body);

      if (userData == "done") {

        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Order placed successfully"),
                backgroundColor: Colors.brown.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

          //Navigator.pushReplacementNamed(context,Dashboard.id);
          //Navigator.pushReplacementNamed(context,Cart.id);
          Navigator.pop(context);
        }

        EasyLoading.dismiss(animation: true);
      }else{


        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("failed to placed on"),
                backgroundColor: Colors.red.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

          Navigator.pop(context);
        }



        print(userData);


      }
    }else{

      return null;
    }
    return null;

  }






  ///Orders

  ///
  /// credit count
  Future getCountCre() async {

    SharedPreferences pref= await SharedPreferences.getInstance();
    String? ID=pref.getString('ID');

    var response = await http.post(
        Uri.parse(BaseUrl.getCreditCount),
        headers: {"Accept": "headers/json"},
        body:{'uid':ID}
    );

    if (response.statusCode == 200) {
      final data= jsonDecode(response.body);

      return data;


    } else {

      return null;
    }

  }


  /// full payment count
  Future getCountFull() async {

    SharedPreferences pref= await SharedPreferences.getInstance();
    String? ID=pref.getString('ID');

    var response = await http.post(
        Uri.parse(BaseUrl.getFullCount),
        headers: {"Accept": "headers/json"},
        body:{'uid':ID}
    );

    if (response.statusCode == 200) {
      final data= jsonDecode(response.body);

      return data;


    } else {

      return null;
    }

  }


  /// part payment count
  Future getCountPart() async {

    SharedPreferences pref= await SharedPreferences.getInstance();
    String? ID=pref.getString('ID');

    var response = await http.post(
        Uri.parse(BaseUrl.getPartCount),
        headers: {"Accept": "headers/json"},
        body:{'uid':ID}
    );

    if (response.statusCode == 200) {
      final data= jsonDecode(response.body);

      return data;


    } else {

      return null;
    }

  }


  ///get credit sales
  Future<List<OrderModel>?> getCreditOrders() async {

    SharedPreferences pref= await SharedPreferences.getInstance();
    String? ID=pref.getString('ID');

    var response = await http.post(
        Uri.parse(BaseUrl.getCreditOrder),
        headers: {"Accept": "headers/json"},
        body:{'id':ID!}
    );

    if (response.statusCode == 200) {
      return orderFromJson(
          json.decode(response.body)
      );
    } else {
      return null;
    }
  }

  ///get partially paid sales
  Future<List<OrderModel>?> getPartOrders() async {

    SharedPreferences pref= await SharedPreferences.getInstance();
    String? ID=pref.getString('ID');

    var response = await http.post(
        Uri.parse(BaseUrl.getPartOrder),
        headers: {"Accept": "headers/json"},
        body:{'id':ID!}
    );

    if (response.statusCode == 200) {
      return orderFromJson(
          json.decode(response.body)
      );
    } else {
      return null;
    }
  }


  ///get fully paid sales
  Future<List<OrderModel>?> getFullPaidOrders() async {

    SharedPreferences pref= await SharedPreferences.getInstance();
    String? ID=pref.getString('ID');

    var response = await http.post(
        Uri.parse(BaseUrl.getFullOrder),
        headers: {"Accept": "headers/json"},
        body:{'id':ID!}
    );

    if (response.statusCode == 200) {
      return orderFromJson(
          json.decode(response.body)
      );
    } else {
      return null;
    }
  }


  ///get order details
  Future<List<OderDetailsModel>?> getOderDetails( String trid) async {


    var response = await http.post(
        Uri.parse(BaseUrl.getOrderDe),
        headers: {"Accept": "headers/json"},
        body:{'trans':trid}
    );

    if (response.statusCode == 200) {
      return orderdetailsFromJson(
          json.decode(response.body)
      );
    } else {
      return null;
    }
  }


  ///edit full
  Future<Map<String,dynamic>?> EdittF(BuildContext context, String trid, String bal) async{




    var response = await http.post(
      Uri.parse(BaseUrl.editFull),
      headers: {"Accept": "headers/json"},
      body:{
        "trid":trid,
        "bal":bal,
      }
      ,
    );

    if (response.statusCode == 200) {

      var userData = json.decode(response.body);

      if (userData == "full") {

        if(context.mounted){


          // ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: const Text("Order edited successfully"),
          //       backgroundColor: Colors.brown.withOpacity(0.9),
          //       elevation: 10, //shadow
          //     )
          // );

          Navigator.pushReplacementNamed(context,Dashboard.id);
          Navigator.pop(context);

        }


      }else{


        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("failed to placed on"),
                backgroundColor: Colors.red.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

          Navigator.pop(context);
        }



        print(userData);


      }
    }else{

      return null;
    }
    return null;

  }

  ///edit part
  Future<Map<String,dynamic>?> EdittP(BuildContext context, String trid, String bal) async{


    var response = await http.post(
      Uri.parse(BaseUrl.editPart),
      headers: {"Accept": "headers/json"},
      body:{
        "trid":trid,
        "bal":bal,
      }
      ,
    );

    if (response.statusCode == 200) {

      var userData = json.decode(response.body);

      if (userData == "part") {

        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Order placed successfully"),
                backgroundColor: Colors.brown.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );



          Navigator.pushReplacementNamed(context,Dashboard.id);

          Navigator.pop(context);
        }


      }else{


        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("failed to placed on"),
                backgroundColor: Colors.red.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

          Navigator.pop(context);
        }



        print(userData);


      }
    }else{

      return null;
    }
    return null;

  }


  ///edit part2
  Future<Map<String,dynamic>?> EdittP2(BuildContext context, String trid, String bal) async{


    var response = await http.post(
      Uri.parse(BaseUrl.editPart2),
      headers: {"Accept": "headers/json"},
      body:{
        "trid":trid,
        "bal":bal,
      }
      ,
    );

    if (response.statusCode == 200) {

      var userData = json.decode(response.body);

      if (userData == "part") {

        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Order placed successfully"),
                backgroundColor: Colors.brown.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );




        }


      }else{


        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("failed to placed on"),
                backgroundColor: Colors.red.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

          Navigator.pop(context);
        }



        print(userData);


      }
    }else{

      return null;
    }
    return null;

  }


  ///edit order
  Future<Map<String,dynamic>?> EditOrder(BuildContext context,String trid,String bal) async{



    SharedPreferences pref= await SharedPreferences.getInstance();
    String? ID=pref.getString('ID');

    var response = await http.post(
      Uri.parse(BaseUrl.editOrders),
      headers: {"Accept": "headers/json"},
      body:{
        "trid":trid,
        "bal": bal,
      }
      ,
    );

    if (response.statusCode == 200) {

      var userData = json.decode(response.body);

      if (userData == "full") {

        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Order placed successfully"),
                backgroundColor: Colors.brown.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );



          Navigator.pushReplacementNamed(context,Dashboard.id);

          Navigator.pop(context);
        }


      }else{


        if(context.mounted){


          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("failed to placed on"),
                backgroundColor: Colors.red.withOpacity(0.9),
                elevation: 10, //shadow
              )
          );

          Navigator.pop(context);
        }



        print(userData);


      }
    }else{

      return null;
    }
    return null;

  }




  ///get date Lists
  Future<List<OrderModel>?> getDateList(String date) async {

    SharedPreferences pref= await SharedPreferences.getInstance();
    String? ID=pref.getString('ID');

    var response = await http.post(
        Uri.parse(BaseUrl.date),
        headers: {"Accept": "headers/json"},
        body:{
          'uid':ID!,
          'date':date
        }
    );

    if (response.statusCode == 200) {
      return orderFromJson(
          json.decode(response.body)
      );
    } else {
      return null;
    }
  }

//
  //
  // ///send Mail
  // Future  sentMail( String email,BuildContext context) async {
  //
  //   var response = await http.post(
  //     Uri.parse(
  //         BaseUrl.checkMail),
  //     //headers can be left out since CORS doesn't affect apps but it will affect A flutter web app,
  //     //so just to be safe include them.
  //     headers: {"Accept": "headers/json"},
  //     body:{
  //       "mail": encryp(email),
  //     },
  //   );
  //
  //
  //   if(response.statusCode==200){
  //
  //     var userData=json.decode(response.body);
  //
  //     if(context.mounted){// context is needed for the navigator and snackbar to work
  //
  //       // check if the email already exists else register user
  //       if(userData=="Ye"){
  //
  //
  //         ///route to check email evrification code page after verification
  //
  //         Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginCheck(mail:email)));
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: const Text("Email Sent"),
  //               backgroundColor: Colors.green.withOpacity(0.9),
  //               elevation: 10, //shadow
  //             )
  //         );
  //
  //       }
  //
  //       else if(userData=="Fail"){
  //
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: const Text("Failed to send Email"),
  //               backgroundColor: Colors.red.withOpacity(0.9),
  //               elevation: 10, //shadow
  //             )
  //         );
  //
  //       }
  //
  //       else if(userData=="No"){
  //
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: const Text("Email doesn't exist"),
  //               backgroundColor: Colors.red.withOpacity(0.9),
  //               elevation: 10, //shadow
  //             )
  //         );
  //
  //       }
  //
  //
  //     }
  //
  //   }else{
  //
  //     return null;
  //   }
  //
  //
  //
  //
  //
  // }
  //
  // ///verify password function
  // Future  PassVeri( String email, String code, BuildContext context) async {
  //
  //   var response = await http.post(
  //     Uri.parse(
  //         BaseUrl.passVerify),
  //     //headers can be left out since CORS doesn't affect apps but it will affect A flutter web app,
  //     //so just to be safe include them.
  //     headers: {"Accept": "headers/json"},
  //     body:{
  //       "email": encryp(email),
  //       "key": encryp(code),
  //     },
  //   );
  //
  //
  //   if(response.statusCode==200){
  //
  //     var userData=json.decode(response.body);
  //
  //     if(context.mounted){// context is needed for the navigator and snackbar to work
  //
  //       // check if the email already exists else register user
  //       if(userData=="ye"){
  //
  //
  //         ///route to password reset page after after verification
  //         //Navigator.pushNamed(context,ForgotPassword.id);
  //         Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword(mail:email)));
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: const Text("Verification Successfully Set new Password"),
  //               backgroundColor: Colors.green.withOpacity(0.9),
  //               elevation: 10, //shadow
  //             )
  //         );
  //
  //       }
  //
  //       else if(userData=="no"){
  //
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: const Text("Wrong Code"),
  //               backgroundColor: Colors.red.withOpacity(0.9),
  //               elevation: 10, //shadow
  //             )
  //         );
  //
  //       }
  //
  //
  //     }
  //
  //   }else{
  //
  //     return null;
  //   }
  //
  //
  //
  //
  //
  // }
  //
  // ///password reset
  // Future<Map<String,dynamic>?> Reset(String password,BuildContext context, String email) async{
  //
  //   var response = await http.post(
  //     Uri.parse(BaseUrl.passReset),
  //     headers: {"Accept": "headers/json"},
  //     body:{
  //       "mail": encryp(email),
  //       "pass": encryp(password),
  //     }
  //     ,
  //   );
  //
  //   if (response.statusCode == 200) {
  //
  //     var userData = json.decode(response.body);
  //
  //
  //
  //
  //
  //     if (userData == "Yes") {
  //
  //       if(context.mounted){
  //
  //         ///route to login page after password reset
  //         //Navigator.pushNamed(context, Login.id);
  //         Navigator.pushReplacementNamed(context,LoginScreen.id);
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: const Text("Password reset"),
  //               backgroundColor: Colors.green.withOpacity(0.9),
  //               elevation: 10, //shadow
  //             )
  //         );
  //
  //       }
  //
  //     } else if(userData=="No"){
  //
  //
  //       if(context.mounted){
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: const Text("Password reset failed"),
  //               backgroundColor: Colors.red.withOpacity(0.9),
  //               elevation: 10, //shadow
  //             )
  //         );
  //       }
  //
  //
  //       print(userData);
  //     }
  //   }else{
  //
  //     return null;
  //   }
  //
  //
  //
  // }
  //
  //
  //
  //
  //
  //
  // ///get categories
  // Future<List<CategoryModel>?> geCat() async {
  //
  //   var response = await http.get(
  //       Uri.parse(BaseUrl.apiCategory),
  //       headers: {"Accept": "headers/json"});
  //
  //
  //   if (response.statusCode == 200) {
  //
  //     return cartsFromJson(
  //         json.decode(response.body)
  //     );
  //
  //   } else {
  //
  //     return null;
  //
  //   }
  //
  //
  // }


  
}