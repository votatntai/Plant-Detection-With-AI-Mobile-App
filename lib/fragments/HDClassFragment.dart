import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:Detection/main.dart';
import 'package:Detection/models/HDClassModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/APIUrl.dart';
import '../providers/UserProvider.dart';
import '../screens/HDClassDetailScreen.dart';
import '../utils/MIAColors.dart';
import '../utils/MIAWidgets.dart';

class HDClassFragment extends StatefulWidget {
  const HDClassFragment({Key? key}) : super(key: key);

  @override
  State<HDClassFragment> createState() => _HDClassFragmentState();
}

class _HDClassFragmentState extends State<HDClassFragment> {
  HDClassModel? currentClass;
  TextEditingController enrollCodeController = TextEditingController();
  bool isLoading = false;
  bool classNotFound = false;
  bool showEnrollInput = false;
  bool hasFetchedData = false;

  @override
  void initState() {
    changeStatusColor(appStore.scaffoldBackground!);
    super.initState();
  }

  void handleEnrollButtonPress() {
    setState(() {
      showEnrollInput = true;
    });
  }

  void handleContainerTap(HDClassModel classModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HDClassDetailScreen(classModel: classModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final apiUrl = APIUrl.getUrl();
    final userProvider = Provider.of<UserProvider>(context);
    String? accessToken = userProvider.accessToken;

    if (currentClass == null && !hasFetchedData) {
      fetchClasses(apiUrl, accessToken!);
      hasFetchedData = true;
    }

    return Observer(builder: (context) {
      return Scaffold(
        appBar: miaFragmentAppBar(context, 'Class', false),
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
            if (!isLoading && currentClass == null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('You have not enrolled any class'),
                    ElevatedButton(
                      onPressed: handleEnrollButtonPress,
                      child: Text('Enroll Class'),
                    ),
                  ],
                ),
              ),
            if (!isLoading &&
                showEnrollInput ==
                    true) // Hiển thị mục nhập mã lớp nếu currentClass không null
              Column(
                children: [
                  Text('Enter class code:'),
                  TextField(
                    controller: enrollCodeController,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      findClassByCode(apiUrl, enrollCodeController.text);
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            if (!isLoading && currentClass != null)
              GestureDetector(
                onTap: () => handleContainerTap(currentClass as HDClassModel),
                // Hiển thị mục nhập mã lớp nếu currentClass không null
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text('${currentClass!.code}-' + currentClass!.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentClass!.description.length > 35
                              ? '${currentClass!.description.substring(0, 35)}...'
                              : '${currentClass!.description}',
                        ),
                        Text(
                            'Number of students: ${currentClass!.numberOfMember.toString()}'),
                        Row(
                          children: [
                            Text('Manager: '),
                            Container(
                              height: 20,
                              width: 20,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    currentClass!.manager.avatarUrl),
                              ),
                            ),
                            Text(
                              currentClass!.manager.email.length > 25
                                  ? '${currentClass!.manager.email.substring(0, 25)}...'
                                  : '${currentClass!.manager.email}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (classNotFound && currentClass == null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Class not found',
                        style:
                            boldTextStyle(color: miaSecondaryColor, size: 20)),
                  ],
                ),
              ),
          ]).paddingSymmetric(horizontal: 16),
        ),
      );
    });
  }

  Future<void> fetchClasses(String apiUrl, String acceessToken) async {
    setState(() {
      isLoading = true;
    });
    Map<String, String> bearerHeaders = {
      'Content-Type': 'application/json-patch+json',
      'Authorization': 'Bearer ${acceessToken}',
    };
    try {
      final response = await http.get(
          Uri.parse(apiUrl + '/api/classes/student'),
          headers: bearerHeaders);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final HDClassModel responseClass = HDClassModel.fromJson(jsonResponse);

        setState(() {
          currentClass = responseClass;
          isLoading = false;
          hasFetchedData = true;
        });
      } else {
        setState(() {
          isLoading = false;
          hasFetchedData = true;
        });
      }
    } catch (e) {}
  }

  Future<void> findClassByCode(String apiUrl, String code) async {
    setState(() {
      isLoading = true;
    });
    Map<String, String> bearerHeaders = {
      'Content-Type': 'application/json-patch+json',
    };

    try {
      final response = await http.get(
          Uri.parse(apiUrl + '/api/classes/code/${code}'),
          headers: bearerHeaders);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final HDClassModel responseClass = HDClassModel.fromJson(jsonResponse);

        setState(() {
          currentClass = responseClass;
          isLoading = false;
          classNotFound = false;
        });
      } else {
        setState(() {
          currentClass = null;
          isLoading = false;
          classNotFound = true;
        });
      }
    } catch (e) {}
  }
}
