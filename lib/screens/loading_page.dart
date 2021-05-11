import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Spacer(
              flex: 3,
            ),
            Expanded(
              flex: 1,
              child: Image.asset(
                'assets/asansor_gif.gif',
                scale: 7,
              ),
            ),
            //BiAsansör-Asansör Kiralama Uygulaması
            Expanded(
              flex: 1,
              child: Text(
                "Uygulama açılırken lütfen bekleyiniz...",
                style: context.theme.textTheme.subtitle1,
              ),
            ),
            Spacer(flex: 2),
            Expanded(
              flex: 1,
              child: Text(
                "BiAsansör-Asansör Kiralamanın En Kolay Yolu",
                textAlign: TextAlign.center,
                style: context.theme.textTheme.headline4
                    .copyWith(color: Colors.black87),
              ),
            ),

            // Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Text('Uygulama açılırken lütfen bekleyiniz...'),
            // ),
          ],
        ),
      ),
    );
  }
}
