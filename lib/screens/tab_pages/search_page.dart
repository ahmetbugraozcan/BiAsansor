import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/locator.dart';
import 'package:flutter_biasansor/model/order.dart';
import 'package:flutter_biasansor/notification_handler.dart';
import 'package:flutter_biasansor/screens/add_shipper_page.dart';
import 'package:flutter_biasansor/screens/search_results_page.dart';
import 'package:flutter_biasansor/screens/tab_pages/profile_page.dart';
import 'package:flutter_biasansor/screens/work_with_us_page.dart';
import 'package:flutter_biasansor/utils.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_alert_dialog.dart';
import 'package:flutter_biasansor/widgets/social_log_in_button.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

//TODO Değerler contexte göre ayarlanacak
class _SearchPageState extends State<SearchPage> {
  final _utils = locator<Utils>();
  bool isLoading;
  int transportCount = 1;
  String searchingLocation;

  var pickedDate = DateTime.now();
  var pickedTime = TimeOfDay.now();
  var myFormat = DateFormat('dd-MM-yyyy');
  var list = <String>[];
  TextEditingController _mainFloorTextFieldController;
  List<TextEditingController> _floorControllers = [];
  List<GlobalKey<FormState>> _floorKeys = [];
  TextEditingController _dateController;
  TextEditingController _timeController;
  TextEditingController _autoCompleteTextFieldController;
  TextEditingController _transportCountController;
  TextEditingController _locationController;
  final GlobalKey _locationFormKey = GlobalKey<FormState>();
  final GlobalKey _autoCompleteTextFieldKey = GlobalKey<FormState>();
  final GlobalKey _transportKey = GlobalKey<FormState>();

  List<String> allLocations;
  List<int> floorsToTransport = [];

  @override
  void initState() {
    super.initState();

    isLoading = false;
    _mainFloorTextFieldController = TextEditingController();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    _transportCountController = TextEditingController();
    _locationController = TextEditingController();
    _autoCompleteTextFieldController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _dateController.text = _utils.printDate(pickedDate);
      _timeController.text = _utils.printTime(pickedTime);
      _transportCountController.text = '$transportCount Kez';
    });
  }

  @override
  void dispose() {
    _mainFloorTextFieldController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _transportCountController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);
    var _user = Provider.of<ViewModel>(context).user;
    return Scaffold(
        floatingActionButton: _user.isAdmin
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AddShipperPage()));
                },
                child: Icon(Icons.add),
              )
            : null,
        backgroundColor: Colors.white30,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Asansör Kirala'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                      child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => WorkWithUsPage()));
                    },
                    child: Container(
                      color: Colors.red,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/asansor_2.jfif',
                        fit: BoxFit.fill,
                      ),
                    ),
                  )),
                ),
                Expanded(
                    flex: 18,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: ListView(
                        children: [
                          ListTile(
                            title: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: context.lowValue,
                                  vertical: context.lowValue),
                              child: Row(
                                children: [
                                  Icon(Entypo.location,
                                      size: 20,
                                      color: context.theme.accentColor),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: context.dynamicWidth(0.01)),
                                    child: Text(
                                      'Bölge Adresi',
                                      style: context.theme.textTheme.subtitle1
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            subtitle: Form(
                                child: InkWell(
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return allLocations == null
                                          ? FutureBuilder(
                                              future:
                                                  _viewModel.getAllLocations(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.hasData) {
                                                  allLocations = snapshot.data;
                                                  //textfield boşluklu olunca tüm değerlere eşit oluyor
                                                  //başlangıçta tüm şehirlerin görünmesi için yaptık
                                                  allLocations
                                                      .forEach((element) {
                                                    list.add(element);
                                                  });
                                                  // başta boşluklu başladığı için burayı tekrar sıfırladık
                                                  _autoCompleteTextFieldController
                                                      .text = "";
                                                  return buildSearchLocationDialogBody(
                                                      context);
                                                } else {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                            )
                                          : buildSearchLocationDialogBody(
                                              context);
                                    });
                              },
                              child: Form(
                                key: _locationFormKey,
                                child: TextFormField(
                                  controller: _locationController,
                                  readOnly: true,
                                  style: context.theme.textTheme.subtitle1
                                      .copyWith(fontWeight: FontWeight.w500),
                                  validator: (value) {
                                    if (value.length < 1) {
                                      return 'Lütfen bir şehir seçiniz';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                        color: context.theme.errorColor),
                                    hintText: 'Örnek : İstanbul, Ümraniye',
                                    filled: true,
                                    enabled: false,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                  ),
                                ),
                              ),
                            )),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 6,
                                  child: ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: context.lowValue,
                                          vertical: context.lowValue),
                                      child: Row(
                                        children: [
                                          Icon(AntDesign.calendar,
                                              size: 20,
                                              color: context.theme.accentColor),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left:
                                                    context.dynamicWidth(0.01)),
                                            child: Text(
                                              'Taşıma Tarihi',
                                              style: context
                                                  .theme.textTheme.subtitle1
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    subtitle: Form(
                                        child: InkWell(
                                      onTap: () async {
                                        await showDatePicker(
                                          selectableDayPredicate:
                                              (DateTime val) {
                                            if (val.isBefore(DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day))) {
                                              return false;
                                            } else {
                                              return true;
                                            }
                                          },
                                          locale: const Locale('tr', 'TR'),
                                          context: context,
                                          initialDate: DateTime.now(),
                                          currentDate: pickedDate,
                                          firstDate:
                                              DateTime(DateTime.now().year),
                                          lastDate:
                                              DateTime(DateTime.now().year + 1),
                                          // ignore: missing_return
                                        ).then((value) {
                                          if (value != null) {
                                            print('seçtik ' + value.toString());
                                            pickedDate = value;
                                            _dateController.text =
                                                _utils.printDate(value);
                                          }
                                        });
                                      },
                                      child: TextFormField(
                                        controller: _dateController,
                                        enabled: false,
                                        readOnly: true,
                                        style: context.theme.textTheme.subtitle1
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                        decoration: InputDecoration(
                                          filled: true,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                        ),
                                      ),
                                    )),
                                  )),
                              // Expanded(
                              //     flex: 6,
                              //     child: ListTile(
                              //       title: Padding(
                              //         padding: EdgeInsets.symmetric(
                              //             horizontal: context.lowValue,
                              //             vertical: context.lowValue),
                              //         child: Row(
                              //           children: [
                              //             Icon(Entypo.clock,
                              //                 size: 20,
                              //                 color: context.theme.accentColor),
                              //             Padding(
                              //               padding: EdgeInsets.only(
                              //                   left:
                              //                       context.dynamicWidth(0.01)),
                              //               child: Text(
                              //                 'Taşıma Saati',
                              //                 style: context
                              //                     .theme.textTheme.subtitle1
                              //                     .copyWith(
                              //                         fontWeight:
                              //                             FontWeight.w500,
                              //                         color: Colors.black),
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              //       subtitle: GestureDetector(
                              //         onTap: () {
                              //           showTimePicker(
                              //                   helpText: 'SAAT SEÇİNİZ',
                              //                   cancelText: 'KAPAT',
                              //                   confirmText: 'ONAYLA',
                              //                   context: context,
                              //                   initialTime: pickedTime)
                              //               .then((value) {
                              //             if (value != null) {
                              //               pickedTime = value;
                              //               _timeController.text =
                              //                   _utils.printTime(value);
                              //             }
                              //           });
                              //         },
                              //         child: Form(
                              //             child: TextFormField(
                              //           controller: _timeController,
                              //           style: context.theme.textTheme.subtitle1
                              //               .copyWith(
                              //                   fontWeight: FontWeight.w500),
                              //           readOnly: true,
                              //           enabled: false,
                              //           decoration: InputDecoration(
                              //             // prefixIcon: Icon(
                              //             //   Icons.access_time,
                              //             //   color: context.theme.accentColor,
                              //             // ),
                              //
                              //             filled: true,
                              //             border: OutlineInputBorder(
                              //                 borderSide: BorderSide.none,
                              //                 borderRadius: BorderRadius.all(
                              //                     Radius.circular(20))),
                              //           ),
                              //         )),
                              //       ),
                              //     ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: ListTile(
                                title: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: context.lowValue,
                                      vertical: context.lowValue),
                                  child: Row(
                                    children: [
                                      Icon(SimpleLineIcons.speedometer,
                                          size: 20,
                                          color: context.theme.accentColor),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: context.dynamicWidth(0.01)),
                                        child: Text(
                                          'Taşıma Sayısı',
                                          style: context
                                              .theme.textTheme.subtitle1
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                subtitle: Form(
                                    child: TextFormField(
                                  controller: _transportCountController,
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                  style: context.theme.textTheme.subtitle1
                                      .copyWith(fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    prefixIcon: IconButton(
                                      icon: Icon(
                                        Icons.remove,
                                        color: context.theme.accentColor,
                                      ),
                                      onPressed: () {
                                        if (transportCount > 1) {
                                          transportCount--;
                                        }
                                        _transportCountController.text =
                                            '$transportCount Kez';
                                      },
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: context.theme.accentColor,
                                      ),
                                      onPressed: () {
                                        transportCount++;
                                        _transportCountController.text =
                                            '$transportCount Kez';
                                      },
                                    ),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                  ),
                                )),
                              )),
                            ],
                          ),
                          ListTile(
                            title: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: context.lowValue,
                                  vertical: context.lowValue),
                              child: Row(
                                children: [
                                  Icon(AntDesign.solution1,
                                      size: 20,
                                      color: context.theme.accentColor),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: context.dynamicWidth(0.01)),
                                    child: Text(
                                      'Taşınacak Katlar',
                                      style: context.theme.textTheme.subtitle1
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            subtitle: Form(
                                key: _transportKey,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          _floorKeys = [];
                                          _floorControllers = [];
                                          return SimpleDialog(
                                            //buraya geldiğimizde gelen kutuda taşınacak katları seçiniz şeklinde yazılar olacak ve onaylandığında taşınacakkatlar adlı
                                            // bir listeye aktarılacak. O listenin içinde gezinip deriz eğer ki 10.kat üstü varsa fiyat artsın ?)=?=))'!'! ^^ uWu
                                            children: [
                                              Center(
                                                child: ListTile(
                                                  title: Text(transportCount
                                                          .toString() +
                                                      ' kez taşınacak. Taşınacak katları seçiniz'),
                                                ),
                                              ),
                                              Container(
                                                width: 300,
                                                height: 300,
                                                child: ListView.builder(
                                                  itemBuilder:
                                                      (context, index) {
                                                    _floorKeys.add(
                                                        GlobalKey<FormState>());
                                                    _floorControllers.add(
                                                        TextEditingController());
                                                    return ListTile(
                                                      title: Form(
                                                        key: _floorKeys[index],
                                                        child: TextFormField(
                                                          controller:
                                                              _floorControllers[
                                                                  index],
                                                          validator: (value) {
                                                            if (value.isEmpty) {
                                                              return 'Lütfen bir kat değeri giriniz';
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                '${index + 1}. taşınacak katı seçiniz',
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  itemCount: transportCount,
                                                ),
                                              ),
                                              TextButton(
                                                  //SUBMIT EDECEĞİMİZ BUTON BU BUNA BASILDIĞINDA TÜM KATLAR ALINACAK VE BİR LİSTEYE AKTARILACAK
                                                  onPressed: () {
                                                    bool isValidated = true;
                                                    //listeyi 0ladık ama girişte sıfırlarsak cancellandığında eski bilgiler gitmiş oluyor
                                                    floorsToTransport = [];
                                                    _mainFloorTextFieldController
                                                        .clear();
                                                    _floorKeys
                                                        .forEach((element) {
                                                      if (element.currentState
                                                          .validate()) {
                                                        element.currentState
                                                            .save();
                                                      } else {
                                                        isValidated = false;
                                                      }
                                                    });
                                                    if (isValidated) {
                                                      _floorControllers
                                                          .forEach((element) {
                                                        floorsToTransport.add(
                                                            int.tryParse(
                                                                element.text));
                                                      });
                                                      floorsToTransport
                                                          .forEach((element) {
                                                        if (floorsToTransport
                                                                .last ==
                                                            element) {
                                                          _mainFloorTextFieldController
                                                              .text += element
                                                                  .toString() +
                                                              '. Kat ';
                                                        } else {
                                                          _mainFloorTextFieldController
                                                              .text += element
                                                                  .toString() +
                                                              '. Kat, ';
                                                        }
                                                      });
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Text('TIKLA'))
                                            ],
                                          );
                                        });
                                  },
                                  child: TextFormField(
                                    controller: _mainFloorTextFieldController,
                                    enabled: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (floorsToTransport.isEmpty) {
                                        return 'Lütfen taşınacak katları giriniz';
                                      }
                                      return null;
                                    },
                                    style: context.theme.textTheme.subtitle1
                                        .copyWith(fontWeight: FontWeight.w500),
                                    // initialValue: '2.Kat, 4.Kat, 6.Kat, 10.Kat',
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                          color: context.theme.errorColor),
                                      hintText: 'Taşınacak Katları Giriniz',
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                    ),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: context.dynamicHeight(0.01),
                          ),
                        ],
                      ),
                    )),
                ListTile(
                  title: SocialLoginButton(
                      borderRadius: 16,
                      height: 50,
                      onPressed: () {
                        FormState locationForm = _locationFormKey.currentState;
                        FormState transportForm = _transportKey.currentState;
                        if (locationForm.validate() &&
                            transportForm.validate()) {
                          if (transportCount != floorsToTransport.length) {
                            PlatformDuyarliAlertDialog(
                              mainButtonText: 'Tamam',
                              body:
                                  'Taşıma sayısı ile taşınacak katların sayısı eşit olmalıdır.',
                              title: 'Hatalı Arama',
                            ).show(context);
                          } else {
                            print(floorsToTransport.toString());
                            var order = Order(
                              address: _locationController.text,
                              dateAndTime: pickedDate,
                              transportationCount: transportCount,
                              floorsToTransport: floorsToTransport,
                            );
                            setState(() {
                              isLoading = true;
                            });
                            //FUTURE.VALUES.THEN DİYİCEZ
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => SearchResultsPage(
                                          // shippers: value,
                                          order: order,
                                        )));
                            setState(() {
                              isLoading = false;
                            });
                          }
                        } else {
                          print('validate başarısız tekrar dene');
                        }
                      },
                      buttonColor: context.theme.buttonColor,
                      buttonText: Text(
                        'Uygun Asansörleri Ara',
                        style: context.theme.textTheme.button
                            .copyWith(color: Colors.white, fontSize: 18),
                      )),
                ),
                Spacer(),
              ],
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(),
          ],
        ));
  }

  Widget buildSearchLocationDialogBody(BuildContext context) {
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
                    setState(() {
                      list = <String>[];
                      list.clear();
                    });
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
                      _locationController.text = list[index];
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
