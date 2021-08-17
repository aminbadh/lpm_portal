import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String body;

  ErrorText(this.body);

  @override
  Widget build(BuildContext context) {
    return Text(
      body,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyText2.copyWith(color: Theme.of(context).errorColor),
    );
  }
}
