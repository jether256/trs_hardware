import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../api/api.dart';
import '../models/orderdetailsmodel.dart';
import '../models/ordermodel.dart';

class OrdersProvider extends ChangeNotifier{
  ApiCall _api = new ApiCall();

  bool isLoad=false;
  bool isNet=false;


  List<OrderModel> _datee=[];
  List<OrderModel> get datee => _datee;


  List<OrderModel> _all=[];
  List<OrderModel> get all => _all;


  List<OrderModel> _part=[];
  List<OrderModel> get part => _part;


  List<OrderModel> _paid=[];
  List<OrderModel> get paid => _paid;



  List<OderDetailsModel> _details=[];
  List<OderDetailsModel> get details => _details;

  Map<String,dynamic>? _confirm;
  Map<String,dynamic>? get confirm => _confirm;



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
      isLoad = true;
      notifyListeners();

      final response = await _api.getCreditOrders();
      _all = response!;
      isNet=false;
      isLoad=false;
      notifyListeners();

      getallCreditCount();
      notifyListeners();

      getallPaidCount();
      notifyListeners();

      getallPartCount();
      notifyListeners();

      getFull();
      notifyListeners();

      getPart();
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
       isLoad = true;
      notifyListeners();

      final response = await _api.getPartOrders();
      _part = response!;
      isNet=false;
      isLoad=false;
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
      isLoad = true;
      notifyListeners();

      final response = await _api.getFullPaidOrders();
      _paid = response!;
      isNet=false;
      isLoad=false;
      notifyListeners();


      getallCreditCount();
      notifyListeners();

      getallPaidCount();
      notifyListeners();

      getallPartCount();
      notifyListeners();

      getCredit();
      notifyListeners();

      getPart();
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

  ///get order details
  getDetails(String trid) async {

    try {
      isNet = false;
      // isLoad = true;
      notifyListeners();

      final response = await _api.getOderDetails(trid);
      _details = response!;
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

  ///edit Order
  editO({
    required BuildContext context, required String trid, required String bal
  }) async{

    try{
      isLoad=true;
      isNet=false;
      notifyListeners();


      final response = await _api.EditOrder(context,trid,bal);
      _confirm=response;
      isLoad=false;
      isNet=false;
      notifyListeners();

      getallCreditCount();
      notifyListeners();

      getallPaidCount();
      notifyListeners();

      getallPartCount();
      notifyListeners();

      getCredit();
      notifyListeners();

      getPart();
      notifyListeners();

      getFull();
      notifyListeners();




    }catch(e){

      isLoad=false;
      isNet=false;
      notifyListeners();

    }

  }



  ///edit full
  editF({
    required BuildContext context, required String trid, required String bal
  }) async{

    try{
      isLoad=true;
      isNet=false;
      notifyListeners();


      final response = await _api.EdittF(context,trid,bal);
      _confirm=response;
      isLoad=false;
      isNet=false;
      notifyListeners();

      getallCreditCount();
      notifyListeners();

      getallPaidCount();
      notifyListeners();

      getallPartCount();
      notifyListeners();

      getCredit();
      notifyListeners();

      getPart();
      notifyListeners();

      getFull();
      notifyListeners();




    }catch(e){

      isLoad=false;
      isNet=false;
      notifyListeners();

    }

  }


  ///edit part
  editP({
    required BuildContext context, required String trid, required String bal
  }) async{

    try{
      isLoad=true;
      isNet=false;
      notifyListeners();


      final response = await _api.EdittP(context,trid,bal);
      _confirm=response;
      isLoad=false;
      isNet=false;
      notifyListeners();

      getallCreditCount();
      notifyListeners();

      getallPaidCount();
      notifyListeners();

      getallPartCount();
      notifyListeners();

      getCredit();
      notifyListeners();

      getPart();
      notifyListeners();

      getFull();
      notifyListeners();

    }catch(e){

      isLoad=false;
      isNet=false;
      notifyListeners();

    }

  }


  ///get date list
  getDate({required String date}) async {

    try {
      isNet = false;
      // isLoad = true;
      notifyListeners();

      final response = await _api.getDateList(date);
      _datee = response!;
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