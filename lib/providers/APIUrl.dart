import 'package:flutter/cupertino.dart';

class APIUrl extends ChangeNotifier {

  static const baseURL = 'https://ef8b-115-74-18-228.ngrok-free.app';

  static getUrl() {
    return baseURL;
  }
}
