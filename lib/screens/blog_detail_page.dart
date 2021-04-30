import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/model/blog.dart';

class BlogDetailPage extends StatefulWidget {
  Blog blog;
  @override
  _BlogDetailPageState createState() => _BlogDetailPageState();
  BlogDetailPage({@required this.blog});
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog Detay"),
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
                      image: NetworkImage('${widget.blog.blogPhotoLink}'),
                      fit: BoxFit.fill)),

              // child: Image.network(
              //   widget.blog.blogPhotoLink,
              // ),
            ),
            SizedBox(
              height: context.dynamicHeight(0.01),
            ),
            Text(widget.blog.title, style: context.theme.textTheme.headline5),
            SizedBox(
              height: context.dynamicHeight(0.01),
            ),
            Padding(
              padding: context.paddingAllLow,
              child: Text(
                widget.blog.bodyText,
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
