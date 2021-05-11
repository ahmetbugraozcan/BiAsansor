import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_alert_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

//TODO  Koyu tema butonu ekle cupertinoswitch verileri sil çerezleri sil ekle
class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  File _profilePhoto;
  TextEditingController _locationController;
  TextEditingController _userNameController;
  TextEditingController _phoneNumberController;
  bool isLocationReadOnly = true;
  bool isUserNameReadOnly = true;
  bool isPhoneNumberReadOnly = true;
  bool isSaved = false;

  final _phoneKey = GlobalKey<FormState>();
  //daha güzelini bulana kadar bu iyi
  int dialogCounter = 0;
  bool isLoading = false;
  bool isUserNameChanged = false;
  bool isPhoneNumberChanged = false;
  bool isLocationChanged = false;
  bool isProfilePhotoChanged = false;
  String firstLocation;
  String firstUserName;
  String firstPhoneNumber;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
    _userNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _locationController.text =
          Provider.of<ViewModel>(context, listen: false).user.location;

      _userNameController.text =
          Provider.of<ViewModel>(context, listen: false).user.userName;

      _phoneNumberController.text =
          Provider.of<ViewModel>(context, listen: false).user.phoneNumber;
      firstLocation = _locationController.text;
      firstUserName = _userNameController.text;
      firstPhoneNumber = _phoneNumberController.text;
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);
    var _user = _viewModel.user;
    // _locationController.text = _viewModel.user.location;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        if (!isSaved &&
            (isUserNameChanged ||
                isPhoneNumberChanged ||
                isLocationChanged ||
                isProfilePhotoChanged)) {
          await PlatformDuyarliAlertDialog(
            cancelButtonOnTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            mainButtonOnTap: () async {
              isSaved = true;
              Navigator.pop(context);
              print('BASILDI');
              if (!isLoading) {
                if (mounted) {
                  setState(() {
                    isLoading = true;
                  });
                }
                if (_phoneKey.currentState.validate()) {
                  var isUpdatedPhoneNumber = await _updatePhoneNumber(context);
                  var isUpdatedUserLocation =
                      await _updateUserLocation(context);
                  var isUpdatedUserName = await _updateUserName(context);
                  var isUpdatedProfilePhoto =
                      await _updateProfilePhoto(context);

                  if (mounted) {
                    if (isUpdatedUserName &&
                        isUpdatedUserLocation & isUpdatedPhoneNumber) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Değişiklikler başarıyla kaydedildi"),
                      ));
                    }

                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              }
            },
            cancelButtonText: 'Kaydetmeden Çık',
            mainButtonText: 'Kaydet',
            body: 'Değişiklikler kaydedilmedi. Kaydedilmeden çıkılsın mı?',
            title: 'Değişiklikler Kaydedilmedi',
          ).show(_scaffoldKey.currentContext).then((value) {
            return true;
          });
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              color: Colors.grey.shade300,
              child: buildHesapBilgilerimKaydetListTile(context),
            ),
          ),
          elevation: 0,
          title: Text('Ayarlar'),
        ),
        body: isLoading
            ? IgnorePointer(
                child: Stack(
                  children: [
                    Center(child: CircularProgressIndicator()),
                    buildProfileSettingsBody(context, _viewModel),
                  ],
                ),
              )
            : buildProfileSettingsBody(context, _viewModel),
      ),
    );
  }

  ListTile buildHesapBilgilerimKaydetListTile(BuildContext context) {
    return ListTile(
      title: Text(
        'Hesap Bilgilerim',
        style: context.theme.textTheme.subtitle2
            .copyWith(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      trailing: TextButton(
        onPressed: isPhoneNumberChanged ||
                isLocationChanged ||
                isUserNameChanged ||
                isProfilePhotoChanged
            ? () async {
                var isUpdatedPhoneNumber = false;
                isSaved = true;
                if (!isLoading) {
                  if (mounted) {
                    setState(() {
                      isLoading = true;
                    });
                  }

                  if (_phoneKey.currentState.validate()) {
                    isUpdatedPhoneNumber = await _updatePhoneNumber(context);
                  }

                  var isUpdatedUserLocation =
                      await _updateUserLocation(context);
                  var isUpdatedUserName = await _updateUserName(context);
                  var isUpdatedProfilePhoto =
                      await _updateProfilePhoto(context);
                  print(isUpdatedPhoneNumber.toString() +
                      isUpdatedUserLocation.toString() +
                      isUpdatedUserName.toString() +
                      isUpdatedProfilePhoto.toString());
                  if (mounted) {
                    setState(() {
                      if (isUpdatedUserName ||
                          isUpdatedUserLocation ||
                          isUpdatedPhoneNumber) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Değişiklikler kaydedildi"),
                        ));
                      }
                      isLoading = false;
                      isPhoneNumberChanged = false;
                      isLocationChanged = false;
                      isUserNameChanged = false;
                      isProfilePhotoChanged = false;
                    });
                  }
                  //tek tek diyalog göstermek yerine kisi de true döndüğünde bir diyalog falan gösterebiliriz

                }
              }
            : null,
        child: Text(
          'Kaydet',
          // style: context.theme.textTheme.button
          //     .copyWith(color: Colors.blue[800], fontSize: 16),
        ),
      ),
    );
  }

  ListView buildProfileSettingsBody(
      BuildContext context, ViewModel _viewModel) {
    return ListView(
      children: [
        Padding(
          padding: context.paddingAllMedium,
          child: Align(
            child: SizedBox(
              width: context.dynamicWidth(0.4),
              height: context.dynamicHeight(0.2),
              child: _profilePhoto == null
                  ? Image.network(
                      _viewModel.user?.profileUrl ??
                          'https://cdn.onlinewebfonts.com/svg/img_264570.png',
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    )
                  : Image.file(_profilePhoto),
            ),
          ),
        ),
        Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
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
              },
              child: Text(
                'Profil Fotoğrafını Değiştir',
                style: context.theme.textTheme.subtitle1.copyWith(
                    color: Colors.blue[900], fontWeight: FontWeight.w500),
              ),
            )),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.mediumValue, vertical: context.lowValue),
          child: TextFormField(
            readOnly: true,
            initialValue: _viewModel.user?.email ?? '',
            decoration: InputDecoration(
              labelText: 'E-posta',
              prefixIcon: Icon(Icons.email),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.mediumValue, vertical: context.lowValue),
          child: TextFormField(
            onChanged: (value) {
              isSaved = false;
              if (value != firstUserName) {
                setState(() {
                  isUserNameChanged = true;
                });
              } else {
                setState(() {
                  isUserNameChanged = false;
                });
              }
            },
            controller: _userNameController,
            readOnly: isUserNameReadOnly,
            decoration: InputDecoration(
              labelText: 'Kullanıcı Adı',
              prefixIcon: Icon(Icons.person),
              suffixIcon: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      isUserNameReadOnly = !isUserNameReadOnly;
                    });
                  }
                },
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.mediumValue, vertical: context.lowValue),
          child: Form(
            key: _phoneKey,
            child: TextFormField(
              onChanged: (value) {
                isSaved = false;
                if (value != firstPhoneNumber) {
                  setState(() {
                    isPhoneNumberChanged = true;
                  });
                } else {
                  setState(() {
                    isPhoneNumberChanged = false;
                  });
                }
              },
              controller: _phoneNumberController,
              readOnly: isPhoneNumberReadOnly,
              validator: (value) {
                var pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                var regExp = RegExp(pattern);
                if (value.isEmpty) {
                  return 'Numara kaydedilemedi. Lütfen bir telefon numarası giriniz.';
                } else if (!regExp.hasMatch(value)) {
                  return 'Numara kaydedilemedi. Lütfen geçerli bir numara giriniz.';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        isPhoneNumberReadOnly = !isPhoneNumberReadOnly;
                      });
                    }
                  },
                ),
                prefixIcon: Icon(Icons.phone),
                labelText: 'Telefon Numarası',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.mediumValue, vertical: context.lowValue),
          child: TextFormField(
            onChanged: (value) {
              isSaved = false;
              if (value != firstLocation) {
                setState(() {
                  isLocationChanged = true;
                });
              } else {
                setState(() {
                  isLocationChanged = false;
                });
              }
            },
            readOnly: isLocationReadOnly,
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Konum',
              prefixIcon: Icon(Icons.location_on),
              suffixIcon: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  if (mounted) {
                    setState(() {
                      isLocationReadOnly = !isLocationReadOnly;
                    });
                  }
                },
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
        ),
        //Simgenin rengini ayarla
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on),
            MaterialButton(
              onPressed: () async {
                await getUserPosition().then((value) {
                  if (value != _locationController.text) {
                    _locationController.text = value;
                    setState(() {
                      isLocationChanged = true;
                    });
                  }
                });
              },
              child: Text(
                'Konumu Otomatik Bul',
                style: context.theme.textTheme.button.copyWith(
                    color: Colors.blue[900], fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.01)),
          child: ListTile(
            title: Text('Genel',
                style:
                    context.theme.textTheme.subtitle2.copyWith(fontSize: 15)),
            trailing: TextButton(
              onPressed: () async {
                //değeri gönder loadinge al
                // Navigator.pop(context, true);
                setState(() {
                  isLoading = true;
                });
                await _viewModel.signOut().then((value) {
                  Navigator.pop(context);
                });
              },
              child: Text(
                'Oturumu Kapat',
                style: context.theme.textTheme.subtitle1
                    .copyWith(color: Colors.red, fontSize: 15),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<bool> _updatePhoneNumber(BuildContext context) async {
    final _viewModel = Provider.of<ViewModel>(context, listen: false);
    if (_viewModel.user.phoneNumber != _phoneNumberController.text) {
      try {
        var updateResult = await _viewModel.updatePhoneNumber(
            _viewModel.user.userID, _phoneNumberController.text);
        print('Güncellenecek numara : ' + _phoneNumberController.text);
        if (updateResult) {
          // await PlatformDuyarliAlertDialog(
          //   mainButtonText: 'Tamam',
          //   title: 'İşlem Başarılı',
          //   body: 'Telefon Numarası Başarıyla Değiştirildi',
          // ).show(_scaffoldKey.currentContext);
          firstPhoneNumber = _phoneNumberController.text;
          return true;
        } else {
          // await PlatformDuyarliAlertDialog(
          //   mainButtonText: 'Tamam',
          //   title: 'İşlem Başarısız',
          //   body: 'Bu telefon numarası zaten kullanımda.',
          // ).show(_scaffoldKey.currentContext);
          return false;
        }
      } catch (ex) {
        print("telefon num güncelleme hata profile settings page : " +
            ex.toString());
      }
    } else {
      return true;
    }
  }

  Future<bool> _updateUserName(BuildContext context) async {
    final _viewModel = Provider.of<ViewModel>(context, listen: false);
    if (_viewModel.user.userName != _userNameController.text) {
      try {
        var updateResult = await _viewModel.updateUserName(
            _viewModel.user.userID, _userNameController.text);
        if (updateResult) {
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // await PlatformDuyarliAlertDialog(
          //   mainButtonText: 'Tamam',
          //   title: 'İşlem Başarılı',
          //   body: 'Kullanıcı Adı Başarıyla Değiştirildi',
          // ).show(_scaffoldKey.currentContext);
          firstUserName = _userNameController.text;
          return true;
        } else {
          await PlatformDuyarliAlertDialog(
            mainButtonText: 'Tamam',
            title: 'İşlem Başarısız',
            body:
                'Bu Kullanıcı Adı Zaten Kullanımda. Lütfen Farklı Bir Kullanıcı Adı Seçiniz.',
          ).show(_scaffoldKey.currentContext);
          return false;
        }
      } catch (ex) {
        print("Kullanıcı adı güncelleme hata profile settings : " +
            ex.toString());
      }
    } else {
      return true;
    }
  }

  Future<bool> _updateUserLocation(BuildContext context) async {
    final _userModel = Provider.of<ViewModel>(context, listen: false);
    if (_userModel.user.location != _locationController.text) {
      try {
        var updateResult = await _userModel.updateUserLocation(
            _userModel.user.userID, _locationController.text);
        if (updateResult) {
          // await PlatformDuyarliAlertDialog(
          //   title: 'Başarılı',
          //   body: 'Konum Başarıyla Değiştirildi.',
          //   mainButtonText: 'Tamam',
          // ).show(_scaffoldKey.currentContext);
          firstLocation = _locationController.text;
          return true;
        } else {
          await PlatformDuyarliAlertDialog(
            title: 'Başarısız',
            body: 'Değişiklikler Tamamlanamadı. Bir Hata Oluştu...',
            mainButtonText: 'Tamam',
          ).show(context);
          return false;
        }
      } catch (ex) {
        print("updatelocation hata settings page : " + ex.toString());
      }
    } else {
      return true;
    }
  }

  // ignore: missing_return
  Future<String> getUserPosition() async {
    //permission kontrol yap eğer reddedildiyse göster bişiler
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      Position _currentPosition;
      String _currentAddress;
      await Geolocator.requestPermission();
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      var placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      var place = placemarks[0];
      _currentAddress =
          '${place.administrativeArea}, ${place.locality}, ${place.subLocality}, ${place.thoroughfare}, ${place.country}';

      return _currentAddress;
    } catch (ex) {
      // await PlatformDuyarliAlertDialog(
      //   title: 'Konum Belirleme İşlemi Başarısız Oldu',
      //   body:
      //       'Konum Alınırken Bir Hata Oluştu. Lütfen Daha Sonra Tekrar Deneyin.',
      //   mainButtonText: 'Tamam',
      // ).show(_scaffoldKey.currentContext);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<bool> _updateProfilePhoto(BuildContext context) async {
    final _viewModel =
        Provider.of<ViewModel>(_scaffoldKey.currentContext, listen: false);
    try {
      if (_profilePhoto != null) {
        var url = await _viewModel.uploadFile(
            _viewModel.user.userID, 'profile_photo', _profilePhoto);
        if (url != null) {
          await _viewModel.updateProfilePhoto(_viewModel.user.userID, url);
          // await PlatformDuyarliAlertDialog(
          //   title: 'İşlem Başarılı',
          //   body: 'Profil Fotoğrafı Başarıyla Değiştirildi',
          //   mainButtonText: 'Tamam',
          // ).show(context);
          return true;
        }
      } else {
        return false;
      }
    } catch (ex) {
      //buraya giriyor ama yine de uygulama çalışıyor o yüzden devam
      print("update edilirken hata : " + ex.toString());
    }
  }

  void _selectPictureFromGallery() async {
    try {
      var _newPicture =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      if (_newPicture != null) {
        setState(() {
          isProfilePhotoChanged = true;
        });
        isSaved = false;
      }
      Navigator.pop(context);
      if (mounted) {
        setState(() {
          _profilePhoto = File(_newPicture.path);
        });
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  void _takePhotoFromCamera() async {
    try {
      var _newPicture = await ImagePicker.pickImage(source: ImageSource.camera);
      if (_newPicture != null) {
        setState(() {
          isProfilePhotoChanged = true;
        });
        isSaved = false;
      }
      Navigator.pop(context);
      if (mounted) {
        setState(() {
          _profilePhoto = File(_newPicture.path);
        });
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}
