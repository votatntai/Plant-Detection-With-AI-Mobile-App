import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mealime_app/fragments/HDCameraFragment.dart';
import 'package:mealime_app/fragments/MIAFavFragment.dart';
import 'package:mealime_app/fragments/MIAGroceryFragment.dart';
import 'package:mealime_app/fragments/MIAMealPlanFragment.dart';
import 'package:mealime_app/fragments/MIASettingsFragment.dart';
import 'package:mealime_app/main.dart';
import 'package:mealime_app/models/MIADashboardModel.dart';
import 'package:mealime_app/utils/MIAColors.dart';
import 'package:mealime_app/utils/MIADataGenerator.dart';
import 'package:nb_utils/nb_utils.dart';

class MIADashboardScreen extends StatefulWidget {

  const MIADashboardScreen({Key? key}) : super(key: key);


  @override
  _MIADashboardScreenState createState() => _MIADashboardScreenState();
}

class _MIADashboardScreenState extends State<MIADashboardScreen> {
  int selectedTab = 0;

  List<MIADashboardModel> fragmentList = getFragmentsList();

  Widget getFragment() {
    if (selectedTab == 0) {
      return MIAMealPlanFragment();
    } else if (selectedTab == 1) {
      return MIAGroceryFragment();
    } else if (selectedTab == 2) {
      return MIAFavFragment();
    } else if (selectedTab == 3) {
      return MIASettingsFragment();
    } else {
      return HDCameraFragment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: getFragment(),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: boxDecorationDefault(borderRadius: radius(0), color: context.cardColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: fragmentList.map((e) {
              int index = fragmentList.indexOf(e);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(e.image,
                      height: 26,
                      width: 26,
                      fit: BoxFit.cover,
                      color: selectedTab == index
                          ? miaPrimaryColor
                          : appStore.isDarkModeOn
                              ? Colors.white54
                              : miaSecondaryColor),
                  Text(e.tab,
                      style: secondaryTextStyle(
                          color: selectedTab == index
                              ? miaPrimaryColor
                              : appStore.isDarkModeOn
                                  ? Colors.white54
                                  : miaSecondaryColor,
                          size: 12))
                ],
              ).onTap(() {
                selectedTab = index;
                setState(() {});
              });
            }).toList(),
          ),
        ));
  }
}
