import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/locator.dart';
import 'package:flutter_biasansor/model/comment.dart';
import 'package:flutter_biasansor/utils.dart';
import 'package:rating_bar/rating_bar.dart';

class AllCommentsPage extends StatefulWidget {
  final List<Comment> comments;
  final double rating;
  const AllCommentsPage(
      {Key key, @required this.comments, @required this.rating})
      : super(key: key);
  @override
  _AllCommentsPageState createState() => _AllCommentsPageState();
}

class _AllCommentsPageState extends State<AllCommentsPage> {
  final _utils = locator<Utils>();

  @override
  Widget build(BuildContext context) {
    var commentCount = 0;
    widget.comments.forEach((element) {
      if (element.commentText.isNotEmpty) {
        commentCount++;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Asansör Değerlendirmeleri'),
      ),
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Container(
              child: Column(
                children: [
                  // Text('Asansör Değerlendirmeleri'),
                  Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.rating.isNaN
                                          ? '0.0'
                                          : widget.rating
                                              .floorToDouble()
                                              .toString(),
                                      style: context.theme.textTheme.headline4
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                    ),
                                    Icon(Icons.star),
                                  ],
                                ),
                                Text(
                                  '${widget.comments.length} puan &\n$commentCount yorum',
                                  style: context.theme.textTheme.caption
                                      .copyWith(color: Colors.black87),
                                ),
                              ],
                            ),
                            Container(
                              width: 0.7,
                              height: context.dynamicHeight(0.15),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          height: 200,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.only(top: context.mediumValue),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  //popupmenübutton olacak
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Yorumları Sırala'),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        widget.comments.length < 5 ? widget.comments.length : 5,
                    itemBuilder: (context, index) {
                      var comment = widget.comments[index];
                      return Padding(
                        padding: context.paddingHorizontalLow,
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: context.veryLowValue),
                                    child: Row(
                                      children: [
                                        RatingBar.readOnly(
                                          size: 17,
                                          filledIcon: Icons.star,
                                          emptyIcon: Icons.star_border,
                                          halfFilledIcon:
                                              Icons.star_half_outlined,
                                          initialRating: comment.rating,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          comment.commenterUserName + ' ',
                                          style:
                                              context.theme.textTheme.subtitle2,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                            _utils.printDate(comment.commentDate
                                                    .toDate()) +
                                                ' | ' +
                                                _utils.printTime(TimeOfDay(
                                                    hour: comment.commentDate
                                                        .toDate()
                                                        .hour,
                                                    minute: comment.commentDate
                                                        .toDate()
                                                        .minute)),
                                            style: context
                                                .theme.textTheme.caption),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: context.paddingVerticalLow,
                                    child: Text(
                                      comment.commentText,
                                      // style: context.theme.textTheme
                                      //     .subtitle1,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
