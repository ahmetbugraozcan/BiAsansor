import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/locator.dart';
import 'package:flutter_biasansor/model/order.dart';
import 'package:flutter_biasansor/model/shipper.dart';

import 'package:flutter_biasansor/screens/all_comments_page.dart';
import 'package:flutter_biasansor/screens/rental_finish_page.dart';
import 'package:flutter_biasansor/utils.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';

//TODO yuvarlamaları değiştir
class ShipperDetailPage extends StatefulWidget {
  String shipperID;
  String shipperName;
  Order order;
  ShipperDetailPage(
      {@required this.shipperID, this.shipperName, @required this.order});
  @override
  _ShipperDetailPageState createState() => _ShipperDetailPageState();
}

class _ShipperDetailPageState extends State<ShipperDetailPage>
    with TickerProviderStateMixin {
  String hakkimizda =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent a fringilla ligula. Nulla facilisi. Sed enim risus, lobortis at tortor id, malesuada fermentum erat. Ut eget lectus non neque rhoncus ornare. Aenean vestibulum dui sollicitudin scelerisque congue. Suspendisse potenti. Sed consectetur aliquet metus eget condimentum.';
  bool isTapped = false;
  Shipper shipper;
  var rating = 0.0;
  final _utils = locator<Utils>();
  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bi Asansör - Firma Detay Sayfası'),
      ),
      body: FutureBuilder(
          future: _viewModel.getShipperDetails(widget.shipperID),
          builder: (context, asyncsnapshot) {
            if (asyncsnapshot.hasData) {
              shipper = asyncsnapshot.data;
              _utils.calculatePrice(shipper, widget.order);
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          height: context.dynamicHeight(0.32),
                          width: context.dynamicWidth(1),
                          child: Image.network(
                            shipper.shippingVehiclePhotoUrl,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MaterialCommunityIcons.fire_truck),
                            Padding(
                              padding: context.paddingAllLow,
                              child: Align(
                                alignment: Alignment.center,
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) =>
                                      RadialGradient(
                                    radius: 4,
                                    center: Alignment.topLeft,
                                    colors: [
                                      Colors.orangeAccent,
                                      Colors.deepOrange
                                    ],
                                    tileMode: TileMode.mirror,
                                  ).createShader(bounds),
                                  child: Text(shipper.name,
                                      style: context.theme.textTheme.headline5
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.black),
                        Padding(
                          padding: context.paddingHorizontalLow,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  IconButton(
                                      icon: Icon(
                                          MaterialCommunityIcons.home_modern),
                                      onPressed: () {}),
                                  Text(
                                    'Çıkabileceği En Yüksek Kat : ' +
                                        shipper.maxFloor.toString() +
                                        ' Kat',
                                    style: context.theme.textTheme.subtitle2
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                  )
                                ],
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  IconButton(
                                      icon: Icon(MaterialIcons.work),
                                      onPressed: () {}),
                                  Text(
                                    'Sektördeki Tecrübesi : ' +
                                        shipper.workExperience.toString() +
                                        ' Yıl',
                                    style: context.theme.textTheme.subtitle2
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Padding(
                          padding: context.paddingHorizontalLow,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Tek Taraflı Ücret : ${shipper.shippingPrice},00 ₺',
                                      style: context.theme.textTheme.subtitle1
                                          .copyWith(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                    ),
                                    Text(
                                      'Toplam (${widget.order.transportationCount} Taşıma)',
                                      style: context.theme.textTheme.bodyText2
                                          .copyWith(
                                              fontSize: 12,
                                              color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: context.paddingHorizontalMedium,
                                child: Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                padding: context.paddingAllLow,
                                height: context.dynamicHeight(0.05),
                                decoration: BoxDecoration(
                                    color: Color(0xFF3ab53a),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    shipper.displayingShippingPrice.toString() +
                                        ',00 ₺',
                                    style: context.theme.textTheme.headline6
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Padding(
                          padding: context.paddingHorizontalLow,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hizmet Bölgeleri',
                                style: context.theme.textTheme.subtitle1
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: shipper.locations.length,
                                  itemBuilder: (context, index) {
                                    return Wrap(
                                      children: [
                                        Icon(Icons.location_on),
                                        Text(
                                          shipper.locations[index],
                                          style:
                                              context.theme.textTheme.subtitle1,
                                        ),
                                      ],
                                    );
                                  })
                              // Wrap(
                              //   children: [
                              //     Icon(Icons.location_on),
                              //     Text(
                              //       _utils.printLocations(shipper.locations),
                              //       style: context.theme.textTheme.subtitle1,
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Padding(
                          padding: context.paddingHorizontalLow,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: Container(
                                  height: context.dynamicHeight(0.07),
                                  width: context.dynamicWidth(0.25),
                                  decoration: BoxDecoration(
                                      color: context.theme.primaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(shipper.name,
                                        textAlign: TextAlign.center,
                                        style: context.theme.textTheme.bodyText1
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: context.dynamicHeight(0.05),
                                color: Colors.grey,
                              ),
                              Row(
                                children: [
                                  RatingBar.readOnly(
                                    isHalfAllowed: true,
                                    halfFilledIcon: Icons.star_half_outlined,
                                    initialRating: shipper.rating.isNaN
                                        ? 0
                                        : shipper.rating,
                                    size: 20,
                                    filledIcon: Icons.star,
                                    emptyIcon: Icons.star_border,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: context.theme.primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14))),
                                    width: context.dynamicWidth(0.10),
                                    height: context.dynamicHeight(0.045),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                            shipper.rating.isNaN
                                                ? '0.0'
                                                : shipper.rating
                                                    .floorToDouble()
                                                    .toString(),
                                            style: context
                                                .theme.textTheme.bodyText2
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w900))),
                                  ),
                                ],
                              ),
                              Flexible(
                                child: Text(
                                  '${shipper.comments.length} Yorum',
                                  style:
                                      context.theme.textTheme.button.copyWith(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: context.paddingHorizontalLow,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Hizmet Değerlendirmeleri',
                                      style: context.theme.textTheme.bodyText2
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  AllCommentsPage(
                                                    comments: shipper.comments,
                                                    rating: shipper.rating,
                                                  ))),
                                      child: Text(
                                          'Tümünü Gör (${shipper.comments.length})'),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.black,
                              ),
                              Flexible(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: shipper.comments.length < 5
                                        ? shipper.comments.length
                                        : 5,
                                    itemBuilder: (context, index) {
                                      var comment = shipper.comments[index];
                                      return Padding(
                                        padding: context.paddingHorizontalLow,
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: context
                                                                .veryLowValue),
                                                    child: Row(
                                                      children: [
                                                        RatingBar.readOnly(
                                                          size: 17,
                                                          filledIcon:
                                                              Icons.star,
                                                          emptyIcon:
                                                              Icons.star_border,
                                                          halfFilledIcon: Icons
                                                              .star_half_outlined,
                                                          initialRating:
                                                              comment.rating,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          comment.commenterUserName +
                                                              ' ',
                                                          style: context
                                                              .theme
                                                              .textTheme
                                                              .subtitle2,
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                            _utils.printDate(comment
                                                                    .commentDate
                                                                    .toDate()) +
                                                                ' | ' +
                                                                _utils.printTime(TimeOfDay(
                                                                    hour: comment
                                                                        .commentDate
                                                                        .toDate()
                                                                        .hour,
                                                                    minute: comment
                                                                        .commentDate
                                                                        .toDate()
                                                                        .minute)),
                                                            style: context
                                                                .theme
                                                                .textTheme
                                                                .caption),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: context
                                                        .paddingVerticalLow,
                                                    child: Text(
                                                      comment.commentText,
                                                      // style: context.theme.textTheme
                                                      //     .subtitle1,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: context.dynamicHeight(0.01),
                        ),
                        shipper.aboutUsText.isEmpty
                            ? SizedBox()
                            : Card(
                                child: Column(
                                  children: [
                                    Text(
                                      'Hakkımızda',
                                      style: context.theme.textTheme.headline6,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isTapped = !isTapped;
                                        });
                                      },
                                      child: Padding(
                                        padding: context.paddingAllLow,
                                        child: AnimatedSize(
                                          duration:
                                              const Duration(milliseconds: 1),
                                          vsync: this,
                                          child: isTapped
                                              ? Text(
                                                  shipper.aboutUsText,
                                                  textAlign: TextAlign.center,
                                                  style: context.theme.textTheme
                                                      .bodyText2,
                                                )
                                              : RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: shipper
                                                            .aboutUsText
                                                            .substring(
                                                                0,
                                                                (shipper.aboutUsText
                                                                            .length /
                                                                        3)
                                                                    .round()),
                                                        style: context
                                                            .theme
                                                            .textTheme
                                                            .bodyText2,
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            ' ...devamını oku',
                                                        style: context.theme
                                                            .textTheme.bodyText2
                                                            .copyWith(
                                                                color: Colors
                                                                    .blue[900]),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                        // Divider(
                        //   color: Colors.black,
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: context.dynamicHeight(0.07),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 10,
                            child: SizedBox(
                              height: double.infinity,
                              child: MaterialButton(
                                  color: Color(0xFF128021),
                                  onPressed: () {},
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: context.lowValue),
                                      child: Column(
                                        children: [
                                          Text('Detaylar',
                                              style: context
                                                  .theme.textTheme.button
                                                  .copyWith(
                                                color: Colors.white,
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.underline,
                                              )),
                                          Flexible(
                                            child: Text(
                                                shipper.displayingShippingPrice
                                                        .toString() +
                                                    ',00 ₺',
                                                style: context
                                                    .theme.textTheme.button
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            )),
                        Expanded(
                            flex: 13,
                            child: SizedBox(
                              height: double.infinity,
                              child: MaterialButton(
                                color: Color(0xFF3ab53a),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              RentalFinishPage(
                                                price: shipper
                                                    .displayingShippingPrice,
                                                shipper: shipper,
                                                order: widget.order,
                                              )));
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'Kiralamayı Tamamla ',
                                          style: context.theme.textTheme.button
                                              .copyWith(
                                            color: Colors.white,
                                            fontSize: 18,
                                          )),
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
