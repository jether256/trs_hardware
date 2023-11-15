


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:trs_hardware/api/api.dart';
import 'package:trs_hardware/models/productmodel.dart';

class ProductProvider extends ChangeNotifier{
  ApiCall _api = new ApiCall();



  Map<String,dynamic>? _savee;
  Map<String,dynamic>? get login =>_savee;

  Map<String,dynamic>? _edit;
  Map<String,dynamic>? get edit =>_edit;

  Map<String,dynamic>? _del;
  Map<String,dynamic>? get del =>_del;

  List<ProductModel> _pro=[];
  List<ProductModel> get pro => _pro;

  bool isLoad=false;
  bool isNet=false;


  savePro({
    required BuildContext context, required String name, required String desc, required String price,
}) async{

    try{
      isLoad=true;
      isNet=false;
      notifyListeners();


      final response = await _api.ProSave(context,name,desc,price);
      _savee=response;
      isLoad=false;
      isNet=false;
      notifyListeners();

      getProList();
      notifyListeners();

    }catch(e){

      isLoad=false;
      isNet=false;
      notifyListeners();

    }


  }



  editPro({
    required BuildContext context, required String name, required String desc, required String price, required String id,
  }) async{

    try{
      isLoad=true;
      isNet=false;
      notifyListeners();


      final response = await _api.ProEdit(context,name,desc,price,id);
      _edit=response;
      isLoad=false;
      isNet=false;


      notifyListeners();
    }catch(e){

      isLoad=false;
      isNet=false;
      notifyListeners();

    }


  }


  delPro({
    required BuildContext context,required String id,
  }) async{

    try{
      isLoad=true;
      isNet=false;


      final response = await _api.delProo(context,id);
      _edit=response;
      isLoad=false;
      isNet=false;
      notifyListeners();

      getProList();
      notifyListeners();


    }catch(e){

      isLoad=false;
      isNet=false;
      notifyListeners();

    }


  }



  getProList() async {

    try {
      isNet = false;
      isLoad = true;


      final response = await _api.getPro();
      _pro = response!;

      isNet = false;
      isLoad = false;

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

}