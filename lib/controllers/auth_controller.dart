import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:bio_beacon_mobile/services/storeageService.dart';
import 'package:bio_beacon_mobile/utils/storage_item.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

StorageService storageService = StorageService();

// Example function to perform authentication and store the token
Future<void> authenticateUser(String username, String password) async {
  const url =
      "http://biobeaconapi-env.eba-xficc75t.us-east-1.elasticbeanstalk.com/api/v1/auth/authenticate"; // Replace with your authentication API endpoint

  final body = jsonEncode({
    "email": username,
    "password": password,
  });
  // SharedPreferences.setMockInitialValues({});
  final headers = {'Content-Type': 'application/json'};
  final response =
      await http.post(Uri.parse(url), body: body, headers: headers);
  print(username);
  print(response.statusCode);
  print(response.body);
  print(password);
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    final token = jsonData['token'];
    storageService.writeSecureData(StorageItem('authToken', token));
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('authToken',
    //     token);
    // Store the token in SharedPreferences or any secure storage
    // final auth = prefs.getString('authToken');
    final auth = await storageService.readSecureData('authToken');
    print(auth);
  } else {
    throw Exception('Authentication failed'); // Handle authentication failure
  }
}

// Example function to make an authenticated API request
Future<void> fetchUserData() async {
  const url = 'https://example.com/api/user'; // Replace with your API endpoint
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token'
    }, // Include the token in the Authorization header
  );

  // Handle the response
}

// class AuthController extends GetxController {
class AuthController {
  // static AuthController instance = Get.find();

  // late Rx<User?> firebaseUser;

  // @override
  // void onInit() {
  //   super.onInit();

  //   firebaseUser = Rx<User?>(firebaseAuth.currentUser);

  //   firebaseUser.bindStream(firebaseAuth.userChanges());
  //   ever(firebaseUser, _setInitialScreen);
  // }

  // _setInitialScreen(User? user) {
  //   // if (user == null) {
  //   //   Get.offAll(() => const SignUp());
  //   // } else {
  //   //   Get.offAll(() => const HomeScreen());
  //   // }
  // }

  void register(String email, password) async {
    // try {
    //   await firebaseAuth.createUserWithEmailAndPassword(
    //       email: email, password: password);
    // } catch (firebaseAuthException) {}
  }

  void login(String email, String password) async {
    // try {
    //   await firebaseAuth.signInWithEmailAndPassword(
    //       email: email, password: password);
    // } catch (firebaseAuthException) {}
  }
}
