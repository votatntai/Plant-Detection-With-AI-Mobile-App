import 'package:flutter/cupertino.dart';

class APIUrl extends ChangeNotifier {

  static const baseURL = 'https://89fd-171-232-7-224.ngrok-free.app';

  static getUrl() {
    return baseURL;
  }
}