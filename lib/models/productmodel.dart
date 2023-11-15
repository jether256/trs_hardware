import 'dart:convert';

List<ProductModel> productFromJson(dynamic str) => List<ProductModel>.from(
    (str).map(
          (x)=>ProductModel.fromJson(x),
    ));

String productToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class ProductModel{

  final String id;
  final String name;
  final String descc;
  final String price;

  ProductModel({required this.id, required this.name, required this.descc, required this.price, });

  factory ProductModel.fromJson(data){
    return   ProductModel(
      id:data['id'],
      name:data['name'],
      descc: data['descc'],
      price: data['price'],
    );
  }


  Map<String, dynamic> toJson() => {
    "id": id,
    "name":name,
    "descc":descc,
    "price":price
  };

}