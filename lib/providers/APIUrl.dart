import 'package:flutter/cupertino.dart';

class APIUrl extends ChangeNotifier {

  static const baseURL = 'https://c5a6-115-74-17-47.ngrok-free.app';

  static getUrl() {
    return baseURL;
  }
}
