import 'dart:convert';

import 'package:Detection/screens/HDExamScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:Detection/main.dart';
import 'package:Detection/models/HDClassModel.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../providers/APIUrl.dart';
import '../providers/UserProvider.dart';
import '../screens/HDClassDetailScreen.dart';
import '../utils/MIAColors.dart';
import '../utils/MIAWidgets.dart';

class HDGameFragment extends StatefulWidget {
  const HDGameFragment({Key? key}) : super(key: key);

  @override
  State<HDGameFragment> createState() => _HDGameFragmentState();
}

class _HDGameFragmentState extends State<HDGameFragment> {
  bool hasFetchedData = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (!hasFetchedData) {
      hasFetchedData = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: miaFragmentAppBar(context, 'Game', false),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Divider(height: 2, color: Colors.black),
            if (isLoading) // Hiển thị CircularProgressIndicator nếu isLoading là true
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ), //,
              ),
                Padding(
                  padding:
                  EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HDExamScreen()),
                        );
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.resolveWith(
                                (states) => Size(200, 50)),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Điều chỉnh giá trị theo ý muốn
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videogame_asset,
                            color: Colors.black,
                          ),
                          10.width,
                          Text(
                            'Join a game',
                            style: TextStyle(
                              color: Colors.black,
                              // Đặt màu cho văn bản
                              fontSize: 18,
                              // Đặt kích thước của văn bản (tuỳ chọn)
                              fontWeight: FontWeight
                                  .bold, // Đặt độ đậm của văn bản (tuỳ chọn)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ]).paddingSymmetric(horizontal: 16),
        ),
      );
    });
  }

// Future<void> fetchClasses(String apiUrl, String acceessToken) async {
//   setState(() {
//     isLoading = true;
//   });
//   Map<String, String> bearerHeaders = {
//     'Content-Type': 'application/json-patch+json',
//     'Authorization': 'Bearer ${acceessToken}',
//   };
//   try {
//     final response = await http.get(
//         Uri.parse(apiUrl + '/api/classes/student'),
//         headers: bearerHeaders);
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = json.decode(response.body);
//       final HDClassModel responseClass = HDClassModel.fromJson(jsonResponse);
//
//       setState(() {
//         currentClass = responseClass;
//         isLoading = false;
//         hasFetchedData = true;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//         hasFetchedData = true;
//       });
//     }
//   } catch (e) {}
// }
}
