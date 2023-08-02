import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components.dart';

class LoginViewMobile extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: deviceHeight / 5.5),
              Image.asset(
                "assets/logo.png",
                fit: BoxFit.contain,
                width: 210.0,
              ),
              SizedBox(height: 30.0),
              EmailAndPasswordFields(),
              SizedBox(height: 30.0),
              RegisterAndLoginButton(),
              SizedBox(height: 30.0),
              GoogleSignin(),
            ],
          ),
        ),
      ),
    );
  }
}
