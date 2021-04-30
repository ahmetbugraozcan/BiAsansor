import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/model/shipper.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_alert_dialog.dart';
import 'package:provider/provider.dart';

class AddShipperPage extends StatefulWidget {
  @override
  _AddShipperPageState createState() => _AddShipperPageState();
}

class _AddShipperPageState extends State<AddShipperPage> {
  int locationBuilderCount = 0;
  int exceptionFloorsCount = 0;
  TextEditingController _nameController;
  TextEditingController _locationController;
  TextEditingController _photoController;
  TextEditingController _priceController;
  TextEditingController _phoneController;
  TextEditingController _ikinciTasimaIndirimiController;
  TextEditingController _maxFloorController;
  TextEditingController _experienceController;
  TextEditingController _exceptionFloorsTextController;
  TextEditingController _raiseAmountTextController;
  TextEditingController _aboutUsTextController;
  TextEditingController _fullNameTextController;
  TextEditingController _autoCompleteTextFieldController;
  List<TextEditingController> _shipperLocationControllers = [];
  List<GlobalKey<FormState>> _shipperLocationKeys = [];
  List<TextEditingController> _exceptionFloorsControllers = [];
  List<GlobalKey<FormState>> _exceptionFloorsKeys = [];
  List<TextEditingController> _raiseAmountControllers = [];
  List<GlobalKey<FormState>> _raiseAmountKeys = [];
  //----------------------------------------------------------------
  final GlobalKey<FormState> _experienceKey = GlobalKey<FormState>();
  var _fullNameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameFieldKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _maxFloorKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _discountOnSecondShippingKey =
      GlobalKey<FormState>();
  final GlobalKey<FormState> _priceKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _aboutUsTextKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _photoKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _exceptionFloorFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _raiseAmountFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _locationFormFieldKey = GlobalKey<FormState>();

  //----------------------------------------------------------------
  List<int> exceptionFloors = [];
  List<int> raiseAmounts = [];
  bool isLocationFieldsValidated = true;
  bool isFloorFieldsValidated = true;
  bool isRaiseAmountFieldsValidated = true;
  var list;
  List<String> shipperLocations = [];
  final GlobalKey _autoCompleteTextFieldKey = GlobalKey();
  List<String> allLocations;
  String fullName;
  String name;
  String location;
  String photoLink;
  List<String> locations;
  int price;
  int ikinciTasimaIndirimi;
  int maxFloor;
  int experience;
  String phoneNumber;
  String aboutUsText;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _aboutUsTextController = TextEditingController();
    _raiseAmountTextController = TextEditingController();
    _exceptionFloorsTextController = TextEditingController();
    _locationController = TextEditingController();
    _photoController = TextEditingController();
    _priceController = TextEditingController();
    _ikinciTasimaIndirimiController = TextEditingController();
    _maxFloorController = TextEditingController();
    _experienceController = TextEditingController();
    _fullNameTextController = TextEditingController();
    _autoCompleteTextFieldController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _photoController.text =
          'https://image.flaticon.com/icons/png/512/3629/3629148.png';
    });
  }

  // @override
  // void dispose() {
  //   //A TextEditingController was used after being disposed. hatası alınıyor
  //   // _raiseAmountTextController.dispose();
  //   // _exceptionFloorsTextController.dispose();
  //   // _nameController.dispose();
  //   // _locationController.dispose();
  //   // _photoController.dispose();
  //   // _priceController.dispose();
  //   // _ikinciTasimaIndirimiController.dispose();
  //   // _maxFloorController.dispose();
  //   // _maxFloorController.dispose();
  //   // _experienceController.dispose();
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Panel'),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: context.paddingAllLow,
                child: Form(
                    key: _fullNameKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Lütfen bir değer giriniz';
                        } else {
                          return null;
                        }
                      },
                      controller: _fullNameTextController,
                      decoration: InputDecoration(
                        labelText: 'İsim Soyisim',
                        border: OutlineInputBorder(),
                      ),
                    )),
              ),
              Padding(
                padding: context.paddingAllLow,
                child: Form(
                    key: _nameFieldKey,
                    child: TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Lütfen bir değer giriniz';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Asansörün İsmi',
                        border: OutlineInputBorder(),
                      ),
                    )),
              ),
              Padding(
                padding: context.paddingAllLow,
                child: Form(
                    key: _phoneKey,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      decoration: InputDecoration(
                        labelText: 'Asansörün Telefon Numarası',
                        border: OutlineInputBorder(),
                      ),
                    )),
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
                                            _shipperLocationKeys.removeLast();

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
                                                    return allLocations == null
                                                        ? FutureBuilder(
                                                            future: _viewModel
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
                                                                return buildSearchLocationDialogBody(
                                                                    context,
                                                                    _shipperLocationControllers[
                                                                        index]);

                                                                // return buildLocationPickBody(
                                                                //     context,
                                                                //     _shipperLocationControllers[
                                                                //         index]);
                                                              } else {
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                );
                                                              }
                                                            },
                                                          )
                                                        : buildSearchLocationDialogBody(
                                                            context,
                                                            _shipperLocationControllers[
                                                                index]);
                                                    // : buildLocationPickBody(
                                                    //     context,
                                                    //     _shipperLocationControllers[
                                                    //         index]);
                                                    ;
                                                  });
                                            },
                                            child: Padding(
                                              padding: context.paddingAllLow,
                                              child: Form(
                                                key:
                                                    _shipperLocationKeys[index],
                                                child: TextFormField(
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Bir değer girilmelidir';
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  controller:
                                                      _shipperLocationControllers[
                                                          index],
                                                  decoration: InputDecoration(
                                                    errorStyle: TextStyle(
                                                        color: context
                                                            .theme.errorColor),
                                                    hintText:
                                                        'Örnek : İstanbul, Ümraniye',
                                                    filled: true,
                                                    enabled: false,
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
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
                                            title: 'Lütfen bir şehir ekleyiniz',
                                            mainButtonText: 'Tamam',
                                          ).show(context);
                                        }
                                        _shipperLocationKeys.forEach((element) {
                                          if (element.currentState.validate()) {
                                            print('validate oldu : ');
                                            element.currentState.save();
                                          } else {
                                            isLocationFieldsValidated = false;
                                          }
                                        });
                                        if (isLocationFieldsValidated) {
                                          //tekrarlı eleman buluyor tekrardan temizlemezsek
                                          shipperLocations.clear();
                                          for (var element
                                              in _shipperLocationControllers) {
                                            print(
                                                'elemanımız : ' + element.text);
                                            if (shipperLocations
                                                .contains(element.text)) {
                                              print('tekrarlı eleman bulundu');
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
                      key: _locationFormFieldKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Lütfen bir değer giriniz';
                          } else {
                            return null;
                          }
                        },
                        readOnly: true,
                        enabled: false,
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Asansörün Çalıştığı Yerler',
                          border: OutlineInputBorder(),
                        ),
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                            builder: (context, StateSetter setState) {
                          return Scaffold(
                            floatingActionButton: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton(
                                  onPressed: () {
                                    setState(() {
                                      _exceptionFloorsControllers
                                          .add(TextEditingController());
                                      _exceptionFloorsKeys
                                          .add(GlobalKey<FormState>());
                                      exceptionFloorsCount++;
                                    });
                                  },
                                  child: Icon(Icons.add),
                                ),
                                FloatingActionButton(
                                  onPressed: () {
                                    setState(() {
                                      if (exceptionFloorsCount > 0) {
                                        _exceptionFloorsControllers
                                            .removeLast();
                                        _exceptionFloorsKeys.removeLast();
                                        // _raiseAmountKeys.removeLast();
                                        // _raiseAmountControllers.removeLast();
                                        exceptionFloorsCount--;
                                      }
                                    });
                                  },
                                  child: Icon(Icons.remove),
                                ),
                              ],
                            ),
                            appBar: AppBar(
                              title: Text('İstisna Katları Giriniz'),
                            ),
                            body: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: exceptionFloorsCount,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: context.paddingAllLow,
                                        child: Form(
                                          key: _exceptionFloorsKeys[index],
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            controller:
                                                _exceptionFloorsControllers[
                                                    index],
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Bir değer girilmelidir';
                                              } else {
                                                return null;
                                              }
                                            },
                                            // controller:
                                            // _shipperLocationControllers[
                                            // index],
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(
                                                  color:
                                                      context.theme.errorColor),
                                              hintText: 'İstisna Katları gir',
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      _exceptionFloorsKeys.forEach((element) {
                                        if (!element.currentState.validate()) {
                                          isFloorFieldsValidated = false;
                                        }
                                      });
                                      if (isFloorFieldsValidated) {
                                        exceptionFloors.clear();
                                        for (var element
                                            in _exceptionFloorsControllers) {
                                          print('elemanımız : ' + element.text);
                                          if (exceptionFloors.contains(
                                              int.parse(element.text))) {
                                            print('tekrarlı eleman bulundu');
                                            PlatformDuyarliAlertDialog(
                                              mainButtonText: 'Tamam',
                                              title: 'Tekrarlanan eleman',
                                              body:
                                                  'Tekrarlanan elemanları çıkarıp tekrar deneyin',
                                            ).show(context);
                                            exceptionFloors.clear();
                                            break;
                                          } else {
                                            exceptionFloors
                                                .add(int.parse(element.text));
                                          }
                                        }
                                        if (exceptionFloors.isNotEmpty) {
                                          // _locationController.text =
                                          //     shipperLocations.toString();
                                          exceptionFloors.sort();
                                          print('listemiz dolu : ' +
                                              exceptionFloors.toString());
                                          _exceptionFloorsTextController.text =
                                              exceptionFloors.toString();
                                          raiseAmounts.clear();
                                          _raiseAmountTextController.clear();
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
                        });
                      });
                },
                child: Padding(
                  padding: context.paddingAllLow,
                  child: Form(
                      key: _exceptionFloorFormKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Lütfen bir değer giriniz';
                          } else {
                            return null;
                          }
                        },
                        readOnly: true,
                        enabled: false,
                        controller: _exceptionFloorsTextController,
                        decoration: InputDecoration(
                          helperText:
                              'İstisna katlar, o kattan sonra fiyatların arttığı katlar',
                          helperStyle: context.theme.textTheme.caption,
                          errorStyle:
                              TextStyle(color: context.theme.errorColor),
                          labelText: 'İstisna Katlar',
                          border: OutlineInputBorder(),
                        ),
                      )),
                ),
              ),
              //*****************************************************************************************************************
              //*****************************************************************************************************************
              //*****************************************************************************************************************
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                            builder: (context, StateSetter setState) {
                          _raiseAmountKeys.clear();
                          _raiseAmountControllers.clear();
                          for (var i = 0; i < exceptionFloorsCount; i++) {
                            _raiseAmountKeys.add(GlobalKey<FormState>());
                            _raiseAmountControllers
                                .add(TextEditingController());
                          }
                          return Scaffold(
                            appBar: AppBar(
                              title: Text('Zam Miktarlarını Giriniz'),
                            ),
                            body: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: exceptionFloorsCount,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: context.paddingAllLow,
                                        child: Form(
                                          key: _raiseAmountKeys[index],
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            controller:
                                                _raiseAmountControllers[index],
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Bir değer girilmelidir';
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(
                                                  color:
                                                      context.theme.errorColor),
                                              hintText: 'Zam miktarını gir',
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      raiseAmounts.clear();
                                      _raiseAmountKeys.forEach((element) {
                                        if (!element.currentState.validate()) {
                                          isRaiseAmountFieldsValidated = false;
                                        }
                                      });
                                      if (isRaiseAmountFieldsValidated) {
                                        _raiseAmountControllers
                                            .forEach((element) {
                                          raiseAmounts
                                              .add(int.parse(element.text));
                                        });
                                        if (raiseAmounts.isNotEmpty) {
                                          _raiseAmountTextController.text =
                                              raiseAmounts.toString();
                                          print(raiseAmounts.toString() +
                                              ' listemiz bu');
                                          Navigator.pop(context);
                                        } else {
                                          print('ekleme başarısız liste null');
                                        }
                                      }
                                    },
                                    child: Text('Eklemeyi Bitir')),
                              ],
                            ),
                          );
                        });
                      });
                },
                child: Padding(
                  padding: context.paddingAllLow,
                  child: Form(
                      key: _raiseAmountFormKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Bir değer girilmelidir';
                          } else {
                            return null;
                          }
                        },
                        readOnly: true,
                        enabled: false,
                        controller: _raiseAmountTextController,
                        decoration: InputDecoration(
                          helperMaxLines: 3,
                          helperText:
                              'Zam Fiyatları, belirli katlardan sonra fiyatların arttığı katlar (Buraya direk zam miktarını ekle anaparaya ekledikten sonra değil saf zam.)',
                          helperStyle: context.theme.textTheme.caption,
                          labelText: 'Zam Fiyatları',
                          errorStyle:
                              TextStyle(color: context.theme.errorColor),
                          border: OutlineInputBorder(),
                        ),
                      )),
                ),
              ),
              //*****************************************************************************************************************
              //*****************************************************************************************************************
              //*****************************************************************************************************************
              Padding(
                //TODO buraya https regex eklenebilir
                padding: context.paddingAllLow,
                child: Form(
                    key: _photoKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Lütfen bir değer giriniz';
                        } else {
                          return null;
                        }
                      },
                      controller: _photoController,
                      decoration: InputDecoration(
                        labelText: 'Asansörün Fotoğrafı',
                        border: OutlineInputBorder(),
                      ),
                    )),
              ),
              Padding(
                padding: context.paddingAllLow,
                child: Form(
                    key: _priceKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Lütfen bir değer giriniz';
                        } else {
                          return null;
                        }
                      },
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Asansörün fiyatı',
                        border: OutlineInputBorder(),
                      ),
                    )),
              ),
              Padding(
                padding: context.paddingAllLow,
                child: Form(
                    key: _discountOnSecondShippingKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Lütfen bir değer giriniz';
                        } else {
                          return null;
                        }
                      },
                      controller: _ikinciTasimaIndirimiController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        helperText: 'Yoksa 0 Gir',
                        labelText: 'Asansörün İkinci Taşıma İndirimi',
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
                          return 'Lütfen bir değer giriniz';
                        } else {
                          return null;
                        }
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _maxFloorController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Asansörün max taşıyabileceği kat sayısı',
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
                          return 'Lütfen bir değer giriniz';
                        } else {
                          return null;
                        }
                      },
                      controller: _experienceController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        helperText: 'Bilinmiyorsa 0 gir',
                        labelText: 'Asansörcünün deneyimi yıl cinsinden',
                        border: OutlineInputBorder(),
                      ),
                    )),
              ),
              Padding(
                padding: context.paddingAllLow,
                child: Form(
                    key: _aboutUsTextKey,
                    child: TextFormField(
                      minLines: 3,
                      maxLines: 5,
                      controller: _aboutUsTextController,
                      decoration: InputDecoration(
                        helperText: 'Yoksa boş bırak',
                        labelText: 'Bizimle çalışın metni',
                        border: OutlineInputBorder(),
                      ),
                    )),
              ),

              TextButton(onPressed: validations, child: Text('Asansörü Ekle')),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> validations() async {
    var _viewModel = Provider.of<ViewModel>(context, listen: false);
    print(_fullNameTextController.text ?? ' null');
    if (_fullNameKey.currentState.validate() &&
        _nameFieldKey.currentState.validate() &&
        _phoneKey.currentState.validate() &&
        _exceptionFloorFormKey.currentState.validate() &&
        _locationFormFieldKey.currentState.validate() &&
        _raiseAmountFormKey.currentState.validate() &&
        _photoKey.currentState.validate() &&
        _priceKey.currentState.validate() &&
        _discountOnSecondShippingKey.currentState.validate() &&
        _maxFloorKey.currentState.validate() &&
        _experienceKey.currentState.validate()) {
      fullName = _fullNameTextController.text ?? '';
      aboutUsText = _aboutUsTextController.text ?? '';
      price = int.parse(_priceController.text);
      name = _nameController.text;
      photoLink = _photoController.text;
      location = _locationController.text;
      experience = int.parse(_experienceController.text);
      maxFloor = int.parse(_maxFloorController.text);
      phoneNumber = _phoneController.text;
      ikinciTasimaIndirimi = int.parse(_ikinciTasimaIndirimiController.text);

      print(raiseAmounts.runtimeType.toString() + ' zam fiyatları listesi');
      print(exceptionFloors.runtimeType.toString() + ' istisna katlar listesi');
      var shipper = Shipper(
        fullName: fullName,
        phoneNumber: phoneNumber,
        aboutUsText: aboutUsText,
        raiseAmounts: raiseAmounts,
        locations: shipperLocations,
        exceptionFloors: exceptionFloors,
        name: name,
        shippingPrice: price,
        shippingVehiclePhotoUrl: photoLink,
        maxFloor: maxFloor,
        workExperience: experience,
        secondShippingDiscount: ikinciTasimaIndirimi,
      );
      try {
        var value = await _viewModel.addShipperToDatabase(shipper);
        if (value) {
          await PlatformDuyarliAlertDialog(
            mainButtonText: 'Tamam',
            title: 'Başarılı',
            body: 'Veritabanına ekleme başarıyla tamamlandı.',
          ).show(context);
        }
      } catch (ex) {
        await PlatformDuyarliAlertDialog(
          mainButtonText: 'Tamam',
          title: 'Başarısız',
          body: 'Veritabanına ekleme başarısız oldu....',
        ).show(context);
        debugPrint(ex.toString());
      }
    } else {
      print('Validation başarısız');
    }
  }

  Widget buildSearchLocationDialogBody(
      BuildContext context, TextEditingController shipperLocationController) {
    list = [];
    _autoCompleteTextFieldController.clear();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Bir şehir seçiniz"),
        ),
        body: Column(
          children: [
            Padding(
              padding: context.paddingAllLow,
              child: Form(
                key: _autoCompleteTextFieldKey,
                child: TextFormField(
                  decoration: InputDecoration(icon: Icon(Icons.search)),
                  onChanged: (value) {
                    list = <String>[];
                    list.clear();
                    allLocations.forEach((element) {
                      if (element.toLowerCase().contains(value.toLowerCase())) {
                        setState(() {
                          list.add(element);
                        });
                      }
                    });
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
}
