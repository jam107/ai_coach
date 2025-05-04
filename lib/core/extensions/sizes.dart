import 'package:flutter/material.dart';

extension GetSizes on BuildContext {
  double getWidth() => MediaQuery.of(this).size.width;
  double getHeigth() => MediaQuery.of(this).size.height;
}
