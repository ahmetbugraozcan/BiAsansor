class Errors {
  static String showError(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Böyle bir kullanıcı bulunamadı';
      case 'account-exists-with-different-credential':
        return 'Bu E-posta adresine bağlı bir hesap mevcut. (Google ile giriş yapmayı deneyin)';
      case 'account-exısts-wıth-dıfferent-credentıal':
        return 'Bu E-posta adresine bağlı bir hesap mevcut. (Google ile giriş yapmayı deneyin)';
      case 'email_already_in_use':
        return 'Bu e-posta zaten kullanımda. Lütfen başka bir e-posta ile kayıt olmayı veya giriş yapmayı deneyin.';
      case 'invalid-email':
        return 'Lütfen geçerli bir e-posta adresi giriniz.';
      case 'weak-password':
        return 'Zayıf Parola';
      case 'wrong-password':
        return 'Hatalı Parola Girdiniz. Lütfen Tekrar Deneyin.';
      default:
        return 'Bir hata oluştu...';
    }
  }
}
