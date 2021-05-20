import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/model/blog.dart';
import 'package:flutter_biasansor/screens/add_blog_page.dart';
import 'package:flutter_biasansor/screens/blog_detail_page.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';

import 'package:provider/provider.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  static List<Blog> blogs;
  bool isPaginationLoading = false;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
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
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AddBlogPage()));
                // Navigator.push(context,
                //     CupertinoPageRoute(builder: (context) => ZephyrText()));
              },
              child: Icon(Icons.add),
            )
          : null,
      appBar: AppBar(
        title: Text('Blog'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            blogs = null;
          });
          await Future.value();
        },
        child: blogs == null
            ? FutureBuilder(
                future: _viewModel.readBlogs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    blogs = snapshot.data;

                    return buildBlogListView();
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
            : buildBlogListView(),
      ),
    );
  }

  Widget buildBlogListView() {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          var blog = blogs[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => BlogDetailPage(blog: blog)));
            },
            child: Card(
              child: Padding(
                padding: context.paddingAllLow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 15,
                      child: Container(
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 64,
                            child: Image.network(
                              blog.blogPhotoLink,
                            )),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(blog.title,
                              style: context.theme.textTheme.headline6),
                          RichText(
                            text: TextSpan(
                                text: blog.bodyText.length >= 80
                                    ? blog.bodyText.substring(0, 80)
                                    : blog.bodyText
                                        .substring(0, blog.bodyText.length),
                                style: context.theme.textTheme.bodyText2
                                    .copyWith(color: Colors.black54),
                                // style: TextStyle(
                                //     color: Colors.black, fontSize: 18),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' ...devamını oku',
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                    ),
                                  )
                                ]),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            // child: Card(
            //   child: ListTile(
            //     leading: CircleAvatar(
            //       backgroundColor: Colors.white,
            //       radius: 28,
            //       child: Image.network(
            //         blog.blogPhotoLink,
            //         scale: 0.1,
            //       ),
            //     ),
            //     title: Text(blog.title),
            //     subtitle: Text(blog.bodyText.substring(0, 20)),
            //   ),
            // ),
          );
        });
  }

  void _listeScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("Listenin en altındayız");
      getMoreBlog();
    }
  }

  void getMoreBlog() async {
    if (isPaginationLoading == false) {
      setState(() {
        isPaginationLoading = true;
      });
      final _viewModel = Provider.of<ViewModel>(context, listen: false);
      await _viewModel.readBlogsWithPagination().then((value) {
        setState(() {
          blogs += value;
          isPaginationLoading = false;
        });
      });
    }
  }
}
