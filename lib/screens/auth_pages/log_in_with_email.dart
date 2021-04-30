import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/errors.dart';

import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_alert_dialog.dart';
import 'package:flutter_biasansor/widgets/social_log_in_button.dart';
import 'package:provider/provider.dart';

FirebaseAuthException myHata;

class LoginWithEmailPage extends StatefulWidget {
  @override
  _LoginWithEmailPageState createState() => _LoginWithEmailPageState();
}

class _LoginWithEmailPageState extends State<LoginWithEmailPage> {
  String email;
  String sifre;
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hidePassword;
  @override
  void initState() {
    super.initState();
    _hidePassword = true;
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   if (myHata != null) {
    //     PlatformDuyarliAlertDialog(
    //       title: 'Giriş Yapma Hata',
    //       body: Errors.showError(myHata.code),
    //       mainButtonText: 'Tamam',
    //     ).show(context);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<ViewModel>(context);
    return _viewModel.state == ViewState.Busy
        ? IgnorePointer(child: buildLoginPageBody(context, _viewModel))
        : buildLoginPageBody(context, _viewModel);
  }

  SafeArea buildLoginPageBody(BuildContext context, ViewModel _viewModel) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: buildAppbarCloseButton(context),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.dynamicWidth(0.05),
              vertical: context.dynamicHeight(0.02)),
          child: Stack(
            children: [
              _viewModel.state == ViewState.Busy
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(),
              Column(
                children: [
                  Spacer(flex: 1),
                  buildGirisYapText(context),
                  Spacer(flex: 2),
                  Form(
                      key: _emailKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        validator: (value) {
                          var emailRegExp = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Lütfen geçerli bir email giriniz';
                          } else {
                            email = value;
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Email',
                          // border: OutlineInputBorder(
                          //     borderRadius: BorderRadius.all(Radius.circular(8)))
                        ),
                      )),
                  Spacer(flex: 1),
                  Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _passwordKey,
                      child: TextFormField(
                        obscureText: _hidePassword,
                        validator: (value) {
                          if (value.length < 1) {
                            return 'Şifrenizi giriniz';
                          } else {
                            sifre = value;
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Şifre',
                            suffixIcon: IconButton(
                                icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black38,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                })
                            // border: OutlineInputBorder(
                            //     borderRadius: BorderRadius.all(Radius.circular(8)))
                            ),
                      )),
                  Spacer(flex: 1),
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      GlobalKey<FormState> _resettedEmailKey =
                          GlobalKey<FormState>();
                      var resettedEmail;
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: Container(
                                width: 400,
                                height: 600,
                                color: Colors.red,
                                child: Scaffold(
                                  appBar: AppBar(
                                    leading: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Icon(Icons.close)),
                                    title: Text("Şifre Sıfırla"),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ),
                                  body: Column(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: context.paddingAllLow,
                                          child: Form(
                                              key: _resettedEmailKey,
                                              child: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode.always,
                                                onSaved: (value) {
                                                  resettedEmail = value;
                                                },
                                                validator: (value) {
                                                  var emailRegExp = RegExp(
                                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                                  if (!emailRegExp
                                                      .hasMatch(value)) {
                                                    return 'Lütfen geçerli bir email giriniz';
                                                  } else {
                                                    email = value;
                                                    return null;
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    12)),
                                                        borderSide:
                                                            BorderSide()),
                                                    labelText:
                                                        'Şifresi sıfırlanacak e-posta adresini giriniz.'),
                                              )),
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          if (_resettedEmailKey.currentState
                                              .validate()) {
                                            _resettedEmailKey.currentState
                                                .save();
                                            print(resettedEmail);

                                            try {
                                              _viewModel
                                                  .sendPasswordResetEmail(
                                                      resettedEmail)
                                                  .then((value) {
                                                PlatformDuyarliAlertDialog(
                                                  title: "İşlem Başarılı",
                                                  body:
                                                      "$resettedEmail adresine sıfırlama isteği gönderildi. Spam kutunuzu kontrol etmeyi unutmayın.",
                                                  mainButtonText: "Tamam",
                                                ).show(context);
                                              });
                                            } on FirebaseAuthException catch (ex) {
                                              debugPrint(
                                                  "HATA YAKALANDI ŞİFRE SIFIRLAMA İSTEĞİ : " +
                                                      ex.toString());
                                              // PlatformDuyarliAlertDialog(
                                              //   title: "İşlem Başarısız",
                                              //   body:
                                              //   "$resettedEmail adresine sıfırlama isteği gönderildi. Spam kutunuzu kontrol etmeyi unutmayın.",
                                              //   mainButtonText: "Tamam",
                                              // );
                                            }
                                          } else {
                                            print("Validate edip tekrar dene");
                                          }
                                        },
                                        color: context.theme.buttonColor,
                                        child: Text(
                                          "Sıfırlama Maili Gönder",
                                          style: context.theme.textTheme.button
                                              .copyWith(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Şifremi Unuttum',
                          style: context.theme.textTheme.bodyText1
                              .copyWith(color: Colors.blue[900]),
                        )),
                  )),
                  Spacer(flex: 1),
                  SocialLoginButton(
                    elevation: 2,
                    borderRadius: 22,
                    height: context.dynamicHeight(0.06),
                    width: context.dynamicWidth(1),
                    buttonText: Text(
                      'Giriş Yap',
                      style: context.theme.textTheme.button
                          .copyWith(color: Colors.white),
                    ),
                    onPressed: () async {
                      var isCompleted = true;
                      _emailKey.currentState.validate();
                      _passwordKey.currentState.validate();
                      if (_emailKey.currentState.validate() &&
                          _passwordKey.currentState.validate()) {
                        try {
                          await _viewModel.signInWithEmailAndPassword(
                              email, sifre);
                        } on FirebaseAuthException catch (ex) {
                          isCompleted = false;
                          myHata = ex;
                          await PlatformDuyarliAlertDialog(
                            title: 'Giriş Yapma Hata',
                            body: Errors.showError(myHata.code),
                            mainButtonText: 'Tamam',
                          ).show(context).then((value) => myHata = null);

                          debugPrint("Oturum açma hata login pageee : " +
                              ex.toString());
                        } finally {
                          if (isCompleted) {
                            Navigator.pop(context);
                          }
                        }
                      }
                    },
                    buttonColor: context.theme.buttonColor,
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  // Text("Ya da"),
                  // Spacer(
                  //   flex: 2,
                  // ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SocialLoginButton(
                        width: context.dynamicWidth(0.2),
                        height: context.dynamicWidth(0.13),
                        shape: CircleBorder(),
                        buttonColor: context.facebookColor,
                        buttonImage: Image.asset(
                          "assets/facebook_logo.png",
                          scale: 25,
                        ),
                        onPressed: () async {
                          try {
                            await _viewModel.signInWithFacebook();
                          } on PlatformException catch (ex) {
                            // myHata = ex;
                            // await PlatformDuyarliAlertDialog(
                            //   title: 'Giriş Yapma Hata',
                            //   body: Errors.showError(myHata.code),
                            //   mainButtonText: 'Tamam',
                            // ).show(context).then((value) => myHata = null);

                            debugPrint("Oturum açma hata login pageee : " +
                                ex.toString());
                          } on FirebaseAuthException catch (ex) {
                            myHata = ex;
                            await PlatformDuyarliAlertDialog(
                              title: 'Giriş Yapma Hata',
                              body: Errors.showError(myHata.code),
                              mainButtonText: 'Tamam',
                            ).show(context).then((value) => myHata = null);

                            debugPrint(
                                "facebook burada yakaladık authexception : " +
                                    ex.toString());
                          } catch (ex) {
                            debugPrint("en son yakaladık");
                          }
                          if (_viewModel.user != null) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      SocialLoginButton(
                        width: context.dynamicWidth(0.2),
                        height: context.dynamicWidth(0.13),
                        shape: CircleBorder(),
                        buttonColor: context.googleRedColor,
                        buttonImage: Image.asset(
                          "assets/google_white.png",
                          scale: 25,
                        ),
                        onPressed: () async {
                          try {
                            await _viewModel.signInWithGoogle();
                          } on PlatformException catch (ex) {
                            // myHata = ex;
                            // await PlatformDuyarliAlertDialog(
                            //   title: 'Giriş Yapma Hata',
                            //   body: Errors.showError(myHata.code),
                            //   mainButtonText: 'Tamam',
                            // ).show(context).then((value) => myHata = null);

                            debugPrint("Oturum açma hata login pageee : " +
                                ex.toString());
                          } on FirebaseAuthException catch (ex) {
                            debugPrint(
                                "google burada yakaladık authexception : " +
                                    ex.toString());
                            myHata = ex;
                            await PlatformDuyarliAlertDialog(
                              title: 'Giriş Yapma Hata',
                              body: Errors.showError(myHata.code),
                              mainButtonText: 'Tamam',
                            ).show(context).then((value) => myHata = null);
                          } catch (ex) {
                            debugPrint("en son yakaladık : " + ex.toString());
                          }
                          if (_viewModel.user != null) {
                            Navigator.pop(context);
                            print('Email : ' + _viewModel.user.email);
                          }
                        },
                      ),
                    ],
                  ),
                  Spacer(flex: 13),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Align buildGirisYapText(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Giriş Yap',
          style: context.theme.textTheme.headline5,
        ));
  }

  InkWell buildAppbarCloseButton(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        //Klavye açıkken pop yapıldığında taşma hatası verdiğinden bunu yaptım
        Future.delayed(Duration(milliseconds: 100))
            .then((value) => Navigator.pop(context));
      },
      child: Icon(Icons.close),
    );
  }
}
