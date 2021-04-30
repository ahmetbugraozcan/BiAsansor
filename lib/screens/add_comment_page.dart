import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/model/comment.dart';
import 'package:flutter_biasansor/model/finished_shipping.dart';
import 'package:flutter_biasansor/model/rating.dart';
import 'package:flutter_biasansor/model/shipper.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';

//TODO spam kelimeleri engelleyen sistem yap
class AddCommentPage extends StatefulWidget {
  Shipper shipper;
  FinishedShipping shipping;
  @override
  _AddCommentPageState createState() => _AddCommentPageState();
  AddCommentPage({@required this.shipper, @required this.shipping});
}

class _AddCommentPageState extends State<AddCommentPage> {
  String commentText = '';
  int textLimit = 200;
  double rating;
  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);
    // print(widget.shipping.reservationID);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: context.dynamicWidth(0.94),
        height: context.dynamicHeight(0.063),
        child: MaterialButton(
          onPressed: () async {
            if (rating == null) {
              await PlatformDuyarliAlertDialog(
                title: 'Yorum Gönderilemedi',
                body:
                    'Yorumun gönderilebilmesi için puanlama alanının doldurulması gerekilmektedir.',
                mainButtonText: 'Tamam',
              ).show(context);
            } else {
              var ratingobj = Rating(
                  rating: rating,
                  shipperID: widget.shipper.id,
                  userID: _viewModel.user.userID);
              var comment = Comment(
                  commenterUserName: _viewModel.user.userName,
                  commenterID: _viewModel.user.userID,
                  commentedShipperID: widget.shipper.id,
                  rating: rating,
                  commentDate: Timestamp.now(),
                  commentText: commentText);
              // await Future.wait([_viewModel.addComment(widget.shipper, comment, ratingobj) ]);
              await _viewModel
                  .addComment(widget.shipper, comment, ratingobj,
                      widget.shipping.reservationID)
                  .then((value) {
                if (value) {
                  PlatformDuyarliAlertDialog(
                    willPopScope: false,
                    title: 'Yorum gönderildi',
                    body: 'Yorumunuz başarıyla gönderildi',
                    mainButtonText: 'Tamam',
                    mainButtonOnTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context, true);
                    },
                  ).show(context);
                }
              });
            }
          },
          color: context.theme.buttonColor,
          child: Text(
            'Yorumu Gönder',
            style: context.theme.textTheme.button
                .copyWith(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Asansör Değerlendirmesi'),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading:
                      Image.network(widget.shipper.shippingVehiclePhotoUrl),
                  title: Text(
                    widget.shipper.name,
                    style: context.theme.textTheme.headline6,
                  ),
                  subtitle: Text(widget.shipper.locations.toString()),
                ),
              ),
            ],
          ),
          Divider(thickness: 1.5),
          SizedBox(
            height: context.dynamicHeight(0.01),
          ),
          Center(
              child: Text(
            'Asansörü aşağıdan puanlayabilir ve yorum yazabilirsiniz',
            textAlign: TextAlign.center,
            style: context.theme.textTheme.headline6.copyWith(fontSize: 16),
          )),
          SizedBox(
            height: context.dynamicHeight(0.02),
          ),
          RatingBar(
            onRatingChanged: (rtng) {
              rating = rtng;
            },
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
            halfFilledIcon: Icons.star_half,
            isHalfAllowed: true,
            size: 48,
          ),
          SizedBox(
            height: context.dynamicHeight(0.01),
          ),
          ListTile(
            title: Padding(
              padding: context.paddingVerticalLow,
              child: Text(
                'Yorum Yap',
                style: context.theme.textTheme.subtitle1
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            subtitle: TextFormField(
              onChanged: (value) {
                setState(() {
                  commentText = value;
                });
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(textLimit),
              ],
              minLines: 6,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Hızlı ve başarılı bir hizmet',
                helperText:
                    commentText.length.toString() + '/' + textLimit.toString(),
                border: OutlineInputBorder(),
                fillColor: Colors.red,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.7)),
              ),
            ),
          ),
          SizedBox(
            height: context.dynamicHeight(0.01),
          ),
        ],
      ),
    );
  }
}
