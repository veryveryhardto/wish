import 'package:flutter/material.dart';

class OneContainer extends StatelessWidget {
  Widget? action;
  Widget child;
  OneContainer(this.child ,{super.key, this.action});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(minHeight: 0),
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(30),
            width: (MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height)<4/3 ? (MediaQuery.of(context).size.width)*0.9 : 600,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}