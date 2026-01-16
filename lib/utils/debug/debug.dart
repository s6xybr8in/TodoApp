import 'package:flutter/foundation.dart';
//kDebugMode = true;
void kPrint(String message) {
  if(kDebugMode) {
    debugPrint(message);
  }
}