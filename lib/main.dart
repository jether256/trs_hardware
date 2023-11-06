import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trs_hardware/login/regsiter.dart';
import 'package:trs_hardware/main-navigation/dashboard.dart';
import 'package:trs_hardware/splashscreen.dart';

import 'constants/coloor.dart';
import 'login/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //     options:DefaultFirebaseOptions.currentPlatform
  // );

  ///handles expired certificate issues in flutter but expired in 2021..
  ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

  Provider.debugCheckInvalidValueType=null;




  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRS Hardware',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:Colors.brown),
        useMaterial3: false,
      ),
      initialRoute:SplashScreen.id,//initial route
      routes: {//routes
        SplashScreen.id:(context)=>const SplashScreen(),
        Login.id:(context)=>const Login(),
        Register.id:(context)=>const Register(),
        Dashboard.id:(context)=>const Dashboard(),
      },


      // home:const Login(),
    );
  }
}


