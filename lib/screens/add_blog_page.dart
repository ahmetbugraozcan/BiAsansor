import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/model/blog.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_alert_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddBlogPage extends StatefulWidget {
  @override
  _AddBlogPageState createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  GlobalKey<FormState> _titleKey = GlobalKey<FormState>();
  GlobalKey<FormState> _bodyKey = GlobalKey<FormState>();
  GlobalKey<FormState> _linkKey = GlobalKey<FormState>();
  TextEditingController _titleController;
  TextEditingController _bodyController;
  TextEditingController _linkController;
  bool isLoading = false;
  File _blogPhoto;
  String link;
  String blogPhotoUrl;
  String blogBody;
  String blogTitle;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _linkController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('BiAsansör - Blog Ekle'),
      ),
      body: Stack(
        children: [
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(),
          Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: context.dynamicHeight(0.3),
                      color: Colors.red,
                      child: _blogPhoto == null
                          ? Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  size: 48,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showSelectPhotoSheet(context);
                                },
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                showSelectPhotoSheet(context);
                              },
                              child: Image.file(
                                _blogPhoto,
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                    Form(
                      key: _linkKey,
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 10,
                        controller: _linkController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Bir link girilmelidir";
                          } else {
                            return null;
                          }
                        },
                        style: context.theme.textTheme.headline5,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Blog Linki",
                        ),
                      ),
                    ),
                    Form(
                      key: _titleKey,
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 10,
                        controller: _titleController,
                        validator: (value) {
                          if (value.length < 3) {
                            return "Başlık en az 3 karakter olmalıdır";
                          } else {
                            return null;
                          }
                        },
                        style: context.theme.textTheme.headline5,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Başlık Metni",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: context.dynamicHeight(0.01),
                    ),
                    Form(
                      key: _bodyKey,
                      child: TextFormField(
                        controller: _bodyController,
                        validator: (value) {
                          if (value.length < 20) {
                            return "Gövde en az 20 karakter olmalıdır";
                          } else {
                            return null;
                          }
                        },
                        minLines: 1,
                        maxLines: 1000,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: "Gövde Metni",
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                color: context.theme.buttonColor,
                onPressed: () async {
                  if (_blogPhoto == null) {
                    await PlatformDuyarliAlertDialog(
                      title: "Başarısız",
                      body:
                          "Blog ekleme işlemi başarısız oldu. Lütfen bir fotoğraf ekleyiniz",
                      mainButtonText: "Tamam",
                    ).show(context);
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    blogBody = _bodyController.text;
                    blogTitle = _titleController.text;
                    link = _linkController.text;
                    //validateler olsun
                    if (_bodyKey.currentState.validate() &&
                        _titleKey.currentState.validate() &&
                        _linkKey.currentState.validate()) {
                      var blog = Blog(
                          bodyText: blogBody, title: blogTitle, blogLink: link);
                      await _viewModel.addBlog(blog).then((value) async {
                        var id = value;
                        await _viewModel.uploadBlogImage(id, _blogPhoto);
                        print('Başarıyla tamamlandı');
                        setState(() {
                          isLoading = false;
                        });
                        await PlatformDuyarliAlertDialog(
                          mainButtonText: 'Tamam',
                          body: 'Blog ekleme işlemi başarıyla tamamlandı',
                          title: 'İşlem Başarılı',
                        ).show(context);
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
                child: Text("Blogu Ekle"),
              )
            ],
          ),
        ],
      ),
    );
  }

  void showSelectPhotoSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 120,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Kameradan Çek"),
                  onTap: () {
                    _takePhotoFromCamera();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text("Galeriden Seç"),
                  onTap: () {
                    _selectPictureFromGallery();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _takePhotoFromCamera() async {
    try {
      setState(() {
        isLoading = true;
      });
      var _newPicture = await ImagePicker.pickImage(source: ImageSource.camera);
      if (mounted) {
        _blogPhoto = File(_newPicture.path);
        setState(() {
          isLoading = false;
        });
      }
    } catch (ex) {
      print(ex.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void _selectPictureFromGallery() async {
    try {
      setState(() {
        isLoading = true;
      });
      var _newPicture =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      if (mounted) {
        _blogPhoto = File(_newPicture.path);

        setState(() {
          isLoading = false;
        });
      }
    } catch (ex) {
      print(ex.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> _getPhotoLink(BuildContext context) async {
    if (_blogPhoto != null) {
      // var url = await _viewModel.uploadFile(
      //     _viewModel.user.userID, 'blog_photo', _blogPhoto);
      // return url;
    }
  }
}
