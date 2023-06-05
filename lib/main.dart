import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:bio_beacon_mobile/controllers/auth_controller.dart';
import 'package:bio_beacon_mobile/screens/signup.dart';
import 'package:bio_beacon_mobile/screens/signin.dart';
import 'package:bio_beacon_mobile/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await firebaseInitialization.then((value) => {
  //       Get.put(AuthController()),
  //     });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Signin(),
    );
  }
}
