import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trail/view_model.dart';
import 'package:trail/web/expense_view_web.dart';
import 'package:trail/web/login_view_web.dart';

import 'mobile/expense_view_mobile.dart';
import 'mobile/login_view_mobile.dart';

class ResponsiveHandler extends HookConsumerWidget {
  const ResponsiveHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final viewModelProvier = ref.watch(viewModel);
    // viewModelProvier.isLoggedIn();
    final _authState = ref.watch(authStateProvider);
    return _authState.when(
        data: (data) {
          if (data != null) {
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return ExpenseViewWeb();
                } else {
                  return ExpenseViewMobile();
                }
              },
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return LoginViewWeb();
              } else {
                return LoginViewMobile();
              }
            },
          );
        },
        error: (e, trace) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return LoginViewWeb();
              } else {
                return LoginViewMobile();
              }
            },
          );
        },
        loading: () => LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return LoginViewWeb();
                } else {
                  return LoginViewMobile();
                }
              },
            ));

    // if (viewModelProvier.isSignedIn == true) {
    //   return LayoutBuilder(
    //     builder: (context, constraints) {
    //       if (constraints.maxWidth > 600) {
    //         return ExpenseViewWeb();
    //       } else {
    //         return ExpenseViewMobile();
    //       }
    //     },
    //   );
    // } else {
    //   return LayoutBuilder(
    //     builder: (context, constraints) {
    //       if (constraints.maxWidth > 600) {
    //         return LoginViewWeb();
    //       } else {
    //         return LoginViewMobile();
    //       }
    //     },
    //   );
    // }
  }
}
