import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/asansor_gif.gif',
              scale: 7,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Uygulama açılırken lütfen bekleyiniz...'),
            ),
          ],
        ),
      ),
    );
  }
}
