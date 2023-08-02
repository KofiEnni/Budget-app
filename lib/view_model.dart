import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:trail/components.dart';

import 'models.dart';

final viewModel =
    ChangeNotifierProvider.autoDispose<ViewModel>((reef) => ViewModel());
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(viewModel).authStateChange;
});

class ViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  Stream<User?> get authStateChange => _auth.authStateChanges();
  List<Models> expenses = [];
  List<Models> incomes = [];

  var totalExpense = 0;
  var totalIncome = 0;
  int budgetLeft = 0;

  // bool isSignedIn = false;
  bool isObscure = true;
  var logger = Logger();

  //checking signin
  // Future<void> isLoggedIn() async {
  //   await _auth.authStateChanges().listen(
  //     (User? user) {
  //       if (user == null) {
  //         isSignedIn = false;
  //       } else {
  //         isSignedIn = true;
  //       }
  //     },
  //   );
  //   notifyListeners();
  // }

  toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  void calculate() {
    for (int i = 0; i < expenses.length; i++) {
      totalExpense = totalExpense + int.parse(expenses[i].amount);
    }
    for (int i = 0; i < incomes.length; i++) {
      totalIncome = totalIncome + int.parse(incomes[i].amount);
    }
    budgetLeft = totalIncome - totalExpense;
    notifyListeners();
  }

//Authentication
  Future<void> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => logger.d("Registration.successful"))
        .onError((error, stackTrace) {
      logger.d("Registration error $error");
      DialogBox(context, error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    });
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => logger.d("Login Successful"))
        .onError((error, stackTrace) {
      logger.d("Login erro $error");
      DialogBox(context, error.toString().replaceAll(RegExp('\\[.*?\\'), ''));
    });
  }

  Future<void> signInWithGoogleWeb(context) async {
    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
    await _auth.signInWithPopup(googleAuthProvider).onError(
        (error, stackTrace) => DialogBox(
            context, error.toString().replaceAll(RegExp('\\[.*?\\]'), '')));
    logger
        .d("Current user is not empty = ${_auth.currentUser!.uid.isNotEmpty}");
  }

  Future<void> signInWithGoogleMobile(context) async {
    final GoogleSignInAccount? googleuser = await GoogleSignIn()
        .signIn()
        .onError((error, stackTrace) => DialogBox(
            context, error.toString().replaceAll(RegExp('\\[.*?\\]'), '')));
    final GoogleSignInAuthentication? googleAuth =
        await googleuser?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    await _auth
        .signInWithCredential(credential)
        .then((value) => {logger.d("Google Sign in success")})
        .onError((error, stackTrace) => {
              logger.d("Google sign in erro $error "),
              DialogBox(
                  context, error.toString().replaceAll(RegExp('\\[.*?\\'), ''))
            });

    // logger
    //     .d("Current user is not empty = ${_auth.currentUser!.uid.isNotEmpty}");
  }

  //Logout
  Future<void> logont() async {
    await _auth.signOut();
  }

  //Database
  Future addExpense(BuildContext context) async {
    final formkey = GlobalKey<FormState>();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();
    return await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              contentPadding: EdgeInsets.all(32.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextForm(
                        text: "Name",
                        containerWidth: 100.0,
                        hintText: "Name",
                        controller: controllerName,
                        validator: (text) {
                          if (text.toString().isEmpty) {
                            return "Required";
                          }
                        }),
                    SizedBox(width: 10.0),
                    TextForm(
                        text: "Amount",
                        containerWidth: 100.0,
                        hintText: "Amount",
                        controller: controllerAmount,
                        validator: (text) {
                          if (text.toString().isEmpty) {
                            return "required";
                          }
                        })
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      await userCollection
                          .doc(_auth.currentUser!.uid)
                          .collection("expenses")
                          .add({
                        "name": controllerName.text,
                        "amount": controllerAmount.text
                      }).onError((error, stackTrace) {
                        logger.d("add expense error = $error");
                        return DialogBox(context, error.toString());
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: OpenSans(
                    text: "Save",
                    size: 15.0,
                    color: Colors.white,
                  ),
                  splashColor: Colors.grey,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                )
              ],
            ));
  }

  Future addIncome(BuildContext context) async {
    final formkey = GlobalKey<FormState>();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();
    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: EdgeInsets.all(32.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(width: 1.0, color: Colors.black)),
        title: Form(
          key: formkey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextForm(
                  text: "Name",
                  containerWidth: 130.0,
                  hintText: "Name",
                  controller: controllerName,
                  validator: (text) {
                    if (text.toString().isEmpty) {
                      return "required";
                    }
                  }),
              SizedBox(
                width: 10.0,
              ),
              TextForm(
                  text: "Amount",
                  containerWidth: 100.0,
                  hintText: "Amount",
                  controller: controllerAmount,
                  digitsOnly: true,
                  validator: (text) {
                    if (text.toString().isEmpty) {
                      return "Required";
                    }
                  })
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              if (formkey.currentState!.validate()) {
                await userCollection
                    .doc(_auth.currentUser!.uid)
                    .collection("incomes")
                    .add({
                  "name": controllerName.text,
                  "amount": controllerAmount.text
                }).then((value) {
                  logger.d("income added");
                }).onError((error, stackTrace) {
                  logger.d("add income error = $error");
                  return DialogBox(context, error.toString());
                });
                Navigator.pop(context);
              }
            },
            child: OpenSans(
              text: "Save",
              size: 15.0,
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Colors.black,
            splashColor: Colors.grey,
          )
        ],
      ),
    );
  }

  void expensesStream() async {
    await for (var snapshot in userCollection
        .doc(_auth.currentUser!.uid)
        .collection("expenses")
        .snapshots()) {
      expenses = [];
      snapshot.docs.forEach((element) {
        expenses.add(Models.fromJson(element.data()));
      });
      notifyListeners();
      // expensesAmount = [];
      // expensesName = [];
      // for (var expense in snapshot.docs) {
      //   expensesName.add(expense.data()['name']);
      //   expensesAmount.add(expense.data()['amount']);
      //   notifyListeners();
      // }
      calculate();
    }
  }

  void incomesStream() async {
    await for (var snapshot in userCollection
        .doc(_auth.currentUser!.uid)
        .collection("incomes")
        .snapshots()) {
      snapshot.docs.forEach((element) {
        incomes.add(Models.fromJson(element.data()));
      });
      notifyListeners();
      //  incomesAmount = [];
      //  incomesName = [];
      //  for (var incomes in snapshot.docs) {
      //    incomesName.add(incomes.data()['name']);
      //   incomesAmount.add(incomes.data()['amount']);
      //   notifyListeners();
      // }
      calculate();
    }
  }

  Future<void> reset() async {
    await userCollection
        .doc(_auth.currentUser!.uid)
        .collection("expenses")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    await userCollection
        .doc(_auth.currentUser!.uid)
        .collection("incomes")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
