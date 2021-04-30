import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/model/campaign.dart';

class CampaignDetailPage extends StatefulWidget {
  Campaign campaign;
  @override
  _CampaignDetailPageState createState() => _CampaignDetailPageState();
  CampaignDetailPage({@required this.campaign});
}

class _CampaignDetailPageState extends State<CampaignDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kampanya Detay"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.red,
              height: context.dynamicHeight(0.3),
              width: context.dynamicWidth(1),
              foregroundDecoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage('${widget.campaign.photoLink}'),
                      fit: BoxFit.fill)),

              // child: Image.network(
              //   widget.blog.blogPhotoLink,
              // ),
            ),
            SizedBox(
              height: context.dynamicHeight(0.01),
            ),
            Padding(
              padding: context.paddingAllLow,
              child: Text(
                widget.campaign.bodyText,
                style: context.theme.textTheme.subtitle1
                    .copyWith(color: Colors.black87),
              ),
            )
          ],
        ),
      ),
    );
  }
}
