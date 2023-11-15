import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../api/api.dart';
import '../models/orderdetailsmodel.dart';
import '../models/ordermodel.dart';

class OrdersProvider extends ChangeNotifier{
  ApiCall _api = new ApiCall();

  bool isLoad=false;
  bool isNet=false;


  List<OrderModel> _all=[];
  List<OrderModel> get all => _all;


  List<OrderModel> _part=[];
  List<OrderModel> get part => _part;


  List<OrderModel> _paid=[];
  List<OrderModel> get paid => _paid;



  List<OderDetailsModel> _details=[];
  List<OderDetailsModel> get details => _details;




  var _countAll;
  get countAll => _countAll;

  var _countPart;
  get countPart => _countPart;

  var _countFull;
  get countFull=> _countFull;



  ///credit count
  getallCreditCount() async{

    try {
       isLoad = true;
      notifyListeners();

      final response = await _api.getCountCre();
      _countAll = response!;
      notifyListeners();


    }catch(e){
      isLoad = false;
      isNet = false;
      notifyListeners();

    }

  }

  ///paid count
  getallPaidCount() async{

    try {
      isLoad = true;
      notifyListeners();

      final response = await _api.getCountFull();
      _countFull = response!;
      notifyListeners();


    }catch(e){
      isLoad = false;
      isNet = false;
      notifyListeners();

    }

  }

  ///partially paid count
  getallPartCount() async{

    try {
      isLoad = true;
      notifyListeners();

      final response = await _api.getCountPart();
      _countPart = response!;
      notifyListeners();


    }catch(e){
      isLoad = false;
      isNet = false;
      notifyListeners();

    }

  }




///get all credit sales
  getCredit() async {

    try {
      isNet = false;
      // isLoad = true;
      notifyListeners();

      final response = await _api.getCreditOrders();
      _all = response!;
      notifyListeners();

      getallCreditCount();
      notifyListeners();

      getallPaidCount();
      notifyListeners();

      getallPartCount();
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

  ///get all partly paid sales
  getPart() async {

    try {
      isNet = false;
      // isLoad = true;
      notifyListeners();

      final response = await _api.getPartOrders();
      _part = response!;
      notifyListeners();

      getallCreditCount();
      notifyListeners();

      getallPaidCount();
      notifyListeners();

      getallPartCount();
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


  ///get all fully paid sales
  getFull() async {

    try {
      isNet = false;
      // isLoad = true;
      notifyListeners();

      final response = await _api.getFullPaidOrders();
      _paid = response!;
      notifyListeners();

      getallCreditCount();
      notifyListeners();

      getallPaidCount();
      notifyListeners();

      getallPartCount();
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