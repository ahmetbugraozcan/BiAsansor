import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/errors.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_alert_dialog.dart';
import 'package:flutter_biasansor/widgets/social_log_in_button.dart';
import 'package:provider/provider.dart';

// var myHata;
class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  String email;
  String sifre;
  String fullName;
  bool _hidePassword;

  @override
  void initState() {
    super.initState();
    _hidePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);
    return _viewModel.state == ViewState.Busy
        ? IgnorePointer(child: buildCreateAccountPageBody(context, _viewModel))
        : buildCreateAccountPageBody(context, _viewModel);
  }

  SafeArea buildCreateAccountPageBody(
      BuildContext context, ViewModel _viewModel) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.05)),
          child: Stack(
            children: [
              _viewModel.state == ViewState.Busy
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(),
              Column(
                children: [
                  Spacer(flex: 1),
                  buildHesapOlusturText(context),
                  Spacer(flex: 2),
                  buildFullNameForm(),
                  Spacer(flex: 2),
                  buildEmailForm(),
                  Spacer(flex: 2),
                  buildPasswordForm(),
                  Spacer(flex: 2),
                  buildSignInButton(context, _viewModel),
                  Spacer(flex: 15),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignInButton(BuildContext context, ViewModel _viewModel) {
    return SocialLoginButton(
      borderRadius: 26,
      height: context.dynamicHeight(0.065),
      width: context.dynamicWidth(1),
      buttonText: Text(
        'Kayıt Ol',
        style: context.theme.textTheme.button.copyWith(color: Colors.white),
      ),
      onPressed: () async {
        var isCompleted = true;
        _nameKey.currentState.validate();
        _passwordKey.currentState.validate();
        _emailKey.currentState.validate();

        if (_nameKey.currentState.validate() &&
            _passwordKey.currentState.validate() &&
            _emailKey.currentState.validate()) {
          try {
            await _viewModel.createUserWithEmailAndPassword(
                email, sifre, fullName);
          } on PlatformException catch (ex) {
            isCompleted = false;
            debugPrint(
                'PlatformException kullanıcı oluşturma hata : ' + ex.code);
          } on FirebaseAuthException catch (ex) {
            debugPrint('firebaseauthexc kullanıcı oluşturma hata: ' + ex.code);
            isCompleted = false;
            // myHata = ex;
            await PlatformDuyarliAlertDialog(
              title: 'Giriş Yapma Hata',
              body: Errors.showError(ex.code),
              mainButtonText: 'Tamam',
            ).show(context);
          } finally {
            if (isCompleted) {
              Navigator.pop(context);
            }
          }
        }
      },
      buttonColor: context.theme.buttonColor,
    );
  }

  Form buildPasswordForm() {
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _passwordKey,
        child: TextFormField(
          obscureText: _hidePassword,
          validator: (value) {
            //en az 8 karakter ,bir büyük harf ve 1 sayı içeren şifre

            var pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
            var regExp = RegExp(pattern);
            if (!regExp.hasMatch(value)) {
              return 'En az 8 karakter, bir büyük harf ve sayı içeren bir şifre giriniz.';
            } else {
              sifre = value;
              return null;
            }
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(
                  _hidePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black38,
                ),
                onPressed: () {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                }),
            hintText: 'Şifre',
          ),
        ));
  }

  Form buildEmailForm() {
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _emailKey,
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
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
          ),
        ));
  }

  Form buildFullNameForm() {
    return Form(
        key: _nameKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          validator: (value) {
            if (value.length < 3) {
              return 'Lütfen tam adınızı giriniz (En az 3 karakter).';
            } else {
              fullName = value;
              return null;
            }
          },
          decoration: InputDecoration(
            hintText: 'İsim-Soyisim',
          ),
        ));
  }

  Align buildHesapOlusturText(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Hesap Oluştur',
          style: context.theme.textTheme.headline6,
        ));
  }
}
