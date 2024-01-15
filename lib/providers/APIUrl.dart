import 'package:flutter/cupertino.dart';

class APIUrl extends ChangeNotifier {

  static const baseURL = 'https://94ce-115-74-31-194.ngrok-free.app';

  static getUrl() {
    return baseURL;
  }
}
