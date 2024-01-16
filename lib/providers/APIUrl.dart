import 'package:flutter/cupertino.dart';

class APIUrl extends ChangeNotifier {

  static const baseURL = 'https://6ea9-115-74-17-47.ngrok-free.app';

  static getUrl() {
    return baseURL;
  }
}
