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
  bool isTappedAboutUs = false;
  bool isTappedLocations = false;
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
                            // Icon(MaterialCommunityIcons.fire_truck),
                            // Image.asset(
                            //   "assets/asansor_siyah.png",
                            //   scale: 50,
                            // ),
                            Flexible(
                              child: Padding(
                                padding: context.paddingAllLow,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(shipper.name,
                                      style: context.theme.textTheme.headline5
                                          .copyWith(
                                              fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.lowValue),
                          child: Divider(color: Colors.black, height: 1),
                        ),
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
                                    'Çıkabileceği En Yüksek Kat: ' +
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
                                    'Sektöre Giriş Tarihi: ' +
                                        shipper.workExperience.toString(),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.lowValue),
                          child: Divider(
                            color: Colors.black,
                          ),
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
                                      'Tek Taraflı Ücret: ${shipper.shippingPrice},00 ₺',
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.lowValue),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: context.paddingHorizontalLow,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isTappedLocations = !isTappedLocations;
                                print("Basıldı");
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: context.veryLowValue,
                                      bottom: context.veryLowValue),
                                  child: Text(
                                    'Hizmet Bölgeleri',
                                    style: context.theme.textTheme.subtitle1
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: context.theme.primaryColor),
                                  ),
                                ),
                                AnimatedSize(
                                    duration: const Duration(milliseconds: 5),
                                    vsync: this,
                                    child: ListView.builder(
                                        primary: false,
                                        shrinkWrap: true,
                                        //en az 4 gösterelim
                                        itemCount: !isTappedLocations
                                            ? shipper.locations.length <= 4
                                                ? shipper.locations.length
                                                : 4
                                            : shipper.locations.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Wrap(
                                                children: [
                                                  Icon(Icons.location_on),
                                                  Text(
                                                    shipper.locations[index],
                                                    style: context.theme
                                                        .textTheme.subtitle1,
                                                  ),
                                                ],
                                              ),
                                              !isTappedLocations && index == 3
                                                  ? Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons.campaign,
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                        Text("Devamını Gör",
                                                            style: context
                                                                .theme
                                                                .textTheme
                                                                .bodyText1),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                            ],
                                          );
                                        })),
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
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.lowValue),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: context.paddingHorizontalLow,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: Container(
                                  // height: context.dynamicHeight(0.07),
                                  constraints: BoxConstraints(
                                    minHeight: context.dynamicHeight(0.07),
                                  ),
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
                                        : _utils.floorNumber(shipper.rating),
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
                                                : _utils
                                                    .floorNumber(shipper.rating)
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
                                child: TextButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => AllCommentsPage(
                                                comments: shipper.comments,
                                                rating: shipper.rating,
                                                shipperName: shipper.name,
                                              ))),
                                  child: Text(
                                    '${shipper.comments.length} Yorum',
                                    style:
                                        context.theme.textTheme.button.copyWith(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
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
                                      '${shipper.name} Yorumları',
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
                                                    shipperName: shipper.name,
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
                            : Column(
                                children: [
                                  Text(
                                    'Hakkımızda',
                                    style: context.theme.textTheme.headline6,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isTappedAboutUs = !isTappedAboutUs;
                                      });
                                    },
                                    child: Padding(
                                      padding: context.paddingAllLow,
                                      child: AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 1),
                                        vsync: this,
                                        child: isTappedAboutUs
                                            ? Text(
                                                shipper.aboutUsText,
                                                textAlign: TextAlign.center,
                                                style: context
                                                    .theme.textTheme.bodyText2,
                                              )
                                            : shipper.aboutUsText.length <= 60
                                                ? Text(
                                                    shipper.aboutUsText,
                                                    textAlign: TextAlign.center,
                                                    style: context.theme
                                                        .textTheme.bodyText2,
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
                                                          style: context
                                                              .theme
                                                              .textTheme
                                                              .bodyText2
                                                              .copyWith(
                                                                  color: Colors
                                                                          .blue[
                                                                      900]),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                      ),
                                    ),
                                  ),
                                ],
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
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SimpleDialog(
                                            titlePadding: EdgeInsets.fromLTRB(
                                                context.dynamicWidth(0.03),
                                                context.dynamicHeight(0.02),
                                                context.dynamicWidth(0.03),
                                                0.0),
                                            contentPadding:
                                                context.paddingAllMedium,
                                            title: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                    'Fiyata Etki Eden Durumlar')),
                                            children: [
                                              Container(
                                                width: 500,
                                                height: 250,
                                                child: Scrollbar(
                                                  child: ListView(
                                                    children: [
                                                      Text("Fiyatlandırma politikamızda seçtiğiniz sonuçlar doğrultusunda size çıkan uygun sonuçta listelenen asansörlerde ki fiyatlandırma tüm şartların normal bir şekilde olduğu zaman karşınıza çıkan bir fiyat tarifesidir." +
                                                          "Genellikle bu fiyatlandırmalar üzerinden çok fazla oynama olmamaktadır. Ham ücret üzerinden hesaplanan ücretin artması veya azalmasında birden çok değişken yer almaktadır bunlar:\n\n" +
                                                          "-Taşınacak yükün türü ve miktarı\n\n" +
                                                          "-Asansörün kullanım süresi\n\n" +
                                                          "-Taşıma yapılacak binanın şekli, önündeki engelleri vb. faktörler\n\n" +
                                                          "-Taşıma yapılacak adresin uzaklığı ( Şehir merkezindeki bir firmanın ilçeye gitmesi vs.)\n\n" +
                                                          "-Asansörün kullanılacağı taraf sayısı\n\n" +
                                                          "Bu ve bunun gibi birçok sebepten dolayı fiyatlandırma da artış ve azalışlar söz konusu olmaktadır." +
                                                          "Siparişi tamamladıktan sonra size uygun olan firma sizinle iletişime geçecektir."),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                  },
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
