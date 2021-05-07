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
  String filterText = "Yorumları Sırala";
  int initialValue = 1;
  @override
  Widget build(BuildContext context) {
    var commentCount = 0;
    var ratingbarwidth = context.dynamicHeight(0.188);
    var ratingbarheight = context.dynamicHeight(0.008);
    var ratingbarContainerheight = context.dynamicHeight(0.2);
    var ratingbarRadius = Radius.circular(12);
    var ratingbarIconSize = 16;
    var fiveStarCommentCount = 0;
    var fourStarCommentCount = 0;
    var threeStarCommentCount = 0;
    var twoStarCommentCount = 0;
    var oneStarCommentCount = 0;
    widget.comments.forEach((element) {
      if (element.commentText.isNotEmpty) {
        commentCount++;
      }
      if (element.rating.toInt() == 5) {
        fiveStarCommentCount++;
      } else if (element.rating.toInt() == 4) {
        fourStarCommentCount++;
      } else if (element.rating.toInt() == 3) {
        threeStarCommentCount++;
      } else if (element.rating.toInt() == 2) {
        twoStarCommentCount++;
      } else if (element.rating.toInt() == 1) {
        oneStarCommentCount++;
      } else {}
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Asansör Değerlendirmeleri'),
      ),
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: context.paddingAllLow,
                  child: Text(
                    'Asansör Değerlendirmeleri',
                    style: context.theme.textTheme.headline6
                        .copyWith(fontSize: 16),
                  ),
                ),
                //TODO burada expanded sorunları çıkıyor nedenini anlamadım çözmeye çalış
                Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
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
                        ],
                      ),
                    ),
                    Container(
                      width: 0.7,
                      height: context.dynamicHeight(0.15),
                      color: Colors.grey[400],
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 10,
                      child: Container(
                        height: ratingbarContainerheight,
                        constraints: BoxConstraints(
                          minHeight: 100,
                          maxHeight: ratingbarContainerheight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "5",
                                  style: context.theme.textTheme.bodyText1
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  Icons.star,
                                  size: ratingbarIconSize.toDouble(),
                                ),
                                Container(
                                  height: ratingbarheight,
                                  width: ratingbarwidth,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius:
                                          BorderRadius.all(ratingbarRadius)),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: context.theme.primaryColor,
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    left: ratingbarRadius)),
                                        width: fiveStarCommentCount /
                                            widget.comments.length *
                                            ratingbarwidth,
                                        constraints: BoxConstraints(
                                          minWidth: 0,
                                          maxWidth: ratingbarwidth,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "4",
                                  style: context.theme.textTheme.bodyText1
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  Icons.star,
                                  size: ratingbarIconSize.toDouble(),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius:
                                          BorderRadius.all(ratingbarRadius)),
                                  height: ratingbarheight,
                                  width: ratingbarwidth,
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: context.theme.primaryColor,
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    left: ratingbarRadius)),
                                        width: fourStarCommentCount /
                                            widget.comments.length *
                                            ratingbarwidth,
                                        constraints: BoxConstraints(
                                          minWidth: 0,
                                          maxWidth: ratingbarwidth,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "3",
                                  style: context.theme.textTheme.bodyText1
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  Icons.star,
                                  size: ratingbarIconSize.toDouble(),
                                ),
                                Container(
                                  height: ratingbarheight,
                                  width: ratingbarwidth,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius:
                                          BorderRadius.all(ratingbarRadius)),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: context.theme.primaryColor,
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    left: ratingbarRadius)),
                                        width: threeStarCommentCount /
                                            widget.comments.length *
                                            ratingbarwidth,
                                        constraints: BoxConstraints(
                                          minWidth: 0,
                                          maxWidth: ratingbarwidth,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "2",
                                  style: context.theme.textTheme.bodyText1
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  Icons.star,
                                  size: ratingbarIconSize.toDouble(),
                                ),
                                Container(
                                  height: ratingbarheight,
                                  width: ratingbarwidth,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius:
                                          BorderRadius.all(ratingbarRadius)),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: context.theme.primaryColor,
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    left: ratingbarRadius)),
                                        width: twoStarCommentCount /
                                            widget.comments.length *
                                            ratingbarwidth,
                                        constraints: BoxConstraints(
                                          minWidth: 0,
                                          maxWidth: ratingbarwidth,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "1",
                                  style: context.theme.textTheme.bodyText1
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  Icons.star,
                                  size: ratingbarIconSize.toDouble(),
                                ),
                                Container(
                                  height: ratingbarheight,
                                  width: ratingbarwidth,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius:
                                          BorderRadius.all(ratingbarRadius)),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: context.theme.primaryColor,
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    left: ratingbarRadius)),
                                        width: oneStarCommentCount /
                                            widget.comments.length *
                                            ratingbarwidth,
                                        constraints: BoxConstraints(
                                          minWidth: 0,
                                          maxWidth: ratingbarwidth,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      // child: Container(
                      //   height: 200,
                      //   color: Colors.red,
                      // ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.only(top: context.mediumValue),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  //popupmenübutton olacak
                  child: PopupMenuButton<int>(
                    onSelected: (value) {
                      if (value == 1) {
                        setState(() {
                          widget.comments
                              .sort((a, b) => a.rating > b.rating ? 0 : 1);
                          filterText = "Azalan Puan";
                          initialValue = value;
                        });
                      } else if (value == 2) {
                        setState(() {
                          widget.comments
                              .sort((a, b) => a.rating > b.rating ? 1 : 0);
                          filterText = "Artan Puan";
                          initialValue = value;
                        });
                      } else if (value == 3) {
                        setState(() {
                          widget.comments.sort((a, b) =>
                              a.commentDate.compareTo(b.commentDate) > 1
                                  ? 1
                                  : 0);
                          filterText = "Yeniden Eskiye";
                          initialValue = value;
                        });
                      } else if (value == 4) {
                        setState(() {
                          widget.comments.sort((a, b) =>
                              a.commentDate.compareTo(b.commentDate) > 1
                                  ? 0
                                  : 1);
                          filterText = "Eskiden Yeniye";
                          initialValue = value;
                        });
                      } else {
                        //DEFAULT FALAN OLSUN NE BİLİM
                      }
                    },
                    initialValue: initialValue,
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<int>>[
                      PopupMenuItem<int>(value: 1, child: Text("Azalan puan")),
                      PopupMenuItem<int>(value: 2, child: Text("Artan puan")),
                      PopupMenuItem<int>(
                          value: 3, child: Text("Yeniden Eskiye")),
                      PopupMenuItem<int>(
                          value: 4, child: Text("Eskiden Yeniye")),
                    ],
                    child: Padding(
                      padding: context.paddingAllLow,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(Icons.sort),
                              Text(
                                filterText,
                                style: context.theme.textTheme.bodyText1,
                              ),
                            ],
                          ),
                          Padding(
                            padding: context.paddingAllLow,
                            child: Divider(),
                          ),
                        ],
                      ),
                    ),
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
