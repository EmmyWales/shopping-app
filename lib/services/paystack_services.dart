// import 'dart:developer';

// import 'package:flutter/services.dart';
// import 'package:paystack_flutter_sdk/paystack_flutter_sdk.dart';

// class PaystackService {
//   final Paystack _paystack = Paystack();

//   static const String publicKey = 'pk_test_YOUR_PUBLIC_KEY';

//   Future<bool> initialize() async {
//     try {
//       final result = await _paystack.initialize(publicKey, true);

//       if (result) {
//         log('Paystack initialized successfully');
//       } else {
//         log('Paystack initialization failed');
//       }

//       return result;
//     } on PlatformException catch (e) {
//       log('Paystack initialization error: ${e.message}');

//       return false;
//     }
//   }

//   Future<dynamic?> launchPayment(String accessCode) async {
//     try {
//       final response = await _paystack.launch(accessCode);

//       return response;
//     } on PlatformException catch (e) {
//       log('Paystack launch error: ${e.message}');

//       return null;
//     }
//   }
// }
