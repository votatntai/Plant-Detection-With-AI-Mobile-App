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
  List<HDUserModel> studentList = [];
  bool hasFetchedData = false;
  bool isMember = false;
  final apiUrl = 'https://plantdetectionservice.azurewebsites.net';

  @override
  void initState() {
    super.initState();
    classModel = widget.classModel;
    if (!hasFetchedData) {
      fetchMemberOfClass(apiUrl, classModel?.id);
    }
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

    for (HDUserModel User in studentList) {
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
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
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
                      prefixIcon: Icon(
                          Icons.person), //Thêm biểu tượng trước trường nhập
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  color: Colors.green,// Biểu tượng hình con mắt
                  onPressed: () {
                    _showMembersDialog(context, studentList);
                  },
                ),
              ],
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
                    onPressed: () async {
                      try {
                        Map<String, String> bearerHeaders = {
                          'Content-Type': 'application/json-patch+json',
                          'Authorization': 'Bearer ${userProvider.accessToken}',
                        };
                        final queryParameters = {
                          'classId': '${classModel?.id}',
                        };
                        final response = await http.post(
                            Uri.parse(apiUrl + '/api/classes/request-to-join')
                                .replace(queryParameters: {
                              'classId': classModel?.id,
                            }),
                            headers: bearerHeaders);
                        if (response.statusCode == 200) {
                          setState(() {
                            isMember = true;
                            hasFetchedData = false;
                            _showRequestSuccessDialog(context);
                          });
                        } else {}
                      } catch (e) {}
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
    if (!studentList.isEmpty) {
      studentList = [];
    }
    try {
      Map<String, String> bearerHeaders = {
        'Content-Type': 'application/json-patch+json',
      };

      final response = await http.get(
          Uri.parse(apiUrl + '/api/classes/$classId/students'),
          headers: bearerHeaders);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final List<dynamic> dataList = jsonMap['data'];
        List<HDUserModel> userList = [];
        dataList.forEach((userData) {
          final studentData = userData['student'];
          HDUserModel user = HDUserModel.fromJson(studentData);
          user.classStatus = userData['status'];
          userList.add(user);
        });
        setState(() {
          studentList = userList;
          hasFetchedData = true;
        });
      } else {
        setState(() {});
      }
    } catch (e) {}
  }

  void _showMembersDialog(BuildContext context, List<HDUserModel> studentList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('List of member'),
          content: SingleChildScrollView(
            child: Column(
              children: studentList.map((student) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(student.avatarUrl.toString()),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.firstName+ ' ' + student.lastName),
                      Text(student.email),
                    ],
                  ),
                  subtitle: Text(student.classStatus ?? ''),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  void _showRequestSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Request to join success. Pending Approval'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng thông báo popup
              },
            ),
          ],
        );
      },
    );
  }
}
