import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/errors.dart';
import 'package:flutter_biasansor/locator.dart';
import 'package:flutter_biasansor/model/useracc.dart';
import 'package:flutter_biasansor/screens/notifications_page.dart';
import 'package:flutter_biasansor/screens/profile_settings_page.dart';
import 'package:flutter_biasansor/screens/show_all_finished_shippings_to_admin.dart';
import 'package:flutter_biasansor/screens/show_membership_forms_to_admin.dart';

import 'package:flutter_biasansor/services/firestore_database_service.dart';
import 'package:flutter_biasansor/utils.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_alert_dialog.dart';
import 'package:flutter_biasansor/widgets/social_log_in_button.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

//TODO EMAİL DOĞRULAMA YARIDA KALDI BUNA ÇÖZÜM BULDUKTAN SONRA DÖNELİM TEKRAR
class _ProfilePageState extends State<ProfilePage> {
  var firestoreDBService = locator<FirestoreDatabaseService>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isUserEmailVerified;
  Timer _timer;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //TODO bu yapılacak
    Future(() async {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        await FirebaseAuth.instance.currentUser
          ..reload();
        var user = await FirebaseAuth.instance.currentUser;
        if (user.emailVerified) {
          print("doğrulandı");
          setState(() {
            _isUserEmailVerified = user.emailVerified;
          });
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context, listen: true);
    var _user = _viewModel.user;

    return isLoading
        ? Stack(
            children: [
              buildProfilePageScaffold(context, _user, _viewModel),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          )
        : buildProfilePageScaffold(context, _user, _viewModel);
  }

  Widget buildProfilePageScaffold(
      BuildContext context, UserAcc _user, ViewModel _viewModel) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          _user.isAdmin ? buildAdminFormFieldsButton() : SizedBox(),
          buildNotificationButton(context),
          buildSettingsButton(),
        ],
        title: Text(
          'Profil',
          style: context.theme.textTheme.headline5,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Row(
                children: [
                  Spacer(),
                  Expanded(
                    flex: 10,
                    child: buildUserAvatar(context, _user),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 20,
                    child: buildUserNameText(_user, context),
                  ),
                  Spacer()
                ],
              ),
            ),
            Expanded(
              flex: 22,
              child: Card(
                elevation: 20,
                child: ListView(
                  children: [
                    _isUserEmailVerified ??
                            FirebaseAuth.instance.currentUser.emailVerified ??
                            false
                        ? buildEmailVerifiedCard(context)
                        : buildEmailNotVerifiedCard(context),
                    buildKullaniciAdiListTile(_user),
                    buildEmailListTile(_user),
                    buildKonumListTile(_user),
                    buildPhoneNumberListTile(_user),
                    // SizedBox(height: context.dynamicHeight(0.01)),
                    buildWhatsappGif()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell buildWhatsappGif() {
    return InkWell(
      onTap: () {
        FlutterOpenWhatsapp.sendSingleMessage('${Utils.biasansorNumber}', '');
      },
      child: Image.asset(
        "assets/asansor_profil.gif",
        scale: 4,
      ),
    );
  }

  Widget buildNotificationButton(BuildContext context) {
    return Padding(
        padding: context.paddingAllLow,
        child: IconButton(
          icon: Icon(Icons.notification_important),
          onPressed: () {
            var _viewModel = Provider.of<ViewModel>(context, listen: false);
            if (_viewModel.user.isAdmin) {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ShowAllFinishedShippingsToAdmin()));
            } else {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => NotificationsPage()));
            }
          },
        ));
  }

  IconButton buildAdminFormFieldsButton() {
    return IconButton(
        icon: Icon(Icons.mail),
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => ShowMembershipFormsToAdmin()));
        });
  }

  IconButton buildSettingsButton() {
    return IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ProfileSettingsPage(),
              )).then((value) async {});
        });
  }

  ListTile buildKullaniciAdiListTile(UserAcc _user) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text('Kullanıcı Adı'),
      subtitle: Text(_user.userName),
    );
  }

  ListTile buildEmailListTile(UserAcc _user) {
    return ListTile(
      title: Text("E-posta"),
      leading: Icon(Icons.mail),
      subtitle: Text(_user.email),
    );
  }

  ListTile buildPhoneNumberListTile(UserAcc _user) {
    return ListTile(
      leading: Icon(Icons.phone),
      title: Text('Telefon Numarası'),
      subtitle: Text(_user.phoneNumber),
    );
  }

  ListTile buildKonumListTile(UserAcc _user) {
    return ListTile(
      leading: Icon(Icons.location_on),
      title: Text('Konum'),
      subtitle: Text(_user.location),
    );
  }

  ListTile buildAdresListTile() {
    return ListTile(
      leading: Icon(Icons.map),
      title: Text('Adres'),
      subtitle: Text(' '),
    );
  }

  Widget buildUserAvatar(BuildContext context, UserAcc _user) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(300),
        child: Image.network(_user.profileUrl, fit: BoxFit.cover,
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
        }),
      ),
    );
  }

  Widget buildUserNameText(UserAcc _user, BuildContext context) {
    return Text('Hoşgeldiniz, ' + _user.fullName,
        style: context.theme.textTheme.headline6
            .copyWith(fontWeight: FontWeight.w400));
  }

  Widget buildEmailVerifiedCard(BuildContext context) {
    return Card(
      color: Colors.green,
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.verified_user,
            size: 33,
            color: Colors.white,
          ),
        ),
        title: Text(
          'E-Posta Adresiniz Doğrulanmıştır.',
          style:
              context.theme.textTheme.bodyText2.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Card buildEmailNotVerifiedCard(BuildContext context) {
    final _viewModel = Provider.of<ViewModel>(context, listen: false);
    return Card(
      color: Colors.red,
      child: ListTile(
        onTap: () async {
          try {
            await _viewModel.sendEmailVerification();
            print("Buradayuız");
            await PlatformDuyarliAlertDialog(
              mainButtonText: 'Tamam',
              title: 'Doğrulama e-postası gönderildi',
              body:
                  '${_viewModel.user.email} adresine doğrulama e-postası gönderdik. Spam kutunuzu kontrol etmeyi unutmayın.',
            ).show(context);
          } on FirebaseAuthException catch (ex) {
            debugPrint("Hata : " + ex.toString());
            await PlatformDuyarliAlertDialog(
              mainButtonText: 'Tamam',
              title: 'E-posta gönderilirken hata',
              body: Errors.showError(ex.code),
            ).show(context);
          }
        },
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.error,
            size: 33,
            color: Colors.white,
          ),
        ),
        title: Text(
          'E-posta Adresiniz Henüz Doğrulanmamıştır.',
          style:
              context.theme.textTheme.bodyText2.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
