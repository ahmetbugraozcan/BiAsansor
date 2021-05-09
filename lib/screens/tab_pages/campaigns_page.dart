import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/model/campaign.dart';
import 'package:flutter_biasansor/notification_handler.dart';
import 'package:flutter_biasansor/screens/add_campaign_page.dart';
import 'package:flutter_biasansor/screens/campaign.detail_page.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPaginationLoading = false;
  static List<Campaign> campaigns;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listeScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);
    return Scaffold(
        floatingActionButton: _viewModel.user.isAdmin
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AddCampaignPage()));
                },
                child: Icon(Icons.add),
              )
            : null,
        appBar: AppBar(
          title: Text("BiAsansör - Kampanyalar"),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              campaigns = null;
            });
            await Future.value();
          },
          child: campaigns == null
              ? FutureBuilder(
                  future: _viewModel.getCampaigns(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      campaigns = snapshot.data;

                      return buildCampaignListView();
                    } else {
                      return Center(
                        child: Image.asset(
                          "assets/asansor_gif.gif",
                          scale: 8,
                        ),
                      );
                    }
                  },
                )
              : buildCampaignListView(),
        ));
  }

  Widget buildCampaignListView() {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: campaigns.length,
        itemBuilder: (context, index) {
          var campaign = campaigns[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          CampaignDetailPage(campaign: campaign)));
            },
            child: Container(
              width: double.infinity,
              height: context.dynamicHeight(0.3),
              child: Card(
                child: Image.network(
                  campaign.photoLink,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // child: Card(
            //   child: ListTile(
            //     leading: CircleAvatar(
            //       backgroundColor: Colors.white,
            //       radius: 28,
            //       child: Hero(
            //         tag: "${campaigns[index].blogPhotoLink}",
            //         child: Image.network(
            //           campaigns.blogPhotoLink,
            //         ),
            //       ),
            //     ),
            //     title: Text(campaigns.title),
            //   ),
            // ),
          );
        });
  }

  void _listeScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      getMoreCampaign();
    }
  }

  void getMoreCampaign() async {
    if (isPaginationLoading == false) {
      setState(() {
        isPaginationLoading = true;
      });
      final _viewModel = Provider.of<ViewModel>(context, listen: false);
      await _viewModel.getCampaignsWithPagination().then((value) {
        setState(() {
          campaigns += value;
          isPaginationLoading = false;
        });
      });
    }
  }
}
