import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/locator.dart';
import 'package:flutter_biasansor/model/finished_shipping.dart';
import 'package:flutter_biasansor/model/order.dart';
import 'package:flutter_biasansor/model/shipper.dart';
import 'package:flutter_biasansor/utils.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_alert_dialog.dart';
import 'package:flutter_biasansor/widgets/social_log_in_button.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class RentalFinishPage extends StatefulWidget {
  // TODO butona basınca widgets ancestor unsafe hatası var bazen
  Shipper shipper;
  Order order;
  String shipperID;
  int price;
  RentalFinishPage({Key key, this.shipper, this.order, this.price})
      : super(key: key);
  RentalFinishPage.withID(
      {@required this.order, @required this.shipperID, @required this.price});
  @override
  _RentalFinishPageState createState() => _RentalFinishPageState();
}

class _RentalFinishPageState extends State<RentalFinishPage> {
  final GlobalKey<FormState> _userRealNameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _allAddressKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> _addressKeys = [];
  List<TextEditingController> _addressControllers = [];
  TextEditingController _allAddressController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _phoneController = TextEditingController();
  final _utils = locator<Utils>();

  int counter = 0;
  //controllerimiz bunlar üzerinden olacak
  //controllerimiz bunlar üzerinden olacak
  bool isIsCheckedIncreased = false;
  bool isChecked = false;
  bool isPhoneIncreased = false;
  bool isPhoneDecreased = false;
  bool isAddressDecreased = false;
  bool isAddressIncreased = false;
  bool isLoading = false;
  // var photos = <ImageProvider>[
  //   AssetImage('assets/asansor_30.png'),
  //   AssetImage('assets/asansor_70.png'),
  //   AssetImage('assets/asansor_100.png'),
  // ];

  var photos = <Image>[
    Image.asset('assets/asansor_bos.png'),
    Image.asset('assets/asansor_30.png'),
    Image.asset('assets/asansor_70.png'),
    Image.asset('assets/asansor_100.png'),
  ];
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var _userAcc = Provider.of<ViewModel>(context, listen: false).user;
      _phoneController.text = _userAcc.phoneNumber;
      for (var i = 0; i < widget.order.transportationCount; i++) {
        _addressKeys.add(GlobalKey<FormState>());
        _addressControllers.add(TextEditingController(text: _userAcc.location));
      }
    });
    print(photos.length);

    _allAddressController.addListener(() {
      setState(() {
        if (_allAddressController.text.isNotEmpty) {
          if (counter < photos.length - 1 && isAddressIncreased == false) {
            counter++;
            isAddressIncreased = true;
            isAddressDecreased = false;
          }
        } else {
          if (counter > 0 &&
              isAddressDecreased == false &&
              isAddressIncreased) {
            print('azalmaya girdik...');
            counter--;
            isAddressDecreased = true;
            isAddressIncreased = false;
          }
        }
      });
    });
    _phoneController.addListener(() {
      setState(() {
        if (isValidPhone(_phoneController.text)) {
          if (counter < photos.length - 1 && isPhoneIncreased == false) {
            print('telefon validation');
            counter++;
            isPhoneIncreased = true;
            isPhoneDecreased = false;
          }
        } else {
          if (counter > 0 &&
              isPhoneDecreased == false &&
              _phoneController.text.isNotEmpty &&
              isPhoneIncreased) {
            print('telefon validation tamamlandı');
            counter--;
            isPhoneDecreased = true;
            isPhoneIncreased = false;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Kiralamayı Tamamla'),
      ),
      body: widget.shipper == null
          ? FutureBuilder(
              future: _viewModel.getShipperDetails(widget.shipperID),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasData) {
                  widget.shipper = asyncSnapshot.data;
                  return buildFinishPageBody(context, _viewModel, widget.order);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
          : buildFinishPageBody(context, _viewModel, widget.order),
    );
  }

  Widget buildFinishPageBody(
      BuildContext context, ViewModel _viewModel, Order order) {
    widget.shipper.displayingShippingPrice = widget.price;
    return Stack(
      children: [
        isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(),
        Column(
          children: [
            Expanded(
              child: CircleAvatar(
                radius: context.dynamicHeight(0.13),
                child: photos[counter],
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView(
                padding: context.paddingAllLow,
                children: [
                  // buildUserEmailText(_viewModel),
                  Padding(
                      padding: context.paddingVerticalLow,
                      child: buildUserRealNameText(_viewModel)),
                  Padding(
                      padding: context.paddingVerticalLow,
                      child: buildPhoneNumber(_viewModel)),
                  Padding(
                      padding: context.paddingVerticalLow,
                      child: buildFloorCount(order)),
                  // buildAdressText(_viewModel, order),
                  Padding(
                      padding: context.paddingVerticalLow,
                      child: buildFloorDialog(_viewModel, order)),
                  Padding(
                      padding: context.paddingVerticalLow,
                      child: buildFloorNumber(order)),
                  Padding(
                      padding: context.paddingVerticalLow,
                      child: buildDate(order)),
                  okudumOnayliyorumText(),
                  alertText(),
                ],
              ),
            ),
            //%100 olduysa da yapabiliriz
            isChecked
                ? Container(
                    width: double.infinity,
                    height: context.dynamicHeight(0.054),
                    child: MaterialButton(
                      onPressed: isChecked
                          ? () {
                              if (_phoneKey.currentState.validate() &&
                                  _userRealNameKey.currentState.validate() &&
                                  _allAddressKey.currentState.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                var finishedShipping = FinishedShipping(
                                    price: widget.price,
                                    phoneNumber: _phoneController.text,
                                    shipperName: widget.shipper.name,
                                    shippingDate:
                                        Timestamp.fromDate(order.dateAndTime),
                                    shipperID: widget.shipper.id,
                                    userID: _viewModel.user.userID,
                                    shipperPhotoUrl:
                                        widget.shipper.shippingVehiclePhotoUrl,
                                    location: order.address,
                                    locationsToTransport:
                                        _allAddressController.text,
                                    transportCount: order.transportationCount,
                                    transportedFloors: order.floorsToTransport);
                                _viewModel
                                    .addFinishedShipping(finishedShipping,
                                        _viewModel.user, widget.shipper)
                                    .then((value) async {
                                  await PlatformDuyarliAlertDialog(
                                    title: "Kiralama Başarılı",
                                    body:
                                        "Kiralama başarıyla tamamlandı. En kısa sürede sizinle iletişime geçilecektir.",
                                    mainButtonText: "Tamam",
                                  ).show(context).then((value) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                });
                              }
                            }
                          : null,
                      color: Colors.green,
                      child: Text('Kiralamayı Tamamla'),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ],
    );
  }

  Widget alertText() {
    return InkWell(
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
                contentPadding: context.paddingAllMedium,
                title: Align(
                    alignment: Alignment.center,
                    child: Text('Fiyatlandırmaya Etki Eden Durumlar')),
                children: [
                  Container(
                    width: 500,
                    height: 250,
                    child: Scrollbar(
                      controller: _scrollController,
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          Text("Fiyatlandırma politikamızda seçtiğiniz sonuçlar doğrultusunda size çıkan uygun sonuçta listelenen asansörlerde ki fiyatlandırma tüm şartların normal bir şekilde olduğu zaman karşınıza çıkan bir fiyat tarifesidir." +
                              "Genellikle bu fiyatlandırmalar üzerinden çok fazla oynama olmamaktadır. Ham ücret üzerinden hesaplanan ücretin artması veya azalmasında birden çok değişken yer almaktadır bunlar:\n\n" +
                              "-Taşınacak yükün türü ve miktarı\n\n" +
                              "-Asansörün kullanım süresi\n\n" +
                              "-Taşıma yapılacak binanın şekli, önündeki engelleri vb. faktörler\n\n" +
                              "-Taşıma yapılacak adresin uzaklığı ( Şehir merkezindeki bir firmanın ilçeye gitmesi vs.)\n\n" +
                              "-Asansörün kullanılacağı taraf sayısı\n\n" +
                              "Bu ve bunun gibi birçok sebepten dolayı fiyatlandırma da artış ve azalışlar söz konusu olmaktadır." +
                              "Siparişi tamamladıktan sonra size uygun olan firma sizinle iletişime geçecektir.")
                        ],
                      ),
                    ),
                  )
                ],
              );
            });
      },
      child: Row(
        children: [
          Flexible(
              child: IconButton(
            icon: Icon(
              MaterialCommunityIcons.account_badge_alert_outline,
              color: Colors.red,
            ),
            onPressed: null,
          )),
          Flexible(
            flex: 5,
            child: Text(
              'Fiyatlandırmaya Etki Eden Durumlar',
              style: context.theme.textTheme.bodyText1
                  .copyWith(color: Colors.blue[900]),
            ),
          )
        ],
      ),
    );
  }

  Widget okudumOnayliyorumText() {
    return Row(
      children: [
        Checkbox(
            value: isChecked,
            activeColor: Colors.green,
            onChanged: (bool newValue) {
              setState(() {
                isChecked = newValue;
                if (isChecked == false && isIsCheckedIncreased) {
                  if (counter > 0) {
                    counter--;
                    isIsCheckedIncreased = false;
                  }
                } else {
                  if (counter < photos.length - 1) {
                    counter++;
                    isIsCheckedIncreased = true;
                  }
                }
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
                              contentPadding: context.paddingAllMedium,
                              title: Align(
                                  alignment: Alignment.center,
                                  child: Text('Kiralama Sözleşmesi')),
                              children: [
                                Container(
                                  width: 500,
                                  height: 250,
                                  child: Scrollbar(
                                    child: ListView(
                                      children: [
                                        Text(_utils.kiralamaSozlesmesi()),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    child: Text("Kiralama Sözleşmesi",
                        style: context.theme.textTheme.bodyText1
                            .copyWith(color: Colors.blue[900])),
                  ),
                ),
                WidgetSpan(
                  child: Text(
                    " hakkındaki aydınlatma formunu",
                  ),
                ),
                WidgetSpan(
                  child: Text(
                    "okudum ve kabul ediyorum.",
                  ),
                )
                // WidgetSpan(
                //   child: Text(
                //     "okudum ve kabul ediyorum.",
                //   ),
                // )
              ],
            ),
          ),
        )
        // Flexible(
        //   child: InkWell(
        //     onTap: () {
        //       showDialog(
        //           context: context,
        //           builder: (context) {
        //             return SimpleDialog(
        //               titlePadding: EdgeInsets.fromLTRB(
        //                   context.dynamicWidth(0.03),
        //                   context.dynamicHeight(0.02),
        //                   context.dynamicWidth(0.03),
        //                   0.0),
        //               contentPadding: context.paddingAllMedium,
        //               title: Align(
        //                   alignment: Alignment.center,
        //                   child: Text('Rezervasyon Sözleşmesi')),
        //               children: [
        //                 Container(
        //                   width: context.dynamicWidth(1),
        //                   height: context.dynamicHeight(0.35),
        //                   child: Scrollbar(
        //                     controller: _scrollController,
        //                     child: ListView(
        //                       controller: _scrollController,
        //                       children: [Text(_utils.kiralamaSozlesmesi())],
        //                     ),
        //                   ),
        //                 )
        //               ],
        //             );
        //           });
        //     },
        //     child: Text(
        //       ' Rezervasyon Sözleşmesi',
        //       style: context.theme.textTheme.bodyText2
        //           .copyWith(color: Colors.blue[900]),
        //     ),
        //   ),
        // ),
        // Flexible(
        //   child: Text(
        //     ' hakkındaki aydınlatma formunu okudum ve kabul ediyorum.',
        //   ),
        // ),
      ],
    );
  }

  Widget buildFloorDialog(ViewModel viewModel, Order order) {
    return InkWell(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.zero,
                children: [
                  Container(
                    width: context.dynamicWidth(1),
                    height: context.dynamicHeight(0.6),
                    child: buildAdressText(viewModel, order),
                  )
                ],
              );
            });
      },
      child: Form(
        key: _allAddressKey,
        child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return 'Lütfen taşınacak adresleri seçiniz';
            } else {
              return null;
            }
          },
          minLines: 2,
          maxLines: 5,
          controller: _allAddressController,
          readOnly: true,
          decoration: InputDecoration(
            errorStyle: TextStyle(color: context.theme.errorColor),
            hintText: 'Taşınacak adresleri giriniz',
            enabled: false,
            prefixIcon: Icon(Icons.location_on),
            contentPadding:
                EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
      ),
    );
  }

  TextFormField buildDate(Order order) {
    return TextFormField(
      readOnly: true,
      initialValue: _utils.printDate(order.dateAndTime) ?? '',
      decoration: InputDecoration(
        labelText: 'Taşınacak Zaman',
        prefixIcon: Icon(
          AntDesign.calendar,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    );
  }

  TextFormField buildFloorNumber(Order order) {
    return TextFormField(
      readOnly: true,
      initialValue: printFloors(order) ?? '',
      decoration: InputDecoration(
        labelText: 'Taşınacak Katlar',
        prefixIcon: Icon(Icons.add),
        contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    );
  }

  TextFormField buildFloorCount(Order order) {
    return TextFormField(
      readOnly: true,
      initialValue: order.transportationCount.toString() + ' Kat' ?? '',
      decoration: InputDecoration(
        labelText: 'Taşınacak Kat Sayısı',
        prefixIcon: Icon(AntDesign.solution1),
        contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    );
  }

  Widget buildPhoneNumber(ViewModel _viewModel) {
    return Form(
      key: _phoneKey,
      child: TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          // labelText: 'Telefon Numarası',
          hintText: 'Örnek(05530751438)',
          prefixIcon: Icon(Icons.add_call),
          contentPadding:
              EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      ),
    );
  }

  Widget buildAdressText(ViewModel _viewModel, Order order) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: context.dynamicHeight(0.02),
              left: context.veryLowValue,
              right: context.veryLowValue,
              bottom: context.dynamicHeight(0.01),
            ),
            child: Text(
              'Taşınacak Adresler',
              style: context.theme.textTheme.headline6
                  .copyWith(wordSpacing: 0.1, fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: order.transportationCount,
              itemBuilder: (context, index) {
                // print('Controller sayımız : ' +
                //     _addressControllers.length.toString() +
                //     ' Key sayımız : ' +
                //     _addressKeys.length.toString());
                return Padding(
                  padding: context.paddingAllLow,
                  child: Form(
                    key: _addressKeys[index],
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Lütfen en az bir adres giriniz';
                        } else if (value.length < 10) {
                          return 'Lütfen detaylı bir şekilde adres giriniz';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _addressControllers[index].text = value;
                      },
                      controller: _addressControllers[index],
                      minLines: 2,
                      maxLines: 6,
                      // initialValue: _viewModel.user.location ?? '',
                      decoration: InputDecoration(
                        labelText: 'Adres ${index + 1}',
                        prefixIcon: Icon(Icons.location_on),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Padding(
          //   padding: context.paddingHorizontalLow,
          //   child: Row(
          //     children: [
          //       Icon(
          //         Icons.dangerous,
          //         color: Colors.red,
          //       ),
          //       Flexible(
          //         child: Text(
          //             'Taşınacak adres aynı ise tek bir adres girmeniz yeterli olacaktır.'),
          //       ),
          //     ],
          //   ),
          // ),
          SocialLoginButton(
            onPressed: () {
              String controllerText = '';
              var sayac = 1;
              bool isValidated = true;

              _addressKeys.forEach((element) {
                if (!element.currentState.validate()) {
                  isValidated = false;
                }
                ;
              });
              if (isValidated) {
                _addressKeys.forEach((element) {
                  element.currentState.save();
                });
                _addressControllers.forEach((element) {
                  // controllerText += '$sayac . Adres : ${element.text} \n';
                  controllerText += '${element.text}\n';
                  sayac++;
                });
                _allAddressController.text = controllerText;
                Navigator.pop(context);
              } else {
                print("Validate edip tekrar dene");
              }
            },
            buttonText: Text('Adresleri Kaydet'),
            borderRadius: 24,
            buttonColor: context.theme.buttonColor,
          )
        ],
      );
    });
  }

  Widget buildUserRealNameText(ViewModel _viewModel) {
    return Form(
      key: _userRealNameKey,
      child: TextFormField(
        validator: (value) {
          if (value.length <= 2) {
            return 'En az 2 karakter giriniz';
          } else {
            return null;
          }
        },
        readOnly: true,
        initialValue: _viewModel.user.fullName ?? '',
        decoration: InputDecoration(
          labelText: 'İsim-Soyisim',
          prefixIcon: Icon(MaterialCommunityIcons.human_male_female),
          contentPadding:
              EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      ),
    );
  }

  TextFormField buildUserEmailText(ViewModel _viewModel) {
    return TextFormField(
      readOnly: true,
      initialValue: _viewModel.user.email ?? '',
      decoration: InputDecoration(
        labelText: 'E-posta',
        prefixIcon: Icon(Icons.email),
        contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    );
  }

  isValidPhone(var phoneNumber) {
    var pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    var regExp = RegExp(pattern);
    if (phoneNumber.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(phoneNumber)) {
      return false;
    }
    return true;
  }

  printFloors(Order order) {
    String floors = '';
    int sayac = 0;
    for (int kat in order.floorsToTransport) {
      if (sayac == order.floorsToTransport.length - 1) {
        floors += kat.toString() + '.Kat';
      } else {
        floors += kat.toString() + '.Kat, ';
      }
      sayac++;
    }
    return floors;
  }
}
