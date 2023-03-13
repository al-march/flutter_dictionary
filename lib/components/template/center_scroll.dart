import 'package:flutter/material.dart';

class CenterScroll extends StatelessWidget {
  const CenterScroll({super.key, this.child, this.padding});

  final Widget? child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [child ?? const SizedBox()],
        ),
      ),
    );
  }
}
