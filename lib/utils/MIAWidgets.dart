import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screens/MIABuildMealScreen.dart';
import '../screens/MIAWelcomeScreen.dart';
import 'MIAColors.dart';

PreferredSizeWidget miaAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios, color: miaPrimaryColor),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MIAWelcomeScreen()), // Thay thế HomePage() bằng trang chính của bạn
        );
      },
    ).paddingSymmetric(horizontal: 8),
    title: TextButton(
      child: Text('Back', style: primaryTextStyle(color: miaPrimaryColor)),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MIAWelcomeScreen()), // Thay thế HomePage() bằng trang chính của bạn
        );
      },
    ),
    elevation: 0,
    titleSpacing: 0,
    leadingWidth: 30,
  );
}

PreferredSizeWidget miaFragmentAppBar(BuildContext context, String name, bool isMealFragment) {
  return AppBar(
    toolbarHeight: 100,
    title: Text(name, style: boldTextStyle(size: 24)).paddingOnly(top: 30, bottom: 20),
    leadingWidth: 0,
    leading: SizedBox(),
    elevation: 0,
    actions: [
      isMealFragment
          ? IconButton(
              icon: Icon(Icons.edit, color: context.iconColor),
              onPressed: () {
                MIABuildMealScreen().launch(context);
              },
            )
          : Offstage(),
    ],
  );
}

void changeStatusColor(Color color) async {
  setStatusBarColor(color);
}
