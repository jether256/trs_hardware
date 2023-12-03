


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trs_hardware/api/api.dart';

import '../models/cartmodel.dart';

class CartProvider extends ChangeNotifier{

  ApiCall _api = new ApiCall();

  bool isLoad=false;
  bool isNet=false;


  Map<String,dynamic>? _addcart;
  Map<String,dynamic>? get addcart => _addcart;


  List<CartModel> _cart=[];
  List<CartModel> get cart => _cart;

  Map<String,dynamic>? _update;
  Map<String,dynamic> get update =>_update!;

  Map<String,dynamic>? _delete;
  Map<String,dynamic> get delete =>_delete!;

  // Map<String,dynamic>? _total;
  // Map<String,dynamic>? get total => _total;

  Map<String,dynamic>? _confirm;
  Map<String,dynamic>? get confirm => _confirm;


  var _count;
  get count => _count;

  var _totalSum=0;
  get totalSum => _totalSum;

  var _sumPrice=0;
  get sumPrice => _sumPrice;

  confirmm({
    required BuildContext context, required String name
  }) async{

    try{
      // isLoad=true;
      // isNet=false;
      // notifyListeners();


      final response = await _api.Konfirm(context,name);
      _confirm=response;
      // isLoad=false;
      // isNet=false;
      notifyListeners();

      getTotal();
      notifyListeners();

      getCartCount();
      notifyListeners();

      getCart();
      notifyListeners();

    }catch(e){

      isLoad=false;
      isNet=false;
      notifyListeners();

    }

  }


  saveCart({
    required BuildContext context, required String proid, required String price, required String uid, required String qty,
  }) async{

    try{
      isLoad=true;
      isNet=false;
      notifyListeners();


      final response = await _api.addCart(context,proid,price,uid,qty);
      _addcart=response;
      notifyListeners();
      // isLoad=false;
      getCartCount();
      notifyListeners();
      isNet=false;
      notifyListeners();

      //getProList();
      //notifyListeners();

    }catch(e){

      isLoad=false;
      isNet=false;
      notifyListeners();

    }


  }



  getCart() async {

    try {
      isNet = false;
      // isLoad = true;
      notifyListeners();

      final response = await _api.getCartt();
      _cart = response!;
      notifyListeners();

      getCartCount();
      notifyListeners();

      getTotal();
      notifyListeners();

    }on SocketException catch (_) {
      isLoad = false;
      isNet = true;
      notifyListeners();

    }catch(e){
      isLoad = false;
      isNet = false;
      notifyListeners();

    }


  }


  ///Total cart
  getTotal() async {

      final response = await _api.getCartTotal();

      if(response != null) {
        _sumPrice = response;
        notifyListeners();

        getCart();
        notifyListeners();
      }else{
        _sumPrice=0;
      }
  }



  ///cart count
  getCartCount() async{

      final response= await _api.getCount();

      if(response != null) {
        _count = response;
        notifyListeners();
      }else{
        _count=0;
      }

  }



  ///update quantity
  updateQuanity({
    required String catid,
    required String quant,
    required BuildContext context,
  }) async{

    final response = await _api.updateQaunt(catid,quant,context);
    _update=response;
    notifyListeners();

    getCart();
    notifyListeners();

    getCartCount();
    notifyListeners();

    getTotal();
    notifyListeners();
  }


  ///delete from cart
  deleteCartItem({
    required String catid,
    required BuildContext context,
  }) async{

    final response = await _api.delCart(catid,context);
    _delete=response;
    notifyListeners();

    getCart();
    notifyListeners();

    getCartCount();
    notifyListeners();

    getTotal();
    notifyListeners();
  }


  alertDialog({context,title,content}){

    showCupertinoDialog(context: context, builder:(BuildContext context){

      return CupertinoAlertDialog(
        title:Text(title),
        content: Text(content),
        actions:  [
          CupertinoDialogAction(child:const Text('ok'),onPressed: (){
            
            Navigator.pop(context);
          },)
        ],
      );
    });
  }



}