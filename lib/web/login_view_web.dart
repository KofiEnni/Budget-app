import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components.dart';

class LoginViewWeb extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/login_image.png", width: deviceWidth / 5.5),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: deviceHeight / 5.5),
                  Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                    width: 200.0,
                  ),
                  SizedBox(height: 40.0),
                  EmailAndPasswordFields(),
                  SizedBox(height: 30.0),

                  //login & Register
                  RegisterAndLoginButton(),

                  SizedBox(height: 30.0),
                  GoogleSignin()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
