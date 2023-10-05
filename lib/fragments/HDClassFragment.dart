import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mealime_app/components/MIAFavMealComponent.dart';
import 'package:mealime_app/main.dart';
import 'package:mealime_app/models/HDClassModel.dart';
import 'package:mealime_app/screens/MIASingleMealScreen.dart';
import 'package:mealime_app/utils/MIADialogs.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import '../providers/UserProvider.dart';
import '../screens/HDClassDetailScreen.dart';
import '../screens/MIABuildMealScreen.dart';
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
  bool showEnrollInput = false;
  bool hasFetchedData = false;

  PreferredSizeWidget getAppBar() {
    if (miaStore.addedMeals.isEmpty) {
      return AppBar(leading: SizedBox(), elevation: 0);
    } else {
      return miaFragmentAppBar(context, 'Your personalized meal plan', true);
    }
  }

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
    final apiUrl = 'https://plantdetectionservice.azurewebsites.net';
    final userProvider = Provider.of<UserProvider>(context);
    final currenUser = userProvider.currentUser;
    String? accessToken = userProvider.accessToken;

    if (currentClass == null && !hasFetchedData) {
      fetchClasses(apiUrl, accessToken!);
      hasFetchedData = true;
    }

    return Observer(
      builder: (_) => Scaffold(
        appBar: miaFragmentAppBar(context, 'Class', false),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (isLoading) // Hiển thị CircularProgressIndicator nếu isLoading là true
              Center(
                child: CircularProgressIndicator(),
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
                  Text('Nhập mã lớp để enroll:'),
                  TextField(
                    controller: enrollCodeController,
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(currentClass!.manager.avatarUrl),
                    ),
                    title: Text(currentClass!.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${currentClass!.description}'),
                        Text(
                            'Number of students: ${currentClass!.numberOfMember.toString()}'),
                        Text('Manager: ${currentClass!.manager.email}'),
                      ],
                    ),
                  ),
                ),
              )
          ]).paddingSymmetric(horizontal: 16),
        ),
      ),
    );
  }

  Future<void> fetchClasses(String apiUrl, String acceessToken) async {
    setState(() {
      isLoading = true;
    });
    Map<String, String> bearerHeaders = {
      'Content-Type': 'application/json-patch+json',
      'Authorization': 'Bearer ${acceessToken}',
    };

    final response = await http.get(Uri.parse(apiUrl + '/api/classes/student'),
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
  }
}
