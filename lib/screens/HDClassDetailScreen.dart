import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mealime_app/models/HDUserModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../models/HDClassModel.dart';
import 'package:http/http.dart' as http;
import '../providers/UserProvider.dart';
import '../utils/MIAColors.dart';

class HDClassDetailScreen extends StatefulWidget {
  final HDClassModel classModel;

  HDClassDetailScreen({required this.classModel});

  @override
  State<HDClassDetailScreen> createState() => _HDClassDetailScreenState();
}

class _HDClassDetailScreenState extends State<HDClassDetailScreen> {
  HDClassModel? classModel;
  List<HDUserModel> studenList = [];
  bool hasFetchedData = false;
  bool isMember = false;
  final apiUrl = 'https://plantdetectionservice.azurewebsites.net';

  @override
  void initState() {
    super.initState();
    classModel = widget.classModel;
  }

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController(text: classModel!.name ?? '');
    var descriptionController =
        TextEditingController(text: classModel?.description ?? '');
    var createAtController =
        TextEditingController(text: classModel?.createAt ?? '');
    var numberOfMemberController = TextEditingController(
        text: classModel?.numberOfMember.toString() ?? '0');
    var managerController =
        TextEditingController(text: classModel?.manager.email ?? '');
    var codeController = TextEditingController(text: classModel?.code ?? '');

    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    if (studenList.isEmpty && !hasFetchedData) {
      fetchMemberOfClass(apiUrl, classModel?.id);
    }

    for (HDUserModel User in studenList) {
      if (User.id == currentUser?.id) {
        isMember = true;
        break; // Thoát khỏi vòng lặp khi tìm thấy sinh viên trùng ID
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              finish(context);
            },
            child: Text('Cancel',
                style: primaryTextStyle(color: miaPrimaryColor))),
        leadingWidth: 80,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Class Details',
                style: boldTextStyle(color: miaSecondaryColor, size: 20)),
            40.height,
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              // Điều chỉnh khoảng cách từ bên trái màn hình
              child: TextFormField(
                readOnly: true,
                controller: codeController,
                decoration: InputDecoration(
                  labelText: 'Code',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                  //Thêm viền xung quanh TextFormField
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  // Điều chỉnh khoảng cách đỉnh và đáy
                  prefixIcon:
                      Icon(Icons.qr_code), //Thêm biểu tượng trước trường nhập
                ),
              ),
            ),
            20.height,
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              // Điều chỉnh khoảng cách từ bên trái màn hình
              child: TextFormField(
                readOnly: true,
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                  //Thêm viền xung quanh TextFormField
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  // Điều chỉnh khoảng cách đỉnh và đáy
                  prefixIcon:
                      Icon(Icons.class_), //Thêm biểu tượng trước trường nhập
                ),
              ),
            ),
            20.height,
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              // Điều chỉnh khoảng cách từ bên trái màn hình
              child: TextFormField(
                readOnly: true,
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                  //Thêm viền xung quanh TextFormField
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  // Điều chỉnh khoảng cách đỉnh và đáy
                  prefixIcon: Icon(
                      Icons.description), //Thêm biểu tượng trước trường nhập
                ),
              ),
            ),
            20.height,
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              // Điều chỉnh khoảng cách từ bên trái màn hình
              child: TextFormField(
                readOnly: true,
                controller: createAtController,
                decoration: InputDecoration(
                  labelText: 'Create At',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                  //Thêm viền xung quanh TextFormField
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  // Điều chỉnh khoảng cách đỉnh và đáy
                  prefixIcon: Icon(
                      Icons.lock_clock), //Thêm biểu tượng trước trường nhập
                ),
              ),
            ),
            20.height,
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              // Điều chỉnh khoảng cách từ bên trái màn hình
              child: TextFormField(
                readOnly: true,
                controller: numberOfMemberController,
                decoration: InputDecoration(
                  labelText: 'Member',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                  //Thêm viền xung quanh TextFormField
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  // Điều chỉnh khoảng cách đỉnh và đáy
                  prefixIcon:
                      Icon(Icons.person), //Thêm biểu tượng trước trường nhập
                ),
              ),
            ),
            20.height,
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              // Điều chỉnh khoảng cách từ bên trái màn hình
              child: TextFormField(
                readOnly: true,
                controller: managerController,
                decoration: InputDecoration(
                  labelText: 'Manager',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                  //Thêm viền xung quanh TextFormField
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  // Điều chỉnh khoảng cách đỉnh và đáy
                  prefixIcon: Icon(Icons
                      .manage_accounts), //Thêm biểu tượng trước trường nhập
                ),
              ),
            ),
            20.height,
            if (!isMember && hasFetchedData)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                    },
                    child: Text('Enroll Me'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchMemberOfClass(String apiUrl, classId) async {
    Map<String, String> bearerHeaders = {
      'Content-Type': 'application/json-patch+json',
    };

    try {
      final response = await http.get(
          Uri.parse(apiUrl + '/api/classes/$classId/students'),
          headers: bearerHeaders);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);

        final List<dynamic> dataList = jsonMap['data'];

        final List<HDUserModel> userList = dataList.map((json) => HDUserModel.fromJson(json['student'])).toList();

        setState(() {
          studenList = userList;
          hasFetchedData = true;
        });
      } else {
        setState(() {});
      }
    } catch (e) {}
  }
}
