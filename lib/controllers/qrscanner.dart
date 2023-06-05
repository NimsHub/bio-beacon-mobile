import 'dart:io';

import 'package:bio_beacon_mobile/controllers/auth_controller.dart';
import 'package:bio_beacon_mobile/services/storeageService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bio_beacon_mobile/screens/home.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRCodeScannerScreen> createState() => _QrscannerState();
}

class _QrscannerState extends State<QRCodeScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

// ${describeEnum(result.format)}   Data: ${result.code}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // if (result != null)
                  // else
                  // Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 105, 2, 71)),
                                minimumSize:
                                    MaterialStateProperty.all(Size(10, 30))),
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null &&
                                    snapshot.data == false)
                                  return Icon(Icons.flash_off_outlined);
                                else
                                  return Icon(Icons.flash_on_outlined);
                              },
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 105, 2, 71)),
                                minimumSize:
                                    MaterialStateProperty.all(Size(10, 30))),
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Icon(Icons.flip_camera_android);
                                } else {
                                  return Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        print(result?.code);
        createSession(result!.code.toString());
        controller.dispose();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => NewSessionMessage()));
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

Future<void> createSession(String deviceId) async {
  StorageService storageService = StorageService();
  const url =
      "http://biobeaconapi-env.eba-xficc75t.us-east-1.elasticbeanstalk.com/api/v1/sessions/create-session"; // Replace with your authentication API endpoint

  final body = jsonEncode({
    "userEmail": "athlete@gmail.com",
    "deviceId": "1",
  });
  // SharedPreferences.setMockInitialValues({});
  // final prefs = await SharedPreferences.getInstance();
  // final token = prefs.getString('authToken');
  final token = await storageService.readSecureData('authToken');
  print(token);
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  final response = await http.post(
    Uri.parse(url),
    body: body,
    headers: headers,
  );
  print(response.body);

  if (response.statusCode == 201) {
  } else {
    throw Exception('Authentication failed'); // Handle authentication failure
  }
}

// Future<void> fetchUserData() async {
//   const url = 'https://example.com/api/user'; // Replace with your API endpoint
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('authToken');

//   final response = await http.get(
//     Uri.parse(url),
//     headers: {
//       'Authorization': 'Bearer $token'
//     }, // Include the token in the Authorization header
//   );

//   // Handle the response
// }
// class QRCodeScannerScreen extends StatefulWidget {
//   @override
//   _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
// }

// class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   bool isScanning = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Code Scanner'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: TextButton(
//                 onPressed: isScanning ? null : _startScanning,
//                 child: Text('Start Scanning'),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       if (scanData != null) {
//         // Handle the scanned QR code result
//         String qrCodeResult = scanData.code.toString();
//         print(qrCodeResult);
//         // Do something with the qrCodeResult
//         // e.g., navigate to another screen, process it, etc.
//       }
//     });
//   }

//   void _startScanning() {
//     setState(() {
//       isScanning = true;
//     });
//     controller?.toggleFlash();
//     controller?.resumeCamera();
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
