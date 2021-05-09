import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/model/blog.dart';
import 'package:flutter_biasansor/model/campaign.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_alert_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddCampaignPage extends StatefulWidget {
  @override
  _AddCampaignPageState createState() => _AddCampaignPageState();
}

class _AddCampaignPageState extends State<AddCampaignPage> {
  GlobalKey<FormState> _linkKey = GlobalKey<FormState>();
  TextEditingController _linkController;
  bool isLoading = false;
  File _campaignPhoto;
  String link;
  String campaignPhotoUrl;
  @override
  void initState() {
    super.initState();
    _linkController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);
    return Scaffold(
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
                      child: _campaignPhoto == null
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
                                _campaignPhoto,
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
                          hintText: "Kampanya Linki",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: context.dynamicHeight(0.01),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                color: context.theme.buttonColor,
                onPressed: () async {
                  if (_campaignPhoto == null) {
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
                    link = _linkController.text;
                    //validateler olsun
                    if (_linkKey.currentState.validate()) {
                      var campaign = Campaign(campaignLink: link);
                      await _viewModel
                          .addCampaign(campaign)
                          .then((value) async {
                        var id = value;
                        await _viewModel.uploadCampaignPhoto(
                            id, _campaignPhoto);
                        print('Başarıyla tamamlandı');
                        setState(() {
                          isLoading = false;
                        });
                        await PlatformDuyarliAlertDialog(
                          mainButtonText: 'Tamam',
                          body: 'Kampanya ekleme işlemi başarıyla tamamlandı',
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
                child: Text("Kampanyayı Ekle"),
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
        _campaignPhoto = File(_newPicture.path);
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
        _campaignPhoto = File(_newPicture.path);

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
    if (_campaignPhoto != null) {
      // var url = await _viewModel.uploadFile(
      //     _viewModel.user.userID, 'blog_photo', _blogPhoto);
      // return url;
    }
  }
}
