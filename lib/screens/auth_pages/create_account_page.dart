import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/errors.dart';
import 'package:flutter_biasansor/locator.dart';
import 'package:flutter_biasansor/utils.dart';
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
  var utils = locator<Utils>();
  String email;
  String sifre;
  String fullName;
  bool _hidePassword;
  bool checkBoxValue = false;
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
                  Spacer(),
                  buildSozlesmeRow(context),
                  Spacer(),
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

  Row buildSozlesmeRow(BuildContext context) {
    return Row(
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
                              contentPadding: context.paddingAllMedium,
                              title: Align(
                                  alignment: Alignment.center,
                                  child: Text('Üyelik Sözleşmesi')),
                              children: [
                                Container(
                                  width: 500,
                                  height: 250,
                                  child: Scrollbar(
                                    child: ListView(
                                      children: [
                                        Text(utils.uyelikSozlesmesi()),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    child: Text("Üyelik Sözleşmesi, ",
                        style: context.theme.textTheme.bodyText1
                            .copyWith(color: Colors.blue[900])),
                  ),
                ),
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
                                  child: Text('Gizlilik Sözleşmesi')),
                              children: [
                                Container(
                                  width: 500,
                                  height: 250,
                                  child: Scrollbar(
                                    child: ListView(
                                      children: [
                                        Text(utils.gizlilikSozlesmesi()),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    child: Text(
                      "Gizlilik Sözleşmesi",
                      style: context.theme.textTheme.bodyText1
                          .copyWith(color: Colors.blue[900]),
                    ),
                  ),
                ),
                WidgetSpan(child: Text(' ve ')),
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
                                    child: Text(
                                        'Kişisel Verilerin Korunması Sözleşmesi')),
                                children: [
                                  Container(
                                    width: 500,
                                    height: 250,
                                    child: Scrollbar(
                                      child: ListView(
                                        children: [
                                          Text(utils
                                              .kisiselVerilerinKorunmasiSozlesmesi())
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                      child: Text(
                        "Kişisel Verilerin Korunması Sözleşmesi ",
                        style: context.theme.textTheme.bodyText1
                            .copyWith(color: Colors.blue[900]),
                      ),
                    ),
                    style: context.theme.textTheme.bodyText1
                        .copyWith(color: Colors.blue[900])),
                WidgetSpan(
                  child: Text(
                    "hakkındaki aydınlatma formlarını okudum ve kabul ediyorum.",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
      onPressed: checkBoxValue == false
          ? null
          : () async {
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
                  debugPrint('PlatformException kullanıcı oluşturma hata : ' +
                      ex.code);
                } on FirebaseAuthException catch (ex) {
                  debugPrint(
                      'firebaseauthexc kullanıcı oluşturma hata: ' + ex.code);
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

  // String uyelikSozlesmesi() {
  //   return 'ÜYELİK SÖZLEŞMESİ\n'
  //       'Giriş\n'
  //       '1. Bi Asansör Kiralık Asansör Uygulaması, kullanıcılarına kiralık mobil asansör hizmet sağlayıcısı olarak'
  //       ' işlettiği www.biasansor.online ve Bi Asansör Mobil Uygulamaları üzerinden kullanıcıların araç'
  //       ' kiralamalarına aracılık ve rezervasyon hizmeti vermektedir. Başka bir ifadeyle Hizmet Alan ile Kiraya'
  //       'Veren arasında www.biasansor.online ve Bi Asansör Mobil Uygulamaları üzerinden “mobil asansör'
  //       ' kiralama sözleşmesi” kurulmasına ve/veya sözleşme kurulması için rezervasyon yapılmasına aracılık'
  //       ' yapan bir aracı hizmet sağlayıcı olup, bu meyanda kiralık mobil asansörlerin kiraya vereni(işleteni)'
  //       'konumundaki (üçüncü parti) çeşitli mobil asansör kiralama firmalarına ait araçların listelenmesi,'
  //       ' çeşitli kriterlere göre filtrelenmesi ve karşılaştırma yapılması imkânlarını sunmaktadır. Bi Asansör,'
  //       ' mobil asansör kiralamanıza aracılık eden bir aracı hizmet sağlayıcı olduğundan söz konusu hizmetin'
  //       ' eksiksiz ve kusursuz olması için üyelerimizin de site kullanım şartlarına uyması gerekmektedir.\n'
  //       '2. Kullanıcılar, Kullanıcı formunu doldurmak suretiyle Bi Asansör Mobil Uygulamasına üye olmakla'
  //       ' işbu sözleşmenin içerdiği hükümleri okuduklarını, anladıklarını, kabul ettiklerini ve onayladıklarını'
  //       ' kabul ve taahhüt etmektedirler.\n\n'
  //       '2. Taraflar ve Tanımlar\n\n'
  //       '2.1. İşbu Üyelik Sözleşmesi bir taraftan Bi Asansör Mobil Uygulamasına üye olan ve internet sitesi'
  //       ' altında sunulan hizmetleri kullanan ("Kullanıcı") arasında elektronik olarak onaylamıştır.\n'
  //       '2.2.Bi Asansör ve Kullanıcı tek tek “Taraf” ve birlikte “Taraflar” olarak anılacaktır.\n'
  //       '2.3. Site: Bi Asansör’ün kullanıcılarına hizmet verdiği www.biasansor.online alan adlı web sitesidir.\n'
  //       '2.4. Kullanıcı/Üye: Mobil uygulamaya üye olarak hizmet almaya başlayan gerçek ve/veya tüzel'
  //       ' kişiliktir.2.5. Hizmet: www.biasansor.online alan adı ve Bi Asansör Mobil Uygulama üzerinden listelenen'
  //       ' üçüncü taraf araç kiralama şirketlerine ait araçların kullanıcılara sergilenmesi, üçüncü taraf araç'
  //       ' kiralama şirketleri tarafından belirlenen/değiştirilen/güncellenen fiyat ve nitelikte araçların'
  //       ' kullanıcının kiralaması için gerekli iletişimin teknik altyapısının kurulması, kullanıcının seçtiği aracın'
  //       ' kiralanması noktasında kullanıcı ile üçüncü taraf araç kiralama şirketi arasında bir anlaşmanın'
  //       ' kurulması için aracılık edilmesi ve kullanıcının rezervasyonunun üçüncü taraf araç kiralama şirketine'
  //       ' iletilmesinden ibarettir.\n\n'
  //       '3. Sözleşmenin Konusu\n'
  //       '3.1.İşbu sözleşme ile Bi Asansör mobil uygulaması ve www.biasansor.online alan adında sisteme üye'
  //       ' olacak Gerçek ve/veya Tüzel kişi kullanıcılarına, üçüncü taraf araç kiralama şirketleri tarafından'
  //       ' belirlenen fiyat ve nitelikteki araçların kullanıcılara listelenmesine, kullanıcıların diledikleri tarih ve'
  //       ' fiyatlarda, diledikleri lokasyonlarda ve diledikleri nitelikte kiralık araç bulabilmesi adına üçüncü parti'
  //       ' araç kiralama şirketleri tarafından Bi Asansör mobil uygulaması veritabanına yüklenen verilerin tasnif'
  //       ' edilmesine, bu meyanda çeşitli tanıtım ve promosyon faaliyetlerinin gerçekleştirilmesine, listelenen'
  //       ' çeşitli araçların kullanıcılar tarafından üçüncü parti araç kiralama şirketlerinden kiralanmasına aracılık'
  //       ' edilmesine ve aracılık faaliyeti sonucu kira parasının anlaştığınız araç kiralama firması tarafından'
  //       ' kullanıcıdan tahsil edilmesine ilişkin tarafların karşılıklı hak ve yükümlülükleri düzenlenmektedir.\n\n'
  //       '4. Üyelik Bilgileri\n'
  //       '4.1. Bi Asansör platformu üzerinde elektronik posta hesabınız ile üyelik oluşturulması veya'
  //       ' oluşturduğunuz hesabın Facebook bilgilerinizin kullanılarak oluşturulması temel kuraldır. Daha önce'
  //       ' aynı e-posta adresiniz ile veya aynı Facebook hesabınızla üye olmuşsanız yeni üyeliğiniz kabul'
  //       ' edilmeyecektir.\n'
  //       '4.2. Kullanıcı, Bi Asansör platformuna üye olurken vermiş olduğu tüm bilgilerin doğru ve tam'
  //       ' olduğunu, sahte olmadığını, iş bu bilgilerin sahte ve/veya yanlış olmasından kaynaklanabilecek her'
  //       ' türlü zarardan ve ziyandan sorumlu olduğunu, Sistemin bu yönde uğrayabileceği her türlü zararı'
  //       ' tazmin edeceğini kabul, beyan ve taahhüt eder.\n'
  //       '4.3. Bi Asansör platformundan kiralamasını tamamladığınız araç kiralama rezervasyon aracılık'
  //       ' hizmetlerin (www.biasansor.online ve Bi Asansör/Android mobil uygulaması) size süresi içerisinde teslim edilebilmesi için üyelik bilgilerinin gerçeğe uygun ve eksiksiz bir şekilde doldurulması'
  //       ' gerekmektedir. Üyelik bilgilerinin yanlış veya hatalı doldurulması neticesinde teslimatınızın/ifanızın'
  //       ' taahhüt edilen süre içerisinde yapılamaması durumunda Bi Asansör herhangi bir sorumluluk kabul'
  //       ' etmez.\n\n'
  //       '5. Ticari Elektronik İletiler Hakkında\n'
  //       '5.1. Bi Asansör’e Üye olurken verdiğiniz, elektronik mail adresi, telefon ve/veya cep telefonunuz'
  //       ' aracılığı ile 6563 sayılı Kanun ve Ticari İletişim Ve Ticari Elektronik İletiler Hakkında Yönetmelik'
  //       ' gereğince rızanıza mukabil tarafınıza pazarlama ve tanıtım amaçlı Ticari Elektronik İleti gönderilebilir.'
  //       'Üye, dilediği zaman bu gönderimlerden ücretsiz olarak çıkarak pazarlama ve bilgilendirme amaçlı'
  //       ' iletileri almama hakkına haizdir.\n'
  //       '5.2. Bi Asansör, kendisine, Üye tarafından pazarlama ve tanıtım amaçlı elektronik ileti gönderime'
  //       ' ilişkin tüm onay kayıtları, onayın geçerliliğinin sona erdiği tarihten, ticari elektronik iletilere ilişkin'
  //       ' diğer kayıtları ise kayıt tarihinden itibaren üç yıl süreyle saklar.\n\n'
  //       '6. Genel Hak ve Yükümlülükleri\n'
  //       '6. 1. Bi Asansör, iş bu sözleşme konusu www.biasansor.online isimli alan adının ve Bi Asansör mobil'
  //       ' uygulamalarının sunduğu hizmetin kalitesine zarar vermemek şartı ile farklı bir alan adı ile'
  //       ' müşterilerine hizmet vermeye devam edebilir.\n'
  //       '6.2. Kullanıcı, Sistem’den hizmet kullanırken elde ettiği bilgileri, işbu sözleşme ile Site üzerinde yer'
  //       ' alan diğer sözleşme ve politika hükümleri çerçevesinde üçüncü kişilerle paylaşmayacağını kabul ve'
  //       ' taahhüt eder.\n'
  //       '6.3. Kullanıcı, Mobil Uygulama üyeliğinin, Kullanıcı bilgilerinin, Kullanıcı şifresinin gizliliği için gerekli'
  //       ' tedbirleri alır. Kullanıcı şifresinin üçüncü şahısların eline geçmesinden kaynaklanacak hukuki sorumluluk tamamen Kullanıcı’ya aittir. Kullanıcı şifresinin üçüncü kişilerin eline geçmesi neticesinde'
  //       ' üçüncü kişilerin ve/veya Bi Asansör’ün uğrayacağı tüm maddi ve manevi zararlar Kullanıcı’ya ait'
  //       ' olacaktır. Kullanıcı’nın bu yükümlülüğünü ihlali sonucu Bi Asansör’ün herhangi bir şekilde üçüncü'
  //       ' kişilere tazminat ödemesi veyahut Bi Asansör aleyhine idari para cezasına hükmedilmesi halinde,'
  //       ' uğradığı tüm zararı Kullanıcı’ya rücu edebilecektir.\n'
  //       '6.4. Üye olurken verdiğiniz e-posta adresi, adınız, soyadınız ve benzeri diğer bilgileriniz ile mobil'
  //       ' uygulama içerisinde gerçekleştireceğiniz diğer işlemler sonucu elde edilecek veriler sizin kişisel'
  //       ' bilgilerinizi oluşturmaktadır. Bi Asansör, Kullanıcı’dan her kişisel veri topladığı noktada Kullanıcı’yı'
  //       ' 6698 sayılı Kişisel Verilerin Korunması Kanunu’na uygun olarak aydınlatır ve gerektiği takdirde açık'
  //       ' rızalarını alır. Kullanıcı, Site ve uygulama (Sistem) içerisinde yer alan her bir form doldurma sırasında'
  //       ' ve Sistem’e bir IP adresi üzerinden ilk kez yapılan ziyaretlerde kendisine gösterilen Kişisel Verilerin'
  //       ' İşlenmesi Hakkında Aydınlatma Metni’ni okumalıdır.\n'
  //       '6.5. Bi Asansör, Site’nin ilgili alanlarında gösterilen Kişisel Verilerin İşlenmesi Hakkında Aydınlatma'
  //       ' Metni uyarınca bazı verilerinizi işlemek için açık rızanızı talep edebilir. Bu durumlarda Kullanıcı, Kişisel'
  //       ' Verilerin İşlenmesi Hakkında Aydınlatma Metni vasıtasıyla bilgilendirilir ve özgür iradesiyle açık rıza'
  //       ' verip vermemeye karar verir.\n'
  //       '6.6. Bi Asansör, www.biasansor.online ve Bi Asansör Mobil Uygulama’sında hiçbir surette kendi'
  //       ' adına ve hesabına araç kiralama hizmeti sunmamaktadır. Bi Asansör, üçüncü parti araç kiralama'
  //       ' şirketleri tarafından önceden belirtilen ve www.biasansor.online ve Bi Asansör Mobil Uygulamaları'
  //       ' veri tabanlarına yüklenen değişkenlik gösteren fiyatlandırma, lokasyon, ve benzeri özellikler ile'
  //       ' kullanıcıların kiralaması noktasında YALNIZCA ARACILIK FAALİYETİ göstermektedir.\n'
  //       '6.7. Bi Asansör, kullanıcıların araç kiralama taleplerini, ilgili aracın işleteni/maliki sıfatındaki üçüncü'
  //       ' parti araç kiralama şirketlerine iletmektedir. Kullanıcıların üçüncü parti araç kiralama şirketine'
  //       ' ödemekle yükümlü oldukları kira bedelini yine üçüncü parti araç kiralama şirketine ödemekle'
  //       ' yükümlülerdir bu esnada oluşabilecek her türlü durumdan Bi Asansör sorumlu değildir.\n'
  //       '6.8. Uygulama üzerinden ödeme yapılmamaktadır. Ödeme bilgilerinizi 3. şahıslar ile paylaşmanız'
  //       ' durumunda Bi Asansör hiçbir sorumluluk kabul etmemektedir.\n'
  //       '6.9. Bi Asansöre platformundan araç kiralama ile alacağınız hizmetler “stok” miktarları ile vb.'
  //       ' kriterler ile sınırlanmış olabilir. Getirilen sınırlama kiralanacak araç inceleme ve rezervasyon'
  //       ' oluşturma sayfasında ayrıntılı bir biçimde belirtilmektedir. Araç kiralama esnasında kiralayacağınız'
  //       ' aracın günün rezervasyonlarına ve hava durumuna göre iptal edilme hakkı Bi Asansör uygulamasında saklıdır. İptal edilen rezervasyonlarda hiçbir şekilde ücret talep edilmemekte 3. şahıslar tarafından'
  //       ' talep edilen ücretlerden Bi Asansör sorumlu değildir. İş bu sebeple Bi Asansör Sistem’de kiraya arz'
  //       ' edilen her ürünün / hizmetin tarafınızdan kiralama alınabilmesi garantisini vermez.\n'
  //       '6.10. Bi Asansör, verdiği hizmetler gereği kiralamayı tamamladıktan sonra ücreti sistem üzerinden'
  //       ' almamaktadır. Anlaşılan firma tarafından tahsil edilen ücret kapsamında firmamız sorumluluk kabul'
  //       ' etmeyecektir.\n'
  //       '6.11. Kullanıcılar, Bi Asansör Mobil Uygulamaları’ndan “araç kiralama talebi/rezervasyon”'
  //       ' yaptıklarında; ilgili aracın işleteni/maliki sıfatındaki üçüncü parti araç kiralama şirketi tarafından'
  //       ' tanzim edilen Araç Kiralama Sözleşmesi’ni kabul etmiş sayılırlar.\n'
  //       ' 6.12. Kullanıcı, Uygulama üyeliğinin, Kullanıcı bilgilerinin, Kullanıcı şifresinin gizliliği için gerekli'
  //       ' tedbirleri alır. Kullanıcı şifresinin üçüncü şahısların eline geçmesinden kaynaklanacak hukuki'
  //       ' sorumluluk tamamen Kullanıcıya aittir. Kullanıcı şifresinin 3. Kişilerin eline geçmesi neticesinde 3.'
  //       'Şahısların uğrayacağım tüm maddi veya manevi zararlar Kullanıcı’ya ait olacaktır. İş bu sebeple; Bi'
  //       'Asansör herhangi bir şekilde 3. gerçek ve/veya tüzel kişilere tazminat ödemesi halinde, Kullanıcı’dan'
  //       ' zararını rücu edebilecektir.\n'
  //       '6.13. Bi Asansör, Sistem’e Üyeler tarafından beyan edilen, yazılan, kullanılan fikir ve düşünceler'
  //       ' kapsamında 5651 sayılı Kanun anlamında yer sağlayıcı sıfatını haiz olup, Üyeler’in beyan ettiği,'
  //       ' yazdığı, kullandığı fikir ve düşünceleri kontrol etme yükümlülüğü bulunmamaktadır. Sistem’de Üyeler'
  //       ' tarafından beyan edilen, yazılan, kullanılan fikir ve düşünceler, tamamen Üyelerin kendi kişisel'
  //       ' görüşleridir ve görüş sahibini bağlar. Bu görüş ve düşüncelerin Bi Asasör ile hiçbir ilgi ve bağlantısı'
  //       ' yoktur. Bi Asansör’ün, Üyenin beyan edeceği fikir ve görüşler nedeniyle üçüncü kişilerin'
  //       ' uğrayabileceği zararlardan ve üçüncü kişilerin beyan edeceği fikir ve görüşler nedeniyle üyenin'
  //       ' uğrayabileceği zararlardan dolayı herhangi bir sorumluluğu bulunmamaktadır.\n'
  //       '6.14. İşbu üyelik sözleşmesi içerisinde sayılan maddelerden bir ya da birkaçını ihlal eden Üye işbu'
  //       ' ihlal nedeniyle cezai ve hukuki olarak şahsen sorumlu olup, Bi Asansör’ü bu ihlallerin hukuki ve cezai'
  //       ' sonuçlarından bağışık tutacaktır. Ayrıca; işbu ihlal nedeniyle, olayın adli ya da idari bir soruşturma,'
  //       ' kovuşturma ya da yargılamaya intikal etmesi halinde, Bi Asansör’e Üyeye karşı üyelik sözleşmesine'
  //       ' uyulmamasından dolayı tazminat talebinde bulunma hakkı saklıdır.\n'
  //       '6.15. Aracı hizmet sağlayıcı olarak Bi Asansör, platformunda, üçüncü parti araç kiralama şirketlerinin'
  //       ' kiralanmak üzere arz ettiği araçların özelliklerini her zaman tam ve eksiksiz sunmaya gayret'
  //       ' etmektedir. Ancak ürünlerin internet üzerinden gösterilmesi için fotoğraf ve ürünlerin ve kullanılan sistemin teknik özellikleri nedeni ile renkleri ve/veya boyutlarında önem arz etmeyen farklılıklar'
  //       ' olabilir. Araç kiralama aşamalarında gösterilen araç fotoğrafları temsili mahiyettinde olabilmektedir.\n'
  //       '6.16. Bi Asansör; Sistem’de üyeler tarafından üye olurken ve kiralama işlemi yapılırken 5651 sayılı'
  //       ' kanun ve diğer genel hükümler gereğince abonelik bilgilerini ve log kaydını tutmaktadır. Söz konusu'
  //       ' kayıtlar yasal nedenler hariç hiçbir kurum ve kuruluş ile paylaşılmaz.\n'
  //       '6.17. Tarafların iradesi dışında ortaya çıkan, resmi şekilde belgelenebilen ve işbu sözleşme ile'
  //       ' yüklendikleri borçlarını yerine getirmelerini engelleyici ve/veya geciktirici hallerin meydana gelmesi'
  //       ' (örneğin grev, lokavt, iç savaş, savaş, terör eylemleri, deprem, yangın, sel vb doğal afetler, devletin'
  //       ' karar ve eylemleri vb) mücbir sebep hali olarak değerlendirilecek olup, Tarafların mücbir sebep'
  //       ' dolayısıyla yükümlülüklerini tam ve zamanında yerine getirememesi halinde sözleşme kendiliğinden'
  //       ' askıya alınacak olup, mücbir sebebin 10 günden fazla uzaması halinde ise taraflar bir araya gelerek'
  //       ' sözleşmenin devamı, askıya alınması, feshi veya bir başka şekilde tasfiye şeklini müzakere'
  //       ' edecektirler.\n'
  //       '6.18. İşbu sözleşmenin herhangi bir hükmü veya hükümleri yürürlükteki kanunlara aykırı olması'
  //       ' halinde herhangi bir surette geçersiz veya ifa edilemez bir hale gelirse, sözleşmenin diğer hükümleri'
  //       ' geçerli ve yürürlükte kalacaktır. Bu durumda, Taraflar, geçersiz sayılan veya ifa edilemeyen kısım'
  //       ' veya hükmün yerine, geçersiz bölüm veya hükmün amacına uygun yeni bir hüküm veya bölüm'
  //       ' eklemek için ellerinden gelen azami çabayı sarf edeceklerdir.\n'
  //       '6.19. Taraflar arasında ve tarafların yetkililerince yapılan e-posta, anlık mesaj, Kullanıcı’nın hizmet'
  //       ' aldığı sunucu kayıtları, Bi Asansör’ün sunucu kayıtları, tüm dijital delilleri ve faks gibi elektronik'
  //       ' yazışma kayıtları, kanunen geçerli delil sayılarak, usul hukuku bağlamında delil olarak kabul edilmiştir.\n'
  //       '6.20. İş bu sözleşmenin uygulanması sırasında doğacak her türlü uyuşmazlığın çözümünde Türk'
  //       'Hukuku uygulanacak olup İstanbul Anadolu Mahkemeleri ile İcra Daireleri yetkili ve görevlidir.\n'
  //       '6.21. Bi Asansör ve biasansor.online sözcük ve şekil markası ile www.biasansor.online ve Bi Asansör'
  //       'Mobil Uygulamalar’da kullanılan her türlü slogan, tasarım, web site tasarımı, yazılım, alan adı, kod ve'
  //       ' sair tanıtıcı/ayırt edici ad ve işaretin her türlü fikri ve sınai mülkiyet hakkı Bi Asansör’e aittir. Kullanıcı,'
  //       ' bu ve benzeri nitelikteki fikri ve sınai mülkiyet hakkına konu ayırt edici/tanıtıcı ad ve işareti, Bi'
  //       'Asansör’ün önceden iznini almaksızın kullanamaz, paylaşamaz, dağıtamaz, kopyalayamaz,'
  //       ' çoğaltamaz ve sair biçimde ticari etki yaratacak şekilde kullanamaz. Kullanıcı’nın üçüncü kişilerin'
  //       ' ve/veya Bi Asansör’ün fikri ve/veya sınai mülkiyet hakkını ya da ticari itibarını ihlal edecek şekilde davranması halinde Kullanıcı, Bi Asansör’ün ve/veya üçüncü kişilerin uğradığı her türlü zararı tazmin'
  //       ' etmekle yükümlüdür.\n\n'
  //       '7. İş bu 7 maddeden oluşan Üyelik Sözleşmesi 1 (bir) nüsha olarak taraflar arasında elektronik'
  //       ' ortamda akdedilmiş olup, ÜYE sözleşmenin bir kopyasına www.biasansor.online adresinden'
  //       ' ulaşabilecektir. Yukarıda belirtilen kullanım şartları, Üyelik işlemlerinin tamamlanması ile tarafınızdan'
  //       ' onaylanmıştır.';
  // }
  //
  // String gizlilikSozlesmesi() {
  //   return 'Gizliliğin siz kullanıcılarımız için çok önemli olduğunun bilincindeyiz, bu nedenle sistem'
  //       ' kullanıcılarımızın gizliliği bizim için de çok önemlidir. Gizlilik Politikası, Bi Asansör web sitesini veya'
  //       ' mobil uygulamasını kullanırken paylaştığınız verilerin ne amaçlarla kullanılabileceği, bu bilgilerin'
  //       ' kimlerle paylaşılabileceği ve gizliliğinizi korumak amacıyla uyguladığımız güvenlik işlemleri hakkında'
  //       ' gerekli bilgileri sağlamayı amaçlamaktadır.\n'
  //       'Bi Asansör internet sitesini ve mobil uygulamalarını kullanarak Gizlilik Politikasında belirtilen'
  //       ' hususları kabul etmiş ve burada belirtilen hususlarda Bi Asansör’e izin vermiş oluyorsunuz.\n'
  //       'Bi Asansör Gizlilik Politikası ile ilgili her türlü uyuşmazlık Türkiye Cumhuriyeti yasalarına tabidir ve'
  //       ' uyuşmazlıkların çözümünde İstanbul mahkemeleri ve icra daireleri yetkilidir.\n'
  //       'Bi Asansör Hangi Verilerinizi Toplayabilir?\n'
  //       'Adınızı, soyadınızı, adresinizi,doğum tarihinizi,ikamet ettiğiniz şehrinizi,telefon numaralarınızı,e-posta'
  //       ' adresinizi ve diğer tüm iletişim bilgilerinizi toplayabilir.\n'
  //       'Bi Asansör Verilerinizi Hangi Amaçlarla Kullanabilir?\n'
  //       'Araç kiralama hizmetlerinizi gerçekleştirmek ve sitemize üyelik hesabınızı yönetmek,\n'
  //       'Ürünlerimizi ve hizmetlerimizi sizlere tanıtmak, ilgilenebileceğiniz ve size fayda sağlayabileceğini'
  //       ' düşündüğümüz promosyonlar ve kampanyalar oluşturup iletişim sağlayabilmek,\n'
  //       'Bi Asansör çalışanları, Bi Asansör’e hizmet veren kuruluşlar veya bunların çalışanlarının veya Bi'
  //       ' Asansör’ün müşterilerinin can ve mal güvenliğinin korunması veya bu maddede belirtilenlere ilişkin'
  //       ' kurallara uyum sağlanması dahil olmak üzere yasal yükümlülüklerin veya yetkili idari kuruluşların'
  //       ' taleplerinin yerine getirilmesi, amacıyla kullanabilir.\n'
  //       'Kişisel Verilerinizin Güvenliği\n'
  //       'Bilgi Edinme Hakkınız\n'
  //       'KVK Kanunu’nun 11. maddesi kapsamında, Bi Asansör’e başvurarak kişisel verilerinizin;\n Kişisel verilerinizin işlenip işlenmediğini öğrenme,\n'
  //       'Kişisel verileriniz işlenmişse buna ilişkin bilgi talep etme,\n'
  //       'Kişisel verilerinizin işlenme amacını ve bunların amacına uygun kullanılıp kullanılmadığını öğrenme,\n'
  //       'Yurt içinde veya yurt dışında kişisel verilerinizin aktarıldığı üçüncü kişileri bilme,\n'
  //       'Kişisel verilerinizin eksik veya yanlış işlenmiş olması hâlinde bunların düzeltilmesini isteme,\n'
  //       'Kanun’un 7. maddesinde öngörülen şartlar çerçevesinde kişisel verilerin silinmesini veya yok'
  //       ' edilmesini isteme,\n'
  //       'Kanun’un 11. maddesinin (d) ve (e) bentleri uyarınca yapılan işlemlerin, kişisel verilerinizin aktarıldığı'
  //       ' üçüncü kişilere bildirilmesini isteme,\n'
  //       'İşlenen verilerinizin münhasıran otomatik sistemler vasıtasıyla analiz edilmesi suretiyle kendiniz'
  //       ' aleyhine bir sonucun ortaya çıkmasına itiraz etme,\n'
  //       'Kişisel verilerinizin kanuna aykırı olarak işlenmesi sebebiyle zarara uğramanız hâlinde zararın'
  //       ' giderilmesini talep etme,\n'
  //       'İşbu Bilgilendirme Metni, değişen süreçlerimiz dolayısıyla KVK mevzuata uyum sağlamak amacıyla'
  //       ' güncellenebilecektir. Otomatik e-posta gönderim listemizde yer alıyorsanız, güncellemelerimiz size e-posta yolu ile bildirilecektir. Otomatik e-posta gönderim listemizde yer almıyor iseniz güncellemeler'
  //       'için sitemizi sık sık ziyaret etmenizi rica ederiz. ';
  // }
  //
  // String kisiselVerilerinKorunmasiSozlesmesi() {
  //   return 'HAKKINDA AYDINLATMA METNİ\n'
  //       'Bi Asansör- Kiralık Asansör Uygulaması olarak; adınız, soyadınız, e-posta adresiniz ve şifreniz tipindeki'
  //       ' kişisel verileriniz;\n'
  //       'Talep / Şikayetlerin Takibi,\n'
  //       'İletişim Faaliyetlerinin Yürütülmesi,\n'
  //       'Firma / Ürün / Hizmetlere Bağlılık Süreçlerinin Yürütülmesi\n'
  //       'Mal / Hizmet Satış Sonrası Destek Hizmetlerinin Yürütülmesi,\n'
  //       'Mal / Hizmet Üretim ve Operasyon Süreçlerinin Yürütülmesi,\n'
  //       'Mal / Hizmet Satış Süreçlerinin Yürütülmesi,\n'
  //       'Ürün / Hizmetlerin Pazarlama Süreçlerinin Yürütülmesi,\n'
  //       'Amaçları doğrultusunda sınırlı olarak işlenmektedir.\n'
  //       'Kişisel verileriniz, yukarıda bahsedilen amaçlar doğrultusunda 6698 sayılı Kişisel Verileri Koruma'
  //       ' Kanunu’nun (“Kanun”) madde 5/2/a maddesinde düzenlenen kanunlarda açıkça öngörülmesi ve'
  //       ' Kanun’un 5/2-c bendi uyarınca, bir sözleşmenin kurulması veya ifası için sözleşme taraflarına ait'
  //       ' kişisel verilerin işlenmesinin zorunlu olması hukuki sebeplerine dayalı olarak otomatik yollarla'
  //       ' işlenmektedir. Yukarıda sayılan kişisel verileriniz, yukarıda sayılan amaçlar kapsamında Şirket'
  //       ' bünyesindeki operasyon çalışanları ve yöneticileri tarafından işlenecek ve Şirket faaliyetlerinin'
  //       ' sürdürülebilmesi amacıyla güvenlik tedbirleri dahilinde aktarılacaktır. Dilediğiniz zaman kişisel'
  //       ' verilerinizle ilgili olarak;\n'
  //       'Kişisel verilerinizin işlenme amacını ve bunların amacına uygun kullanılıp kullanılmadığını öğrenme,\n'
  //       'Kişisel verilerinizin işlenip işlenmediğini öğrenme,\n'
  //       'Kişisel verileriniz işlenmişse buna ilişkin bilgi talep etme,\n'
  //       'Kişisel verilerinizin eksik veya yanlış işlenmiş olması hâlinde bunların düzeltilmesini isteme,\n'
  //       'Yurt içinde veya yurt dışında kişisel verilerinizin aktarıldığı üçüncü kişileri bilme,\n'
  //       'Kanun’un 7. maddesinde öngörülen şartlar çerçevesinde kişisel verilerin silinmesini veya yok'
  //       ' edilmesini isteme,\n'
  //       'Kanun’un 11. maddesinin (d) ve (e) bentleri uyarınca yapılan işlemlerin, kişisel verilerinizin aktarıldığı'
  //       'üçüncü kişilere bildirilmesini isteme,\n'
  //       'Kişisel verilerinizin kanuna aykırı olarak işlenmesi sebebiyle zarara uğramanız hâlinde zararın'
  //       ' giderilmesini talep etme,\n'
  //       'İşlenen verilerinizin münhasıran otomatik sistemler vasıtasıyla analiz edilmesi suretiyle kendiniz'
  //       ' aleyhine bir sonucun ortaya çıkmasına itiraz etme,\n'
  //       'taleplerinde bulunabilirsiniz.\n'
  //       'Haklarınızı kullanmayı talep edebilirsiniz. Haklarınıza ve Kanunun uygulanmasına ilişkin taleplerinizi,'
  //       ' info@biasansor.online adresine iletebilirsiniz. Bi Asansör, bu kapsamdaki taleplere yazılı olarak cevap'
  //       ' verilecekse, on sayfaya kadar ücret almadan; on sayfanın üzerindeki her sayfa için KVK Kurulu'
  //       ' tarafından belirlenen tarifedeki ücreti alarak yanıtlandıracaktır. Başvuruya cevabın CD, flash bellek'
  //       ' gibi bir kayıt ortamında verilmesi halinde Şirket tarafından talep edilebilecek ücret kayıt ortamının'
  //       ' maliyetini geçemeyecektir.\n'
  //       'Tarafıma iletilen “Aydınlatma Metni”ni okuduğumu ve anladığımı, 6698 sayılı Kişisel Verilerin'
  //       ' Korunması Kanunu’nun (“Kanun”) 11. Maddesinde sayılan haklarım ile bu haklarımı nasıl'
  //       ' kullanacağıma ilişkin açık ve anlaşılır şekilde bilgilendirildiğimi, kişisel verilerimin Metninde belirtilen'
  //       ' amaçlar, yöntemler ve hukuki sebepler dâhilinde işleneceği konusunda bilgilendirildiğimi kabul ve'
  //       ' beyan ederim.';
  // }
}
