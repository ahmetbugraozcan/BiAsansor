import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/errors.dart';
import 'package:flutter_biasansor/screens/auth_pages/create_account_page.dart';
import 'package:flutter_biasansor/screens/auth_pages/log_in_with_email.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_alert_dialog.dart';
import 'package:flutter_biasansor/widgets/social_log_in_button.dart';
import 'package:provider/provider.dart';

FirebaseAuthException myHata;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (myHata != null) {
        PlatformDuyarliAlertDialog(
          title: 'Giriş Yapma Hata',
          body: Errors.showError(myHata.code),
          mainButtonText: 'Tamam',
        ).show(context).then((value) => myHata = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Bu sayfayı expandedlar ile daha iyi yapabiliriz bir ara bak buraya da
    final _viewModel = Provider.of<ViewModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          Spacer(),
          buildHosgeldinizText(context),
          buildGirisYapTextWithPadding(context),
          Expanded(flex: 4, child: buildLogoContainer(context)),
          buildSosyalMedyaGirisiText(context),
          Expanded(flex: 2, child: buildButtonRow(context, _viewModel)),
          Expanded(child: buildEmailGirisYapText(context)),
          Expanded(child: buildGirisYapButton(context)),
          Expanded(child: buildHesabinizYokMuText(context)),
          Spacer(),
        ],
      ),
    );
  }

  Text buildEmailGirisYapText(BuildContext context) {
    return Text('veya email ile giriş yapın',
        style:
            context.theme.textTheme.bodyText2.copyWith(color: Colors.black54));
  }

  Widget buildHesabinizYokMuText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.dynamicHeight(0.03)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Hesabınız yok mu? ",
              style: context.theme.textTheme.bodyText2
                  .copyWith(color: Colors.black54)),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => CreateAccountPage()));
            },
            child: Text("Kayıt olun",
                style: context.theme.textTheme.bodyText2
                    .copyWith(color: Colors.blue[900])),
          )
        ],
      ),
    );
  }

  Widget buildGirisYapButton(BuildContext context) {
    return SocialLoginButton(
      // height: context.dynamicHeight(0.12),
      width: context.dynamicWidth(0.85),
      buttonColor: context.theme.buttonColor,

      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginWithEmailPage(),
                fullscreenDialog: true));
      },
      buttonText: Text(
        'Giriş yap',
        style: context.theme.textTheme.button.copyWith(color: Colors.white),
      ),
    );
  }

  Row buildButtonRow(BuildContext context, ViewModel _viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Expanded(
          flex: 5,
          child: buildGoogleButton(context, _viewModel),
        ),
        Spacer(),
        Expanded(
          flex: 5,
          child: buildFacebookButton(context, _viewModel),
        ),
        Spacer(),
      ],
    );
  }

  Widget buildFacebookButton(BuildContext context, ViewModel _viewModel) {
    return SocialLoginButton(
      height: context.dynamicHeight(0.08),
      buttonColor: context.facebookColor,
      onPressed: () async {
        try {
          await _viewModel.signInWithFacebook();
        } on PlatformException catch (ex) {
          // myHata = ex; burası çalışmıyor sanırım artık
          debugPrint('Oturum açma hata login page : ' + ex.toString());
        } on FirebaseAuthException catch (ex) {
          debugPrint("burada yakaladık authexception : " + ex.toString());
          myHata = ex;
        }
      },
      buttonImage: Image.asset(
        'assets/facebook_logo.png',
        scale: 20,
      ),
    );
  }

  Widget buildGoogleButton(BuildContext context, ViewModel _viewModel) {
    return SocialLoginButton(
      height: context.dynamicHeight(0.08),
      buttonColor: context.googleRedColor,
      onPressed: () async {
        try {
          await _viewModel.signInWithGoogle();
        } on PlatformException catch (ex) {
          // myHata = ex;
          debugPrint("Oturum açma hata login page : " + ex.code);
        } on FirebaseAuthException catch (ex) {
          debugPrint(
              "google burada yakaladık authexception : " + ex.toString());
          myHata = ex;
        } catch (ex) {
          debugPrint("en son yakalayabildik : " + ex.toString());
        }
        if (_viewModel.user != null) {
          print('Email : ' + _viewModel.user.email);
        }
      },
      buttonImage: Image.asset(
        'assets/google_white.png',
        scale: 20,
      ),
    );
  }

  Text buildSosyalMedyaGirisiText(BuildContext context) {
    return Text('Sosyal medya hesapları ile giriş yapın',
        style:
            context.theme.textTheme.bodyText2.copyWith(color: Colors.black54));
  }

  Text buildHosgeldinizText(BuildContext context) =>
      Text('Hoşgeldiniz', style: context.theme.textTheme.headline5);

  Padding buildGirisYapTextWithPadding(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.03)),
      child: Text('Uygulamayı Kullanmak İçin Giriş Yapın Veya Kaydolun.',
          style: context.theme.textTheme.bodyText2
              .copyWith(color: Colors.black54)),
    );
  }

  Container buildLogoContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.01)),
      // height: context.dynamicHeight(0.20),
      // color: Colors.red,
      child: Image.asset(
        'assets/biasansor_genis_logo.png',
        scale: 24,
      ),
    );
  }
}
