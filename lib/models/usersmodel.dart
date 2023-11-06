


class UserModel{


  final String ID;
  final String name;
  final String pass;
  final String type;

  UserModel({required this.ID,required this.name,required this.pass,required this.type});


  factory UserModel.fromJson(Map<String,dynamic> json){

    return UserModel(
      ID: json['ID'],
      name: json['name'],
      pass: json['pass'],
      type: json['type']
    );
  }


  Map<String, dynamic> toJson() => {
    "ID":ID,
    "name":name,
    "pass":pass,
    "type":type,
  };


}