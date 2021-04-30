import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/model/membership_form.dart';
import 'package:flutter_biasansor/model/order.dart';
import 'package:flutter_biasansor/screens/shipper_detail_page.dart';
import 'package:flutter_biasansor/screens/show_membership_details.dart';
import 'package:flutter_biasansor/screens/show_shipping_detail_to_admin.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:provider/provider.dart';

class ShowMembershipFormsToAdmin extends StatefulWidget {
  @override
  _ShowMembershipFormsToAdminState createState() =>
      _ShowMembershipFormsToAdminState();
}

class _ShowMembershipFormsToAdminState
    extends State<ShowMembershipFormsToAdmin> {
  ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isPaginationLoading = false;

  List<MembershipForm> membershipForms;
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
        title: Text("Bi Asansör - Başvuru Formları (Admin)"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            membershipForms = null;
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
            child: membershipForms == null
                ? FutureBuilder(
                    future: _viewModel.getMembershipForms(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        membershipForms = snapshot.data;
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
        itemCount: membershipForms.length,
        itemBuilder: (context, index) {
          var membershipForm = membershipForms[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ShowMembershipDetails(
                          membershipForm: membershipForm)));
            },
            child: Card(
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
                            // child: Image.network(membershipForm.photoUrl),
                            child: checkUrl(membershipForm.photoUrl),
                          ),
                        ),
                      ),
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
                                colors: [
                                  Colors.orangeAccent,
                                  Colors.deepOrange
                                ],
                                tileMode: TileMode.mirror,
                              ).createShader(bounds),
                              child: Text(membershipForm.fullName,
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
                                    child: Icon(Icons.calendar_today, size: 14),
                                  ),
                                  TextSpan(
                                      text: ' Formu Yollayanın Tam Adı: ' +
                                          membershipForm.fullName,
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
                                      text: ' Formu Yollayan Şirketin Adı: ' +
                                          membershipForm.shippingName,
                                      style: context.theme.textTheme.bodyText2),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
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
      await _viewModel.getMembershipFormsWithPagination().then((value) {
        setState(() {
          membershipForms += value;
          isPaginationLoading = false;
        });
      });
    }
  }

  Widget checkUrl(photoUrl) {
    try {
      return Image.network(photoUrl);
    } catch (e) {
      return Icon(Icons.image);
    }
  }
}
