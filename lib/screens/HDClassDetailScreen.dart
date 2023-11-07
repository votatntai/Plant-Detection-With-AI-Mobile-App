import 'dart:convert';

import 'package:Detection/providers/APIUrl.dart';
import 'package:Detection/screens/HDManageReportScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Detection/models/HDUserModel.dart';
import 'package:intl/intl.dart';
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
  final apiUrl = APIUrl.getUrl();

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
    var nameController =
        TextEditingController(text: classModel!.name ?? 'Name');
    var descriptionController =
        TextEditingController(text: classModel?.description ?? 'Description');
    var createAtController = TextEditingController(
      text: classModel?.createAt != null
          ? DateFormat('dd-MM-yyyy')
              .format(DateTime.parse(classModel!.createAt))
          : 'CreateAt',
    );
    var numberOfMemberController = TextEditingController(
        text: classModel?.numberOfMember.toString() ?? '0');
    var managerController =
        TextEditingController(text: classModel?.manager.email ?? 'Manager');
    var codeController =
        TextEditingController(text: classModel?.code ?? 'Code');

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: miaPrimaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ).paddingSymmetric(horizontal: 8),
        title: Padding(
          padding: EdgeInsets.only(left: 96),
          child: Text(
            'Details',
            style: TextStyle(
              color: Colors.black, // Màu chữ
              fontWeight: FontWeight.bold,
              fontSize: 24.0, // Kích thước chữ
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              20.height,
              Text('Class Details',
                  style: boldTextStyle(color: miaSecondaryColor, size: 20)),
              Divider(height: 2, color: Colors.black),
              20.height,
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
                      prefixIcon: Icon(Icons
                          .description), //Thêm biểu tượng trước trường nhập
                    ),
                    maxLines: null),
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
                    labelText: 'Max Of Members',
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
                      onPressed: () async {
                        try {
                          Map<String, String> bearerHeaders = {
                            'Content-Type': 'application/json-patch+json',
                            'Authorization':
                                'Bearer ${userProvider.accessToken}',
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
              if (hasFetchedData)
                Column(
                  children: [
                    Text(
                      'List Of Members', // Đặt tiêu đề ở đây
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            18, // Cỡ chữ và các thuộc tính khác của văn bản
                      ),
                    ),
                    Divider(height: 2, color: Colors.black),
                    20.height,
                    SingleChildScrollView(
                      child: Column(
                        children: studentList.map((student) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(student.avatarUrl.toString()),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    student.firstName + ' ' + student.lastName),
                                Text(student.email),
                              ],
                            ),
                            subtitle: Text(student.classStatus ?? ''),
                          );
                        }).toList(),
                      ),
                    ),
                    20.height,
                  ],
                ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HDManageReportScreen()),
                    );
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.resolveWith(
                        (states) => Size(200, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            24.0), // Điều chỉnh giá trị theo ý muốn
                      ),
                    ),
                  ),
                  child: Text(
                    'Reports',
                    style: TextStyle(
                      color: Colors.white, // Đặt màu cho văn bản
                      fontSize: 18, // Đặt kích thước của văn bản (tuỳ chọn)
                      fontWeight:
                      FontWeight.bold, // Đặt độ đậm của văn bản (tuỳ chọn)
                    ),
                  ),
                ),
              ),
            ],
          ),
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
