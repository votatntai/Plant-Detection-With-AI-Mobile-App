import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:nb_utils/nb_utils.dart';

import '../providers/APIUrl.dart';
import '../utils/MIAColors.dart';
import 'HDViewReSultInClassScreen.dart';
import 'HDViewResultScreen.dart';

class HDViewImageInClassScreen extends StatefulWidget {
  final File? image;
  final String classId;

  HDViewImageInClassScreen({this.image, required this.classId});

  @override
  _HDViewImageInClassScreenState createState() => _HDViewImageInClassScreenState();
}

class _HDViewImageInClassScreenState extends State<HDViewImageInClassScreen> {
  File? _image;

  late String classId;

  final apiUrl = APIUrl.getUrl();

  @override
  void initState() {
    super.initState();
    _image = widget.image;
    classId = widget.classId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: miaPrimaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ).paddingSymmetric(horizontal: 8),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cloud_upload, color: miaPrimaryColor),
            onPressed: () {
              uploadImage();
            },
          ),
        ],
      ),
      body: Center(
        child: _image == null ? Text("Chưa có ảnh") : Image.file(_image!),
      ),
    );
  }

  void uploadImage() async {
    showLoadingDialog(context);
    var request = http.MultipartRequest(
        'POST', Uri.parse(apiUrl + '/api/predictions/classes/${classId}'));
    var path = _image?.path ?? '';
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // Tên trường tệp ảnh trên API
        path, // Xác định loại tệp
      ),
    );
    request.headers['Content-Type'] = 'multipart/form-data';
    var response = await request.send();
    if (response.statusCode == 200) {
      hideLoadingDialog(context);
      var responseBody = await response.stream.bytesToString();
      Map<String, dynamic> data = json.decode(responseBody);
      print(data);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HDViewResultInClassScreen(data: data),
        ),
      );
    } else {
      hideLoadingDialog(context);
      print('Có lỗi xảy ra khi gửi ảnh.');
    }
  }

  Future<void> showLoadingDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Không đóng dialog bằng cách tap ra ngoài
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(), // Hiển thị vòng loading
              SizedBox(width: 20),
              Text('Uploading...'), // Thông báo "Loading"
            ],
          ),
        );
      },
    );
  }

// Hàm để ẩn AlertDialog loading
  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }
}