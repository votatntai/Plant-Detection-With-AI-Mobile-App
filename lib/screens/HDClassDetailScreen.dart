import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/HDClassModel.dart';
import '../utils/MIAColors.dart';

class HDClassDetailScreen extends StatelessWidget {
  final HDClassModel classModel;

  HDClassDetailScreen({required this.classModel});


  @override
  Widget build(BuildContext context) {

    var nameController =
    TextEditingController(text: classModel?.name ?? '');
    var descriptionController =
    TextEditingController(text: classModel?.description ?? '');
    var createAtController =
    TextEditingController(text: classModel?.createAt ?? '');
    var numberOfMemberController =
    TextEditingController(text: classModel?.numberOfMember.toString() ?? '0');
    var managerController =
    TextEditingController(text: classModel?.manager.email ?? '');
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
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                  //Thêm viền xung quanh TextFormField
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  // Điều chỉnh khoảng cách đỉnh và đáy
                  prefixIcon: Icon(Icons
                      .class_), //Thêm biểu tượng trước trường nhập
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
                  prefixIcon: Icon(Icons
                      .lock_clock), //Thêm biểu tượng trước trường nhập
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
                  prefixIcon: Icon(Icons
                      .person), //Thêm biểu tượng trước trường nhập
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
          ],
        ),
      ),
    );
  }

}
