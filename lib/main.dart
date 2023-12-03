import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:trs_hardware/login/checkmail.dart';
import 'package:trs_hardware/login/regsiter.dart';
import 'package:trs_hardware/main-navigation/dashboard.dart';
import 'package:trs_hardware/main-navigation/home/home.dart';
import 'package:trs_hardware/main-navigation/product/products.dart';
import 'package:trs_hardware/providers/cartprovider.dart';
import 'package:trs_hardware/providers/ordersprovider.dart';
import 'package:trs_hardware/providers/productprovider.dart';
import 'package:trs_hardware/providers/userprovider.dart';
import 'package:trs_hardware/splashscreen.dart';

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




  runApp(
      MultiProvider(
          providers: [

            ChangeNotifierProvider(
              create:(_) => UserProvider(),
            ),

            ChangeNotifierProvider(
              create:(_) => ProductProvider(),
            ),

            ChangeNotifierProvider(
              create:(_) => CartProvider(),
            ),

            ChangeNotifierProvider(
              create:(_) => OrdersProvider(),
            ),
          ],
          child:const MyApp()
      )
  );
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
          fontFamily: 'Gothic'
      ),
      builder: EasyLoading.init(),
      initialRoute:SplashScreen.id,//initial route
      routes: {//routes
        SplashScreen.id:(context)=>const SplashScreen(),
        Login.id:(context)=>const Login(),
        Register.id:(context)=>const Register(),
        Dashboard.id:(context)=>const Dashboard(),
        Products.id:(context)=>const Products(),
        Home.id:(context)=>const Home(),
        CheckMail.id:(context)=>const CheckMail(),
      },


      // home:const Login(),
    );
  }
}


