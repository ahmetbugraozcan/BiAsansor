import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/model/order.dart';
import 'package:flutter_biasansor/model/shipper_mini.dart';
import 'package:flutter_biasansor/screens/rental_finish_page.dart';
import 'package:flutter_biasansor/screens/shipper_detail_page.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';

// ignore: must_be_immutable
class SearchResultsPage extends StatefulWidget {
  Order order;
  // List<ShipperMini> shippers;

  // SearchResultsPage({@required this.shippers, @required this.order});
  SearchResultsPage({@required this.order});
  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}
//TODO Rating 2.5 olsa bile 2.0 olarak görünüyor onu düzelt detail pagede de aynısı var
//TODO değerler contexte göre ayarlanacak

class _SearchResultsPageState extends State<SearchResultsPage> {
  Widget initialFilterValue;
  Widget filterText = Text('Gelişmiş Sıralama');
  Widget ascendingText = Text('Fiyata Göre (Önce En Düşük)');
  Widget descendingText = Text('Fiyata Göre (Önce En Yüksek)');
  Widget starPointText = Text('Değerlendirme Puanı');
  Widget experienceText = Text('Sektördeki Tecrübe');
  // Icon initialFilterIcon = Icon(MaterialCommunityIcons.signal_cellular_outline);
  Icon initialFilterIcon;
  Icon ascendingIcon = Icon(MaterialCommunityIcons.sort_ascending);
  Icon descendingIcon = Icon(MaterialCommunityIcons.sort_descending);
  Icon starIcon = Icon(FontAwesome.star_half_full);
  Icon experienceIcon = Icon(MaterialIcons.work);
  bool isPopupMenuLoading = false;
  List<ShipperMini> shipperList;
  var order;
  @override
  void initState() {
    super.initState();

    initialFilterValue = ascendingText;
    initialFilterIcon = ascendingIcon;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);
    // shipperList ??= widget.shippers;
    order = widget.order;
    return Scaffold(
      appBar: AppBar(
        title: Text('Bi Asansör'),
      ),
      body: buildSearchResultsBody(context, _viewModel, order),
    );
  }

  Widget buildSearchResultsBody(
      BuildContext context, ViewModel _viewModel, Order order) {
    return shipperList == null
        ? FutureBuilder(
            future: _viewModel.getAvailableShippersAscending(order),
            builder: (BuildContext context, AsyncSnapshot asyncsnapshot) {
              if (asyncsnapshot.hasData) {
                shipperList = asyncsnapshot.data;
                if (initialFilterValue == ascendingText || null) {
                  shipperList.sort((a, b) => a.displayingShippingPrice
                      .compareTo(b.displayingShippingPrice));
                }
                return buildBody(context, _viewModel, order);
              } else {
                return Center(
                  child: Image.asset(
                    'assets/asansor_gif.gif',
                    scale: 8,
                  ),
                );
              }
            })
        : buildBody(context, _viewModel, order);
  }

  Widget buildBody(BuildContext context, ViewModel _viewModel, Order order) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: context.dynamicHeight(0.065),
          color: Colors.indigo.shade50,
          // color: context.theme.backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              Expanded(
                  flex: 8, child: Text('${shipperList.length} Sonuç Listelendi')
                  // child: Text(
                  //     shipperList.length.toString() + ' Uygun Sonuç Listelendi'),
                  ),
              Spacer(),
              Expanded(
                flex: 8,
                child: PopupMenuButton(
                  initialValue: initialFilterValue,
                  onSelected: (value) async {
                    if (value == ascendingText &&
                        ascendingText != initialFilterValue) {
                      initialFilterValue = value;
                      setState(() {
                        initialFilterIcon = ascendingIcon;
                      });
                      shipperList.sort((a, b) => a.displayingShippingPrice
                          .compareTo(b.displayingShippingPrice));
                    } else if (value == descendingText &&
                        descendingText != initialFilterValue) {
                      setState(() {
                        initialFilterIcon = descendingIcon;
                      });
                      initialFilterValue = value;
                      shipperList.sort((b, a) => a.displayingShippingPrice
                          .compareTo(b.displayingShippingPrice));
                    } else if (value == starPointText) {
                      setState(() {
                        initialFilterValue = value;
                        initialFilterIcon = starIcon;
                      });
                      //Yıldız seçildiğinde
                      shipperList.sort((a, b) => a.displayingShippingPrice
                          .compareTo(b.displayingShippingPrice));
                      shipperList.sort((b, a) => a.rating.compareTo(b.rating));
                    } else if (value == experienceText) {
                      setState(() {
                        initialFilterValue = value;
                        initialFilterIcon = experienceIcon;
                      });
                      shipperList.sort((b, a) =>
                          a.workExperience.compareTo(b.workExperience));
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<Widget>>[
                    PopupMenuItem<Widget>(
                      value: ascendingText,
                      child: Row(
                        children: [
                          ascendingIcon,
                          ascendingText,
                        ],
                      ),
                    ),
                    PopupMenuItem<Widget>(
                      value: descendingText,
                      child: Row(
                        children: [descendingIcon, descendingText],
                      ),
                      // child: Text('Fiyata göre (Önce en düşük)'),
                    ),
                    PopupMenuItem<Widget>(
                      value: starPointText,
                      child: Row(
                        children: [
                          starIcon,
                          starPointText,
                        ],
                      ),
                    ),
                    PopupMenuItem<Widget>(
                      value: experienceText,
                      child: Row(
                        children: [experienceIcon, experienceText],
                      ),
                    )
                  ],
                  child: Row(
                    children: [
                      Expanded(child: initialFilterIcon),
                      Expanded(flex: 4, child: initialFilterValue),
                      Spacer(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        shipperList.length == 0
            ? Center(
                child: Icon(
                  Icons.supervised_user_circle_outlined,
                  size: 64,
                ),
              )
            : Expanded(
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: shipperList.length,
                    itemBuilder: (context, index) {
                      var shipper = shipperList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ShipperDetailPage(
                                        shipperID: shipper.id,
                                        shipperName: shipper.name,
                                        order: widget.order,
                                      )));
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                        child: Image.network(
                                      shipper.shippingVehiclePhotoUrl,
                                      height: context.dynamicHeight(0.15),
                                    )),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: context.dynamicHeight(0.15),
                                      child: Column(
                                        children: [
                                          Align(
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
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                  style: context
                                                      .theme.textTheme.headline6
                                                      .copyWith(
                                                          color: Colors.white)),
                                            ),
                                          ),
                                          Expanded(
                                              child: Row(
                                            children: [
                                              Expanded(
                                                child: Icon(
                                                    MaterialCommunityIcons
                                                        .home_modern),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                    'Çıkabildiği Kat Sayısı : ' +
                                                        shipper.maxFloor
                                                            .toString() +
                                                        ' Kat'),
                                              ),
                                            ],
                                          )),
                                          Expanded(
                                              child: Row(
                                            children: [
                                              Expanded(
                                                child: Icon(
                                                  MaterialIcons.work,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                    'Sektördeki Tecrübe : ' +
                                                        shipper.workExperience
                                                            .toString() +
                                                        ' Yıl'),
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          // color: Colors.white,
                                          ),
                                      height: context.dynamicHeight(0.05),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 16,
                                              child: RatingBar.readOnly(
                                                  isHalfAllowed: true,
                                                  halfFilledIcon:
                                                      Icons.star_half_outlined,
                                                  initialRating:
                                                      shipper.rating ?? 0,
                                                  size: 20,
                                                  filledIcon: Icons.star,
                                                  emptyIcon:
                                                      Icons.star_border)),
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade400,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                              height:
                                                  context.dynamicHeight(0.06),
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    shipper.rating == null
                                                        ? '0.0'
                                                        : shipper.rating
                                                            .floorToDouble()
                                                            .toString(),
                                                    style: context.theme
                                                        .textTheme.bodyText1
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  )),
                                            ),
                                          ),
                                          Spacer(
                                            flex: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: context.dynamicHeight(0.07),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            Flexible(
                                                flex: 2,
                                                child: Text(
                                                    'Tahmini Kiralama Ücreti : ')),
                                            Flexible(
                                              child: Container(
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12)),
                                                ),
                                                height:
                                                    context.dynamicHeight(0.06),
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '${shipper.displayingShippingPrice}₺',
                                                      style: context.theme
                                                          .textTheme.bodyText1
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: context.theme.canvasColor,
                                        border: Border.all(width: 0.5),
                                      ),
                                      height: 55,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Detay Sayfasına Git',
                                          style: context.theme.textTheme.button,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  RentalFinishPage.withID(
                                                    shipperID: shipper.id,
                                                    order: order,
                                                    price: shipper
                                                        .displayingShippingPrice,
                                                  )));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        border: Border.all(width: 0.5),
                                      ),
                                      height: 55,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Asansörü Şimdi Kirala',
                                          style: context.theme.textTheme.button,
                                        ),
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
      ],
    );
  }

  // void getMoreUserWithPaginationAscending() async {
  //   var _viewModel = Provider.of<ViewModel>(context, listen: false);
  //   setState(() {
  //     isPaginationLoading = true;
  //     Future.delayed(Duration(seconds: 1)).then((value) async {
  //       await _viewModel
  //           .getAvailableShippersAscendingWithPagination(order, shipperList)
  //           .then((value) {
  //         setState(() {
  //           shipperList = value;
  //           // if (initialFilterValue == descendingText) {
  //           //   shipperList.sort((b, a) => a.displayingShippingPrice
  //           //       .compareTo(b.displayingShippingPrice));
  //           //   //azalan olacak
  //           // } else if (initialFilterValue == ascendingText) {
  //           //   shipperList.sort((a, b) => a.displayingShippingPrice
  //           //       .compareTo(b.displayingShippingPrice));
  //           // }
  //
  //           isPaginationLoading = false;
  //         });
  //       });
  //     });
  //   });
  // }

  // void getMoreUserWithPaginationDescending() async {
  //   var _viewModel = Provider.of<ViewModel>(context, listen: false);
  //   setState(() {
  //     isPaginationLoading = true;
  //     Future.delayed(Duration(seconds: 1)).then((value) async {
  //       await _viewModel
  //           .getAvailableShippersDescendingWithPagination(order, shipperList)
  //           .then((value) {
  //         setState(() {
  //           shipperList = value;
  //           // if (initialFilterValue == descendingText) {
  //           //   shipperList.sort((b, a) => a.displayingShippingPrice
  //           //       .compareTo(b.displayingShippingPrice));
  //           //   //azalan olacak
  //           // } else if (initialFilterValue == ascendingText) {
  //           //   shipperList.sort((a, b) => a.displayingShippingPrice
  //           //       .compareTo(b.displayingShippingPrice));
  //           // }
  //           isPaginationLoading = false;
  //         });
  //       });
  //     });
  //   });
  //   // var _viewModel = Provider.of<ViewModel>(context, listen: false);
  //   // await _viewModel
  //   //     .getAvailableShippersDescendingWithPagination(order, shipperList)
  //   //     .then((value) {
  //   //   setState(() {
  //   //     shipperList = value;
  //   //     isPaginationLoading = false;
  //   //   });
  //   // });
  // }

  // void _listScrollListener() {
  //   if (_scrollController.position.maxScrollExtent ==
  //       _scrollController.offset) {
  //     print('Listenin en altındayız');
  //     if (initialFilterValue == ascendingText ||
  //         initialFilterValue == filterText) {
  //       if (!isPaginationLoading) {
  //         getMoreUserWithPaginationAscending();
  //       }
  //     } else if (initialFilterValue == descendingText) {
  //       if (!isPaginationLoading) {
  //         getMoreUserWithPaginationDescending();
  //       }
  //     }
  //   }
  // }
}
