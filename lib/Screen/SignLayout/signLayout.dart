import 'package:flutter/material.dart';

class SignLayout extends StatefulWidget {
  final Widget child;
  const SignLayout({super.key, required this.child});

  @override
  State<SignLayout> createState() => _SignLayoutState();
}

class _SignLayoutState extends State<SignLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(30),
          padding: EdgeInsets.all(20),
          //height: double.infinity,
          width: (MediaQuery.of(context).size.height)/(MediaQuery.of(context).size.width)>1 ? (MediaQuery.of(context).size.width)*0.9 : 500,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: widget.child,
          )
        )
      ),
    );
  }
}