import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';

class ShowFinishedShippingToAdmin extends StatefulWidget {
  String payload;
  ShowFinishedShippingToAdmin({@required this.payload});
  @override
  _ShowFinishedShippingToAdminState createState() =>
      _ShowFinishedShippingToAdminState();
}

class _ShowFinishedShippingToAdminState
    extends State<ShowFinishedShippingToAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kiralama Bilgileri"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                readOnly: true,
                minLines: 1,
                maxLines: 400,
                initialValue: widget.payload.toString(),
                style: context.theme.textTheme.headline6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
