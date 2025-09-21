import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish/Screen/Widget/appBar.dart';

import '../Provider/UIProvider.dart';

class OneContainer extends StatelessWidget {
  Widget? action;
  Widget child;
  OneContainer(this.child ,{super.key, this.action});

  @override
  Widget build(BuildContext context) {
    UIProvider ui = Provider.of<UIProvider>(context);
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3 ? (MediaQuery.of(context).size.width)*0.9 : 600,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: child,
        ),
      ),
    );
  }
}