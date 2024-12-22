import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  static String encryptPassword(String password, String username) {
    final key = encrypt.Key.fromUtf8(username.padRight(16, ' '));
    final encrypter = encrypt.Encrypter(encrypt.AES(key)); // buat object enkripsi

    final iv = encrypt.IV.fromLength(16); // buat Initial vector sepanjang 16 byte
    final encrypted = encrypter.encrypt(password, iv: iv); // enkripsi password pake kunci dan iv

    return '${encrypted.base64}:${iv.base64}'; // return base64 format dengan pemisah :
  }

  static String decryptPassword(String encryptedPasswordWithIV, String username) {
    final parts = encryptedPasswordWithIV.split(':');
    final encryptedPassword = parts[0];
    final iv = encrypt.IV.fromBase64(parts[1]);

    final key = encrypt.Key.fromUtf8(username.padRight(16, ' ')); 
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter.decrypt64(encryptedPassword, iv: iv);

    return decrypted;
  }
}
