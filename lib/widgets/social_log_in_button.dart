import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';

class SocialLoginButton extends StatelessWidget {
  final ShapeBorder shape;
  final double borderRadius;
  final double elevation;
  final Text buttonText;
  final double height;
  final double width;
  final Color buttonColor;
  final Image buttonImage;
  final VoidCallback onPressed;
  const SocialLoginButton(
      {Key key,
      this.shape,
      this.elevation,
      this.borderRadius,
      this.buttonText,
      this.height,
      this.width,
      this.buttonColor,
      this.buttonImage,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: context.dynamicHeight(0.08),
      // width: context.dynamicWidth(0.85),
      height: height,
      width: width,
      child: MaterialButton(
        disabledColor: Colors.grey,
        elevation: elevation ?? 1,
        shape: shape ??
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 5)),
        color: buttonColor ?? context.theme.accentColor,
        onPressed: onPressed,
        child: buttonText ?? buttonImage,
      ),
    );
  }
}
