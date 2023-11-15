
import 'dart:convert';

List<CartModel> cartFromJson(dynamic str) => List<CartModel>.from(
    (str).map(
          (x)=>CartModel.fromJson(x),
    ));

String cartToJson(List<CartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartModel{

  final String id;
  final String proid;
  final String price;
  final String quantity;
  final String userid;
  final String name;

  CartModel({required this.name, required this.id, required this.proid, required this.price, required this.quantity, required this.userid,});

  factory CartModel.fromJson(data){
    return   CartModel(
      id:data['id'],
      proid:data['product_id'],
      price: data['price'],
      quantity: data['quantity'],
      userid: data['user_id'],
      name: data['name'],
    );
  }


  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id":proid,
    "price":price,
    "quantity":quantity,
    "user_id":userid,
    "name":name
  };


}