import 'dart:convert';

List<OderDetailsModel> orderdetailsFromJson(dynamic str) => List<OderDetailsModel>.from(
    (str).map(
          (x)=>OderDetailsModel.fromJson(x),
    ));

String orderdetailsToJson(List<OderDetailsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OderDetailsModel{

  final String id;
  final String proid;
  final String price;
  final String quantity;
  final String oderid;
  final String name;

  OderDetailsModel({required this.id, required this.price, required this.quantity, required this.oderid,required this.proid, required this.name,  });

  factory OderDetailsModel.fromJson(data){
    return   OderDetailsModel(
      id:data['id'],
      proid: data['product_id'],
      price: data['price'],
      quantity: data['quantity'],
      oderid: data['order_id'],
      name: data['name']
    );
  }


  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id":proid,
    "price":price,
    "quantity":quantity,
    "order_id":oderid,
    "name":name
  };


}