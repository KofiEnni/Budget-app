import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trail/components.dart';

import '../view_model.dart';

bool isLoading = true;

class ExpenseViewMobile extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    double deviceWidth = MediaQuery.of(context).size.width;

    if (isLoading == true) {
      viewModelProvider.expensesStream();
      viewModelProvider.incomesStream();
      isLoading = false;
    }

    return SafeArea(
      child: Scaffold(
        drawer: DrawerEpense(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white, size: 30.0),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Poppins(
            text: "DashBoard",
            size: 20.0,
            color: Colors.white,
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  viewModelProvider.reset();
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 40,
            ),
            Column(
              children: [
                Container(
                  height: 240.0,
                  width: deviceWidth / 1.5,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  child: TotalCalculation(
                    size: 14.0,
                  ),
                )
              ],
            ),
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //add expense
                AddExpense(),
                SizedBox(width: 10.0),
                //add income
                AddIncome()
              ],
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Expense list
                  Column(
                    children: [
                      OpenSans(text: "Expense", size: 15.0),
                      Container(
                        padding: EdgeInsets.all(7.0),
                        height: 210.0,
                        width: 180.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          border: Border.all(width: 1.0, color: Colors.black),
                        ),
                        child: ListView.builder(
                            itemCount: viewModelProvider.expenses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Poppins(
                                      size: 12.0,
                                      text: viewModelProvider
                                          .expenses[index].name),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Poppins(
                                      text: viewModelProvider
                                          .expenses[index].amount,
                                      size: 12.0,
                                    ),
                                  )
                                ],
                              );
                            }),
                      )
                    ],
                  ),
                  //Income list
                  Column(
                    children: [
                      OpenSans(
                        text: "Income",
                        size: 15.0,
                        color: Colors.black,
                      ),
                      Container(
                        padding: EdgeInsets.all(7.0),
                        height: 210,
                        width: 180.0,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        child: ListView.builder(
                            itemCount: viewModelProvider.incomes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Poppins(
                                      size: 12.0,
                                      text: viewModelProvider
                                          .incomes[index].name),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Poppins(
                                      text: viewModelProvider
                                          .incomes[index].amount,
                                      size: 12.0,
                                    ),
                                  )
                                ],
                              );
                            }),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
