import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

import 'package:trail/view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenSans extends StatelessWidget {
  final text;
  final size;
  final color;
  final fontWeight;

  const OpenSans(
      {super.key,
      required this.text,
      required this.size,
      this.color,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(text.toString(),
        style: GoogleFonts.openSans(
          fontSize: size,
          color: color == null ? Colors.black : color,
          fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
        ));
  }
}

DialogBox(BuildContext context, String title) {
  return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            contentPadding: EdgeInsets.all(32.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(width: 2.0, color: Colors.black)),
            title: OpenSans(
              text: title,
              size: 20.0,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: Colors.black,
                child: OpenSans(
                  text: "Okay",
                  size: 20.0,
                  color: Colors.white,
                ),
              )
            ],
          ));
}

class Poppins extends StatelessWidget {
  final fontWeight;
  final size;
  final color;
  final text;

  const Poppins(
      {super.key,
      this.fontWeight,
      required this.size,
      this.color,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text.toString(),
        style: GoogleFonts.poppins(
          fontSize: size,
          color: color == null ? Colors.black : color,
          fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
        ));
  }
}

class TextForm extends StatelessWidget {
  final text;
  final containerWidth;
  final hintText;
  final controller;
  final digitsOnly;
  final validator;

  const TextForm(
      {super.key,
      required this.text,
      required this.containerWidth,
      required this.hintText,
      required this.controller,
      this.digitsOnly,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OpenSans(text: text, size: 13.0),
        SizedBox(
          height: 5.0,
        ),
        SizedBox(
          width: containerWidth,
          child: TextFormField(
            validator: validator,
            inputFormatters: digitsOnly != null
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
            controller: controller,
            decoration: InputDecoration(
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.red)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                hintStyle: GoogleFonts.poppins(fontSize: 13.0),
                hintText: hintText),
          ),
        )
      ],
    );
  }
}

TextEditingController _emailfield = TextEditingController();
TextEditingController _passwordField = TextEditingController();

class EmailAndPasswordFields extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Column(
      children: [
        SizedBox(
          width: 350.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            controller: _emailfield,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
                size: 30.0,
              ),
              hintText: "Email",
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        SizedBox(
          width: 350.0,
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: _passwordField,
            obscureText: viewModelProvider.isObscure,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                prefixIcon: IconButton(
                  onPressed: () {
                    viewModelProvider.toggleObscure();
                  },
                  icon: Icon(
                    viewModelProvider.isObscure
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black,
                    size: 30.0,
                  ),
                ),
                hintStyle: GoogleFonts.openSans(),
                hintText: "Password"),
          ),
        ),
      ],
    );
  }
}

class RegisterAndLoginButton extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50.0,
          width: 150.0,
          child: MaterialButton(
            onPressed: () async {
              await viewModelProvider.createUserWithEmailAndPassword(
                  context, _emailfield.text, _passwordField.text);
            },
            child: OpenSans(
              text: "Register",
              size: 25.0,
              color: Colors.white,
            ),
            splashColor: Colors.grey,
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(width: 20.0),
        Text(
          "Or",
          style: GoogleFonts.pacifico(color: Colors.black, fontSize: 15.0),
        ),
        SizedBox(
          width: 20.0,
        ),
        //Login
        SizedBox(
          height: 50.0,
          width: 150,
          child: MaterialButton(
            child: OpenSans(
              text: "Login",
              size: 25.0,
              color: Colors.white,
            ),
            splashColor: Colors.grey,
            color: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            onPressed: () async {
              viewModelProvider.signInWithEmailAndPassword(
                  context, _emailfield.text, _passwordField.text);
            },
          ),
        ),
        SizedBox(height: 30.0),
      ],
    );
  }
}

class GoogleSignin extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return SignInButton(
      buttonType: ButtonType.google,
      btnColor: Colors.black,
      btnTextColor: Colors.white,
      buttonSize: ButtonSize.medium,
      onPressed: () async {
        if (kIsWeb) {
          await viewModelProvider.signInWithGoogleWeb(context);
        } else
          viewModelProvider.signInWithGoogleMobile(context);
      },
    );
  }
}

class DrawerEpense extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DrawerHeader(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.0, color: Colors.black)),
                child: CircleAvatar(
                  radius: 180.0,
                  backgroundColor: Colors.white,
                  child: Image(
                    height: 100.0,
                    image: AssetImage("assets/logo.png"),
                    filterQuality: FilterQuality.high,
                  ),
                ),
              )),
          SizedBox(height: 10.0),
          MaterialButton(
            onPressed: () async {
              await viewModelProvider.logont();
            },
            child: OpenSans(
              text: "Logout",
              size: 20.0,
              color: Colors.white,
            ),
            color: Colors.black,
            height: 50.0,
            minWidth: 200.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 20.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/instagram.svg",
                  color: Colors.black,
                  width: 35.0,
                ),
                onPressed: () async {
                  await launchUrl(Uri.parse("https://instagram.com/tomcruse"));
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/twitter.svg",
                  color: Colors.black,
                  width: 35.0,
                ),
                onPressed: () async {
                  await launchUrl(Uri.parse("https://twitter.com/tomcruse"));
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

class AddExpense extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return SizedBox(
      height: 40.0,
      width: 155.0,
      child: MaterialButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.add, color: Colors.white, size: 15.0),
            OpenSans(text: "Add expense", size: 14.0, color: Colors.white)
          ],
        ),
        splashColor: Colors.grey,
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () async {
          await viewModelProvider.addExpense(context);
        },
      ),
    );
  }
}

class AddIncome extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return SizedBox(
      height: 45.0,
      width: 160.0,
      child: MaterialButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            OpenSans(text: "Add Income", size: 17.0, color: Colors.white),
          ],
        ),
        onPressed: () async {
          await viewModelProvider.addIncome(context);
        },
        splashColor: Colors.grey,
        color: Colors.black,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}

class TotalCalculation extends HookConsumerWidget {
  final size;

  TotalCalculation({required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Poppins(size: size, text: "Budget left", color: Colors.white),
            Poppins(size: size, text: "Total expense", color: Colors.white),
            Poppins(size: size, text: "Total income", color: Colors.white),
          ],
        ),
        RotatedBox(
          quarterTurns: 1,
          child: Divider(
            thickness: 1,
            indent: 40.0,
            endIndent: 40.0,
            color: Colors.grey,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Poppins(
              size: size,
              color: Colors.white,
              text: "${viewModelProvider.budgetLeft}\$",
            ),
            Poppins(
              size: size,
              color: Colors.white,
              text: "${viewModelProvider.totalExpense}\$",
            ),
            Poppins(
              size: size,
              color: Colors.white,
              text: "${viewModelProvider.totalIncome}\$",
            )
          ],
        )
      ],
    );
  }
}
