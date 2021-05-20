import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/model/finished_shipping.dart';
import 'package:flutter_biasansor/model/order.dart';
import 'package:flutter_biasansor/screens/add_comment_page.dart';
import 'package:flutter_biasansor/screens/shipper_detail_page.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isPaginationLoading = false;

  List<FinishedShipping> finishedShippings;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listeScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Bi Asansör - Bildirimler"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          print('Girdik');
          setState(() {
            finishedShippings = null;
          });
          await Future.value();
        },
        child: WillPopScope(
          onWillPop: () {
            if (isLoading) {
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: SizedBox(
            child: finishedShippings == null
                ? FutureBuilder(
                    future:
                        _viewModel.getFinishedShippings(_viewModel.user.userID),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      print("Future çalıştı");
                      if (snapshot.hasData) {
                        finishedShippings = snapshot.data;
                        return isLoading
                            ? IgnorePointer(
                                child: buildNotificationPageBody(),
                              )
                            : buildNotificationPageBody();
                      }
                      return Center(
                        child: Image.asset(
                          'assets/asansor_gif.gif',
                          scale: 7,
                        ),
                      );
                    },
                  )
                : isLoading
                    ? IgnorePointer(
                        child: Stack(
                          children: [
                            buildNotificationPageBody(),
                            Center(
                                child: CircularProgressIndicator(
                              backgroundColor: Colors.blue,
                            ))
                          ],
                        ),
                      )
                    : buildNotificationPageBody(),
          ),
        ),
      ),
    );
  }

  Widget buildListEmptyWidget() {
    return ListView(
      children: [
        // SizedBox(height: 250),
        SizedBox(height: context.dynamicHeight(0.3)),
        Center(
          child: CircleAvatar(
            radius: 60,
            child: Image.asset("assets/asansor.png"),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: context.lowValue),
            child: Text(
              "HENÜZ BİR BİLDİRİMİNİZ YOK",
              style: context.theme.textTheme.subtitle2,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNotificationPageBody() {
    return finishedShippings.isEmpty
        ? buildListEmptyWidget()
        : ListView.builder(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: finishedShippings.length,
            itemBuilder: (context, index) {
              var finishedShipping = finishedShippings[index];
              return Card(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Padding(
                            padding: context.paddingAllLow,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 70,
                                child: Image.network(
                                    finishedShipping.shipperPhotoUrl),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: context.dynamicWidth(0.08),
                        ),
                        Flexible(
                          child: Padding(
                            padding: context.paddingAllLow,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(finishedShipping.shipperName,
                                    style: context.theme.textTheme.headline6),
                                SizedBox(
                                  height: context.dynamicHeight(0.01),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child:
                                            Icon(Icons.location_city, size: 14),
                                      ),
                                      TextSpan(
                                          text: ' Bölge: ' +
                                              finishedShipping.location,
                                          style: context
                                              .theme.textTheme.bodyText2),
                                    ],
                                  ),
                                ),
                                SizedBox(height: context.dynamicHeight(0.01)),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(Icons.calendar_today,
                                            size: 14),
                                      ),
                                      TextSpan(
                                          text: ' Taşıma Sayısı: ' +
                                              finishedShipping.transportCount
                                                  .toString() +
                                              ' Kez',
                                          style: context
                                              .theme.textTheme.bodyText2),
                                    ],
                                  ),
                                ),
                                SizedBox(height: context.dynamicHeight(0.01)),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(Icons.sort, size: 14),
                                      ),
                                      TextSpan(
                                          text: ' Taşınan Katlar: ' +
                                              printFloors(finishedShipping
                                                  .transportedFloors),
                                          style: context
                                              .theme.textTheme.bodyText2),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              //Order oluşturup kendimiz gidebiliriz
                              var order = Order(
                                  address: finishedShipping.location,
                                  // dateAndTime: finishedShipping.shippingDate,
                                  transportationCount:
                                      finishedShipping.transportCount,
                                  floorsToTransport:
                                      finishedShipping.transportedFloors);
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ShipperDetailPage(
                                          shipperID: finishedShipping.shipperID,
                                          order: order)));
                            },
                            style: ButtonStyle(),
                            child: Text(
                              'Firma Detay',
                              style: context.theme.textTheme.button
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              var _viewModel = Provider.of<ViewModel>(context,
                                  listen: false);
                              setState(() {
                                isLoading = true;
                              });
                              await _viewModel
                                  .getShipperDetails(finishedShipping.shipperID)
                                  .then((shipper) {
                                Navigator.push(
                                    _scaffoldKey.currentContext,
                                    CupertinoPageRoute(
                                        builder: (context) => AddCommentPage(
                                            shipper: shipper,
                                            shipping: finishedShipping))).then(
                                    (value) {
                                  if (value == true) {
                                    setState(() {
                                      //burası normalde finishedshippingsi null yapıyordu tekrar veritabanına gidiliyordu şimdi bu değeri direk siliyor
                                      finishedShippings
                                          .remove(finishedShipping);
                                    });
                                  }
                                });
                              }).then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                              //shipper lazım diyor önce id ile shipperi getir sonra shipperi yolla mini mi detailed mi emin değilim
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.orange)),
                            child: Text(
                              'Yorum Yap',
                              style: context.theme.textTheme.button
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
  }

  void _listeScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("Listenin en altındayız");
      getMoreFinishedWorks();
    }
  }

  void getMoreFinishedWorks() async {
    if (isPaginationLoading == false) {
      setState(() {
        isPaginationLoading = true;
      });
      final _viewModel = Provider.of<ViewModel>(context, listen: false);
      await _viewModel
          .getFinishedShippingsWithPagination(_viewModel.user.userID)
          .then((value) {
        setState(() {
          finishedShippings += value;
          isPaginationLoading = false;
        });
      });
    }
  }
}

printFloors(List<int> floors) {
  String floorsString = '';
  int sayac = 0;
  for (int kat in floors) {
    if (sayac == floors.length - 1) {
      floorsString += kat.toString() + '.Kat';
    } else {
      floorsString += kat.toString() + '.Kat, ';
    }
    sayac++;
  }
  return floorsString;
}
