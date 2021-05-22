import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/locator.dart';
import 'package:flutter_biasansor/model/membership_form.dart';
import 'package:flutter_biasansor/utils.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_alert_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class WorkWithUsPage extends StatefulWidget {
  @override
  _WorkWithUsPageState createState() => _WorkWithUsPageState();
}

class _WorkWithUsPageState extends State<WorkWithUsPage> {
  //----------------------------DEĞİŞKENLER-----------------------------

  bool isLoading = false;
  bool checkBoxValue = false;
  File _profilePhoto;
  String _fullName;
  String _shippingName;
  String _floorPrices;
  String photoUrl;
  String _phoneNumber;
  int _maxFloor;
  int _experience;
  String _aboutUs;
  int locationBuilderCount = 0;
  List<String> allLocations;
  List<String> shipperLocations = [];
  bool isLocationFieldsValidated = true;
  var list = <String>[];
  var utils = locator<Utils>();
  //-------------------------------KEYS----------------------------------
  List<GlobalKey<FormState>> _shipperLocationKeys = [];
  final GlobalKey<FormState> _fullNameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _shippingNameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _locationsKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _priceKey = GlobalKey<FormState>();
  //burası dosya eklemeli tarzda olacak eklenecek

  final GlobalKey<FormState> _maxFloorKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _experienceKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _aboutUsKey = GlobalKey<FormState>();
  // final GlobalKey _autoCompleteTextFieldKey =
  //     GlobalKey<AutoCompleteTextFieldState<String>>();
  final GlobalKey _autoCompleteTextFieldKey = GlobalKey<FormState>();
  //-------------------------------KEYS----------------------------------

  //-------------------------------CONTROLLERS----------------------------------
  List<TextEditingController> _shipperLocationControllers = [];
  TextEditingController _shippingNameController;
  TextEditingController _autoCompleteTextFieldController;
  TextEditingController _fullNameController;
  TextEditingController _locationController;
  TextEditingController _phoneController;
  TextEditingController _priceController;

  TextEditingController _maxFloorController;
  TextEditingController _experienceController;
  TextEditingController _aboutUsController;
  // final _utils = locator<Utils>();
  //-------------------------------CONTROLLERS----------------------------------
  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _shippingNameController = TextEditingController();
    _locationController = TextEditingController();
    _priceController = TextEditingController();
    _maxFloorController = TextEditingController();
    _experienceController = TextEditingController();
    _aboutUsController = TextEditingController();
    _phoneController = TextEditingController();
    _autoCompleteTextFieldController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bi Asansör - Bizimle Çalışın'),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: context.paddingAllMedium,
                    child: Align(
                      child: SizedBox(
                        width: context.dynamicWidth(0.4),
                        height: context.dynamicHeight(0.2),
                        child: _profilePhoto == null
                            ? CircleAvatar(
                                child: Image.asset(
                                  "assets/asansor_siyah.png",
                                ),
                              ) // ? Image.network(
                            //     'https://image.flaticon.com/icons/png/512/3629/3629148.png',
                            //     loadingBuilder: (BuildContext context,
                            //         Widget child,
                            //         ImageChunkEvent loadingProgress) {
                            //       if (loadingProgress == null) return child;
                            //       return Center(
                            //         child: CircularProgressIndicator(
                            //           value: loadingProgress
                            //                       .expectedTotalBytes !=
                            //                   null
                            //               ? loadingProgress
                            //                       .cumulativeBytesLoaded /
                            //                   loadingProgress.expectedTotalBytes
                            //               : null,
                            //         ),
                            //       );
                            //     },
                            //   )
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
                          'Asansörün Fotoğrafını Ekle',
                          style: context.theme.textTheme.subtitle1.copyWith(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                  Padding(
                    padding: context.paddingAllLow,
                    child: Form(
                        key: _fullNameKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen bir değer giriniz";
                            } else {
                              return null;
                            }
                          },
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            labelText: 'Ad Soyad',
                            helperText:
                                'Sizinle iletişime geçtiğimiz zaman bilmemiz gereken ad.',
                            border: OutlineInputBorder(),
                          ),
                        )),
                  ),
                  Padding(
                    padding: context.paddingAllLow,
                    child: Form(
                        key: _shippingNameKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen bir değer giriniz";
                            } else {
                              return null;
                            }
                          },
                          controller: _shippingNameController,
                          decoration: InputDecoration(
                            labelText: 'Asansörün İsmi',
                            helperText:
                                'Arama sonuçlarında görünecek olan adınız.',
                            border: OutlineInputBorder(),
                          ),
                        )),
                  ),
                  Padding(
                    padding: context.paddingAllLow,
                    child: Form(
                      key: _phoneKey,
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          var pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          var regExp = RegExp(pattern);
                          if (value.isEmpty) {
                            return 'Lütfen bir telefon numarası giriniz.';
                          } else if (!regExp.hasMatch(value)) {
                            return 'Lütfen geçerli bir numara giriniz.';
                          }
                          return null;
                        },
                        autofocus: false,
                        // initialValue: _viewModel.user.phoneNumber ?? '',
                        decoration: InputDecoration(
                          labelText: 'Telefon Numarası Giriniz',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, StateSetter setState) {
                                return Scaffold(
                                  floatingActionButton: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: context.paddingAllLow,
                                        child: FloatingActionButton(
                                          onPressed: () {
                                            setState(() {
                                              _shipperLocationControllers
                                                  .add(TextEditingController());
                                              _shipperLocationKeys
                                                  .add(GlobalKey<FormState>());
                                              locationBuilderCount =
                                                  locationBuilderCount + 1;
                                            });
                                          },
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                      Padding(
                                        padding: context.paddingAllLow,
                                        child: FloatingActionButton(
                                          onPressed: () {
                                            setState(() {
                                              if (locationBuilderCount > 0) {
                                                _shipperLocationControllers
                                                    .removeLast();
                                                _shipperLocationKeys
                                                    .removeLast();

                                                locationBuilderCount =
                                                    locationBuilderCount - 1;
                                              }
                                            });
                                          },
                                          child: Icon(Icons.remove),
                                        ),
                                      )
                                    ],
                                  ),
                                  appBar: AppBar(
                                    title: Text('Şehirleri Ekleyin'),
                                  ),
                                  //listview builder olacak
                                  body: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: locationBuilderCount,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                                onTap: () async {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return allLocations ==
                                                                null
                                                            ? FutureBuilder(
                                                                future: utils
                                                                    .getAllLocations(),
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot
                                                                        snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    allLocations =
                                                                        snapshot
                                                                            .data;
                                                                    // allLocations
                                                                    //     .forEach(
                                                                    //         (element) {
                                                                    //   if (element
                                                                    //       .toLowerCase()
                                                                    //       .contains(_autoCompleteTextFieldController
                                                                    //           .text
                                                                    //           .toLowerCase())) {
                                                                    //     list.add(
                                                                    //         element);
                                                                    //   }
                                                                    // });
                                                                    // //başta boşluklu başladığı için burayı tekrar sıfırladık
                                                                    // _autoCompleteTextFieldController
                                                                    //     .text = "";
                                                                    return buildLocationPickBody(
                                                                        context,
                                                                        _shipperLocationControllers[
                                                                            index]);
                                                                  } else {
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    );
                                                                  }
                                                                },
                                                              )
                                                            : buildLocationPickBody(
                                                                context,
                                                                _shipperLocationControllers[
                                                                    index]);
                                                        ;
                                                      });
                                                },
                                                child: Padding(
                                                  padding:
                                                      context.paddingAllLow,
                                                  child: Form(
                                                    key: _shipperLocationKeys[
                                                        index],
                                                    child: TextFormField(
                                                      // validator: (value) {
                                                      //   if (value.isEmpty) {
                                                      //     return 'Bir değer girilmelidir';
                                                      //   } else {
                                                      //     return null;
                                                      //   }
                                                      // },
                                                      controller:
                                                          _shipperLocationControllers[
                                                              index],
                                                      decoration:
                                                          InputDecoration(
                                                        errorStyle: TextStyle(
                                                            color: context.theme
                                                                .errorColor),
                                                        hintText:
                                                            'Örnek : İstanbul, Ümraniye',
                                                        filled: true,
                                                        enabled: false,
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20))),
                                                      ),
                                                      readOnly: true,
                                                      enabled: false,
                                                    ),
                                                  ),
                                                ));
                                          },
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            if (_shipperLocationControllers
                                                .isEmpty) {
                                              PlatformDuyarliAlertDialog(
                                                body:
                                                    'Şehir değerleri boş olamaz. Lütfen bir şehir ekleyiniz',
                                                title:
                                                    'Lütfen bir şehir ekleyiniz',
                                                mainButtonText: 'Tamam',
                                              ).show(context);
                                            }
                                            // _shipperLocationKeys
                                            //     .forEach((element) {
                                            //   if (element.currentState
                                            //       .validate()) {
                                            //     print('validate oldu : ');
                                            //     element.currentState.save();
                                            //   } else {
                                            //     isLocationFieldsValidated =
                                            //         false;
                                            //   }
                                            // });
                                            if (isLocationFieldsValidated) {
                                              //tekrarlı eleman buluyor tekrardan temizlemezsek
                                              shipperLocations.clear();
                                              for (var element
                                                  in _shipperLocationControllers) {
                                                print('elemanımız : ' +
                                                    element.text);
                                                if (shipperLocations
                                                    .contains(element.text)) {
                                                  print(
                                                      'tekrarlı eleman bulundu');
                                                  PlatformDuyarliAlertDialog(
                                                    mainButtonText: 'Tamam',
                                                    title: 'Tekrarlanan eleman',
                                                    body:
                                                        'Tekrarlanan elemanları çıkarıp tekrar deneyin',
                                                  ).show(context);
                                                  shipperLocations.clear();
                                                  break;
                                                } else {
                                                  shipperLocations
                                                      .add(element.text);
                                                }
                                              }
                                              if (shipperLocations.isNotEmpty) {
                                                _locationController.text =
                                                    shipperLocations.toString();

                                                Navigator.pop(context);
                                              } else {
                                                print(
                                                    'listemiz boş ekleme başarısız oldu');
                                              }
                                            }
                                          },
                                          child: Text('Eklemeyi Bitir')),
                                    ],
                                  ),
                                );
                              },
                            );
                          });
                    },
                    child: Padding(
                      padding: context.paddingAllLow,
                      child: Form(
                          key: _locationsKey,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Lütfen bir değer giriniz";
                              } else {
                                return null;
                              }
                            },
                            readOnly: true,
                            enabled: false,
                            controller: _locationController,
                            decoration: InputDecoration(
                              helperStyle: context.theme.textTheme.caption,
                              labelText: 'Asansörün Çalıştığı Yerler',
                              helperMaxLines: 3,
                              helperText:
                                  'Asansörünüzün hizmet verdiği bölgeler. Bölgeden bölgeye fiyatlarda değişim oluyorsa lütfen değişen bölgeleri yeni bir form olarak gönderin',
                              border: OutlineInputBorder(),
                            ),
                          )),
                    ),
                  ),
                  //Text olacak
                  Padding(
                    padding: context.paddingAllLow,
                    child: Form(
                        key: _priceKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen bir değer giriniz";
                            } else {
                              return null;
                            }
                          },
                          controller: _priceController,
                          decoration: InputDecoration(
                            helperMaxLines: 3,
                            helperText:
                                'Kat Tarifeleri, belirli katlar arasında belirlenen ücrettir.Örneğin 1-9 kat arası 250 TL, 10-15 kat arası 300 TL',
                            helperStyle: context.theme.textTheme.caption,
                            labelText: 'Kat Tarifeleri',
                            border: OutlineInputBorder(),
                          ),
                        )),
                  ),

                  Padding(
                    padding: context.paddingAllLow,
                    child: Form(
                        key: _maxFloorKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen bir değer giriniz";
                            } else {
                              return null;
                            }
                          },
                          controller: _maxFloorController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            helperText:
                                'Asansörünüzün en yüksek ulaşabildiği kat değerini giriniz. ',
                            labelText:
                                'Asansörün çıkabileceği en yüksek katı giriniz ',
                            border: OutlineInputBorder(),
                          ),
                        )),
                  ),
                  Padding(
                    padding: context.paddingAllLow,
                    child: Form(
                        key: _experienceKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen bir değer giriniz";
                            } else {
                              return null;
                            }
                          },
                          controller: _experienceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Sektöre başladığınız yılı giriniz',
                            helperText:
                                'Sektöre başladığınız yıl değeri (Örn 2001)',
                            border: OutlineInputBorder(),
                          ),
                        )),
                  ),
                  //Burası zorunlu olmasın
                  Padding(
                    padding: context.paddingAllLow,
                    child: Form(
                        key: _aboutUsKey,
                        child: TextFormField(
                          controller: _aboutUsController,
                          decoration: InputDecoration(
                            labelText:
                                'Hakkımızda kısmı için bilgilerinizi giriniz',
                            helperText: 'Firmanız hakkında genel bilgiler',
                            border: OutlineInputBorder(),
                          ),
                        )),
                  ),
                  //TODO Okudum onaylıyorum metni eklensin
                  Row(
                    children: [
                      Checkbox(
                          value: checkBoxValue,
                          onChanged: (value) {
                            setState(() {
                              checkBoxValue = value;
                            });
                          }),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: context.theme.textTheme.bodyText1,
                            children: <WidgetSpan>[
                              WidgetSpan(
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SimpleDialog(
                                            titlePadding: EdgeInsets.fromLTRB(
                                                context.dynamicWidth(0.03),
                                                context.dynamicHeight(0.02),
                                                context.dynamicWidth(0.03),
                                                0.0),
                                            contentPadding:
                                                context.paddingAllMedium,
                                            title: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                    'Firma Kayıt Sözleşmesi')),
                                            children: [
                                              Container(
                                                width: 500,
                                                height: 250,
                                                child: Scrollbar(
                                                  child: ListView(
                                                    children: [
                                                      Text(utils
                                                          .firmaKayitSozlesmesi()),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  child: Text("Firma Kayıt Sözleşmesi",
                                      style: context.theme.textTheme.bodyText1
                                          .copyWith(color: Colors.blue[900])),
                                ),
                              ),
                              WidgetSpan(
                                child: Text(
                                  "hakkındaki aydınlatma formunu",
                                ),
                              ),
                              WidgetSpan(
                                child: Text(
                                  "okudum ve kabul ediyorum.",
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                      onPressed: isLoading
                          ? null
                          : checkBoxValue == false
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (_fullNameKey.currentState.validate() &&
                                      _shippingNameKey.currentState
                                          .validate() &&
                                      _locationsKey.currentState.validate() &&
                                      _priceKey.currentState.validate() &&
                                      _maxFloorKey.currentState.validate() &&
                                      _experienceKey.currentState.validate()) {
                                    try {
                                      _phoneNumber = _phoneController.text;
                                      _shippingName =
                                          _shippingNameController.text;
                                      _fullName = _fullNameController.text;
                                      _shippingName =
                                          _shippingNameController.text;
                                      _floorPrices = _priceController.text;
                                      _maxFloor =
                                          int.parse(_maxFloorController.text);
                                      _experience =
                                          int.parse(_experienceController.text);
                                      _aboutUs = _aboutUsController.text ?? "";

                                      var membershipForm = MembershipForm(
                                          formSendingDate: Timestamp.now(),
                                          fullName: _fullName,
                                          shippingName: _shippingName,
                                          floorPrices: _floorPrices,
                                          maxFloor: _maxFloor,
                                          phoneNumber: _phoneNumber,
                                          experience: _experience,
                                          aboutUs: _aboutUs,
                                          locations: shipperLocations,
                                          photoUrl: photoUrl ??
                                              'https://image.flaticon.com/icons/png/512/3629/3629148.png');
                                      await _viewModel
                                          .addMembershipFormToDatabase(
                                              membershipForm);
                                      //circularprogressindicator görünsün
                                      setState(() {
                                        isLoading = false;
                                      });
                                      await PlatformDuyarliAlertDialog(
                                        title: "Başvurunuz alınmıştır.",
                                        body:
                                            "Başvurunuz başarılı bir şekilde alınmıştır. En kısa sürede sizinle iletişime geçilecektir",
                                        mainButtonText: "Tamam",
                                      ).show(context);
                                    } catch (ex) {
                                      await PlatformDuyarliAlertDialog(
                                        title: "Başvurunuz alınamadı.",
                                        body:
                                            "Başvurunuz alınırken bir hata oluştu. Lütfen daha sonra tekrar deneyin veya bizimle iletişime geçin.",
                                        mainButtonText: "Tamam",
                                      ).show(context);
                                      debugPrint("work with us page hata : " +
                                          ex.toString());
                                    }

                                    print('validated');
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    print('validasyon başarısız');
                                  }
                                },
                      child: Text('Başvuru Formunu Gönder')),
                ],
              ),
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget buildLocationPickBody(
      BuildContext context, TextEditingController shipperLocationController) {
    list.clear();
    allLocations.forEach((element) {
      list.add(element);
    });

    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Bir şehir ekleyiniz"),
        ),
        body: Column(
          children: [
            Padding(
              padding: context.paddingAllLow,
              child: Form(
                key: _autoCompleteTextFieldKey,
                child: TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(
                    Icons.search,
                  )),
                  onChanged: (value) {
                    //TODO olmayan bir değer yazınca hata var
                    setState(() {
                      list = [];
                      list.clear();
                    });
                    allLocations.forEach((element) {
                      if (element.toLowerCase().contains(value.toLowerCase())) {
                        setState(() {
                          list.add(element);
                        });
                      }
                    });
                    print("burdayız");
                    print(list.length);
                  },
                  controller: _autoCompleteTextFieldController,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      shipperLocationController.text = list[index];
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Image.asset(
                        'assets/turkiye_haritasi.png',
                        scale: 4,
                      ),
                      title: Text(list[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void _selectPictureFromGallery() async {
    try {
      setState(() {
        isLoading = true;
      });
      var _newPicture =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      if (mounted) {
        _profilePhoto = File(_newPicture.path);

        await _getPhotoLink(context).then((url) {
          photoUrl = url;
          print(url == null ? "null" : " $url Galeri");
          setState(() {
            isLoading = false;
          });
          // Navigator.pop(context);
        });
      }
    } catch (ex) {
      print(ex.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void _takePhotoFromCamera() async {
    try {
      setState(() {
        isLoading = true;
      });
      var _newPicture = await ImagePicker.pickImage(source: ImageSource.camera);
      if (mounted) {
        _profilePhoto = File(_newPicture.path);

        await _getPhotoLink(context).then((url) {
          setState(() {
            isLoading = false;
          });
          photoUrl = url;
          print(url == null ? "null" : " $url photo");
          // Navigator.pop(context);
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
    final _viewModel = Provider.of<ViewModel>(context, listen: false);
    if (_profilePhoto != null) {
      var url = await _viewModel.uploadFile(
          _viewModel.user.userID, 'asansor_photo', _profilePhoto);
      return url;
    }
  }
}
