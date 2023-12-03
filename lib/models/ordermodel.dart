import 'dart:convert';

List<OrderModel> orderFromJson(dynamic str) => List<OrderModel>.from(
    (str).map(
          (x)=>OrderModel.fromJson(x),
    ));

String orderToJson(List<OrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel{

  final String id;
  final String user_id;

  final String c_am;
  final String tr_id;
  final String bal;
  final String sta;
  final String name;

  OrderModel({required this.name, required this.id, required this.user_id, required this.c_am, required this.tr_id, required this.bal, required this.sta, });

  factory OrderModel.fromJson(data){
    return   OrderModel(
      id:data['id'],
      user_id:data['user_id'],
      c_am: data['credit_amount'],
      tr_id: data['transaction_id'],
      bal: data['balance'],
      sta: data['status'],
      name: data['bizname']
    );
  }


  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id":user_id,
    "credit_amount":c_am,
    "transaction_id":tr_id,
    "balance":bal,
    "status":sta,
    "bizname":name
  };


}