import 'package:flutter/material.dart';
import 'package:mealime_app/screens/MIADashboardScreen.dart';
import 'package:mealime_app/utils/MIAColors.dart';
import 'package:mealime_app/utils/MIAWidgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class MIASignInScreen extends StatelessWidget {
  const MIASignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: miaAppBar(context),
      body: Stack(
        children: [
          // Hình nền
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Nội dung chính (nút)
          Positioned(
            bottom: 48, // Điều chỉnh vị trí đáy cho nút
            left: 12,
            right: 12,
            child: Container(
              width: double.infinity, // Đặt width là 100%
              height: 70,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final GoogleSignInAccount? googleSignInAccount =
                        await GoogleSignIn().signIn();

                    if (googleSignInAccount != null) {
                      final GoogleSignInAuthentication
                          googleSignInAuthentication =
                          await googleSignInAccount.authentication;
                      final AuthCredential credential =
                          GoogleAuthProvider.credential(
                        accessToken: googleSignInAuthentication.accessToken,
                        idToken: googleSignInAuthentication.idToken,
                      );

                      print(googleSignInAuthentication.idToken);

                      final UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithCredential(credential);

                      final User user = userCredential.user!;
                      print(
                          'Đăng nhập thành công với Google: ${user.displayName}');
                    }
                  } catch (e) {
                    print('Lỗi đăng nhập với Google: $e');
                  }
                },
                icon: Image.asset(
                  './images/google.png',
                  width: 36,
                  height: 36,
                ),
                label: Text('Sign in with Google', style: TextStyle(
                  color: Colors.white, // Đặt màu cho văn bản
                  fontSize: 20, // Đặt kích thước của văn bản (tuỳ chọn)
                  fontWeight: FontWeight.bold, // Đặt độ đậm của văn bản (tuỳ chọn)
                ),),
              ),
            ),
          ),
        ],

        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        // Text('Sign In', style: boldTextStyle(size: 30)),
        // 16.height,
        // 16.height,
        // Text('Email address', style: boldTextStyle()),
        // 8.height,
        // Container(
        //   decoration: BoxDecoration(
        //       color: appStore.isDarkModeOn
        //           ? context.cardColor
        //           : miaContainerSecondaryColor,
        //       borderRadius: radius(8)),
        //   padding: EdgeInsets.symmetric(horizontal: 8),
        //   child: AppTextField(
        //     keyboardType: TextInputType.emailAddress,
        //     cursorColor: miaPrimaryColor,
        //     autoFocus: true,
        //     textFieldType: TextFieldType.EMAIL,
        //     decoration: InputDecoration(border: InputBorder.none),
        //   ),
        // ),
        // 16.height,
        // Text('Password', style: boldTextStyle()),
        // 8.height,
        // Container(
        //   decoration: BoxDecoration(
        //       color: appStore.isDarkModeOn
        //           ? context.cardColor
        //           : miaContainerSecondaryColor,
        //       borderRadius: radius(8)),
        //   padding: EdgeInsets.symmetric(horizontal: 8),
        //   child: AppTextField(
        //     cursorColor: miaPrimaryColor,
        //     autoFocus: true,
        //     textFieldType: TextFieldType.PASSWORD,
        //     decoration: InputDecoration(border: InputBorder.none),
        //   ),
        // ),
        // 30.height,
        // AppButton(
        //   width: context.width() - 32,
        //   color: miaPrimaryColor,
        //   text: 'Done',
        //   textStyle: boldTextStyle(color: white),
        //   onTap: () {
        //     MIADashboardScreen().launch(context);
        //   },
        // ),
        // 16.height,
        // 16.height,
        // RichText(
        //   text: TextSpan(
        //     text: 'By using Mealime you agree to our ',
        //     style: secondaryTextStyle(),
        //     children: const <TextSpan>[
        //       TextSpan(
        //           text: 'Terms',
        //           style: TextStyle(
        //               decoration: TextDecoration.underline,
        //               fontWeight: FontWeight.bold)),
        //     ],
        //   ),
        // ).center(),
        //   ],
        // ).paddingSymmetric(horizontal: 16),
      ),
    );
  }
}
