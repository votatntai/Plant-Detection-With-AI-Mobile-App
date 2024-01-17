import 'package:flutter/cupertino.dart';

class APIUrl extends ChangeNotifier {

  static const baseURL = 'https://7339-171-250-177-41.ngrok-free.app';

  static getUrl() {
    return baseURL;
  }
}
