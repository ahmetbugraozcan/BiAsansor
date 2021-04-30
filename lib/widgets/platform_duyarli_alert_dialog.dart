import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_widget.dart';

class PlatformDuyarliAlertDialog extends PlatformDuyarliWidget {
  final String title;
  final String body;
  final String mainButtonText;
  final String cancelButtonText;
  final VoidCallback mainButtonOnTap;
  final VoidCallback cancelButtonOnTap;
  final bool willPopScope;
  PlatformDuyarliAlertDialog(
      {@required this.title,
      @required this.body,
      @required this.mainButtonText,
      this.willPopScope,
      this.mainButtonOnTap,
      this.cancelButtonText,
      this.cancelButtonOnTap});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: buildDialogButtons(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: buildDialogButtons(context),
    );
  }

  List<Widget> buildDialogButtons(BuildContext context) {
    final allButtons = <Widget>[];

    if (Platform.isIOS) {
      if (cancelButtonText != null) {
        allButtons.add(CupertinoDialogAction(
          onPressed: cancelButtonOnTap ??
              () {
                Navigator.pop(context);
              },
          child: Text(cancelButtonText),
        ));
      }
      allButtons.add(CupertinoDialogAction(
        onPressed: mainButtonOnTap ??
            () {
              Navigator.pop(context);
            },
        child: Text(mainButtonText),
      ));
    } else {
      if (cancelButtonText != null) {
        allButtons.add(TextButton(
          onPressed: cancelButtonOnTap ??
              () {
                Navigator.pop(context);
              },
          child: Text(cancelButtonText),
        ));
      }

      allButtons.add(TextButton(
        onPressed: mainButtonOnTap ??
            () {
              Navigator.pop(context);
            },
        child: Text(mainButtonText),
      ));
    }

    return allButtons;
  }

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async => willPopScope ?? true,
                child: this,
              );
            })
        : await showDialog<bool>(
            context: context,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async => willPopScope ?? true,
                child: this,
              );
            },
            barrierDismissible: false);
  }
}
