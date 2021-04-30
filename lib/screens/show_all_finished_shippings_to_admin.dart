import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/model/finished_shipping.dart';
import 'package:flutter_biasansor/model/order.dart';
import 'package:flutter_biasansor/screens/shipper_detail_page.dart';
import 'package:flutter_biasansor/screens/shipper_details_for_admin.dart';
import 'package:flutter_biasansor/screens/show_shipping_detail_to_admin.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:provider/provider.dart';

class ShowAllFinishedShippingsToAdmin extends StatefulWidget {
  @override
  _ShowAllFinishedShippingsToAdminState createState() =>
      _ShowAllFinishedShippingsToAdminState();
}

class _ShowAllFinishedShippingsToAdminState
    extends State<ShowAllFinishedShippingsToAdmin> {
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
        title: Text("Bi Asansör - Bildirimler (Admin)"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
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
                    future: _viewModel.getAllFinishedShippingsForAdmin(),
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

  Widget buildNotificationPageBody() {
    return ListView.builder(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: finishedShippings.length,
        itemBuilder: (context, index) {
          var finishedShipping = finishedShippings[index];
          return Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: context.paddingAllLow,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 60,
                          child:
                              Image.network(finishedShipping.shipperPhotoUrl),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: context.paddingAllLow,
                    //   child: ClipRRect(
                    //     child: Container(
                    //       height: 120.0,
                    //       width: 120.0,
                    //       color: Color(0xffFF0E58),
                    //       child: Icon(Icons.volume_up,
                    //           color: Colors.white, size: 50.0),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: 40,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (Rect bounds) => RadialGradient(
                              radius: 4,
                              center: Alignment.topLeft,
                              colors: [Colors.orangeAccent, Colors.deepOrange],
                              tileMode: TileMode.mirror,
                            ).createShader(bounds),
                            child: Text(finishedShipping.shipperName,
                                style: context.theme.textTheme.headline6
                                    .copyWith(color: Colors.white)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.location_city, size: 14),
                                ),
                                TextSpan(
                                    text:
                                        ' Bölge : ' + finishedShipping.location,
                                    style: context.theme.textTheme.bodyText2),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.calendar_today, size: 14),
                                ),
                                TextSpan(
                                    text: ' Taşıma Sayısı : ' +
                                        finishedShipping.transportCount
                                            .toString() +
                                        ' Kez',
                                    style: context.theme.textTheme.bodyText2),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.sort, size: 14),
                                ),
                                TextSpan(
                                    text: ' Taşınan Katlar : ' +
                                        printFloors(
                                            finishedShipping.transportedFloors),
                                    style: context.theme.textTheme.bodyText2),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.schedule, size: 14),
                                ),
                                TextSpan(
                                    text: ' Taşıma Tarihi : ' +
                                        finishedShipping.shippingDate
                                            .toDate()
                                            .toString(),
                                    style: context.theme.textTheme.bodyText2),
                              ],
                            ),
                          )
                        ],
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
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                context.theme.buttonColor)),
                        child: Text(
                          'Firma Detay',
                          style: context.theme.textTheme.button
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
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
                                  builder: (context) =>
                                      ShowShippingDetailToAdmin(
                                          finishedShipping.userID,
                                          finishedShipping)));
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                context.theme.accentColor)),
                        child: Text(
                          'Kiralama Detayları',
                          style: context.theme.textTheme.button
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          //Order oluşturup kendimiz gidebiliriz
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ShipperDetailsForAdmin(
                                      id: finishedShipping.shipperID)));
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                context.theme.accentColor)),
                        child: Text(
                          'Asansörcü detayları',
                          style: context.theme.textTheme.button
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    )
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
          .getAllFinishedShippingsForAdminWithPagination()
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
