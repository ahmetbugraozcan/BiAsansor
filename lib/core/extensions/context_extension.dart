import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double dynamicWidth(double value) => MediaQuery.of(this).size.width * value;
  double dynamicHeight(double value) => MediaQuery.of(this).size.height * value;

  ThemeData get theme => Theme.of(this);
}

extension NumberExtension on BuildContext {
  double get veryLowValue => dynamicHeight(0.005);
  double get lowValue => dynamicHeight(0.01);
  double get mediumValue => dynamicHeight(0.03);
  double get highValue => dynamicHeight(0.05);
}

extension PaddingExtension on BuildContext {
  EdgeInsets get paddingAllLow => EdgeInsets.all(lowValue);
  EdgeInsets get paddingAllMedium => EdgeInsets.all(mediumValue);
  EdgeInsets get paddingAllHigh => EdgeInsets.all(highValue);
  EdgeInsets get paddingHorizontalLow =>
      EdgeInsets.symmetric(horizontal: lowValue);
  EdgeInsets get paddingHorizontalMedium =>
      EdgeInsets.symmetric(horizontal: mediumValue);
  EdgeInsets get paddingHorizontalHigh =>
      EdgeInsets.symmetric(horizontal: highValue);
  EdgeInsets get paddingVerticalLow => EdgeInsets.symmetric(vertical: lowValue);
  EdgeInsets get paddingVerticalMedium =>
      EdgeInsets.symmetric(vertical: mediumValue);
  EdgeInsets get paddingVerticalHigh =>
      EdgeInsets.symmetric(vertical: highValue);
}

extension EmptyWidget on BuildContext {
  Widget get emptyWidgetHeight => SizedBox(height: lowValue);
}

extension ColorExtension on BuildContext {
  Color get facebookColor => Color(0xFF334D92);
  Color get googleRedColor => Color(0xFFDB4437);
}
