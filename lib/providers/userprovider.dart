
import 'package:flutter/cupertino.dart';

import '../api/api.dart';

class UserProvider extends ChangeNotifier{


  ApiCall _api = new ApiCall();

  bool isLoad=false;
  bool isNet=false;

  Map<String,dynamic>? _sendmail;
  Map<String,dynamic> get sendmail =>_sendmail!;

  Map<String,dynamic>? _verify;
  Map<String,dynamic> get verify =>_verify!;

  Map<String,dynamic>? _reset;
  Map<String,dynamic> get reset =>_reset!;



  //verify forgot password otp
  sendMail({
    required String email,
    required BuildContext context,
  }) async {
    isLoad = true;
    notifyListeners();

    final response = await _api.sentMail(email,context);
    _sendmail=response as Map<String, dynamic>?;
    notifyListeners();

    isLoad=false;
    notifyListeners();
  }

  //verify password otp
  verifyPassOtp({
    required String email,
    required BuildContext context,
    required String code,
  }) async {
    isLoad = true;
    notifyListeners();

    final response = await _api.PassVeri(email,code,context);
    _verify=response as Map<String, dynamic>?;
    notifyListeners();

    isLoad=false;
    notifyListeners();
  }


  //Login
  passReset({
    required String password,
    required BuildContext context, required String email
  }) async {
    isLoad = true;
    notifyListeners();

    final response = await _api.Reset(password, context,email);
    _reset=response;
    isLoad=false;
    notifyListeners();
  }



}