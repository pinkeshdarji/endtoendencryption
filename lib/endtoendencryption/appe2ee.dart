import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:webcrypto/webcrypto.dart';

class AppE2EE {
  static final AppE2EE _singleton = AppE2EE._internal();

  factory AppE2EE() {
    return _singleton;
  }

  AppE2EE._internal();

  KeyPair<EcdhPrivateKey, EcdhPublicKey> keyPair;
  Uint8List derivedBits;
  AesGcmSecretKey aesGcmSecretKey;
  final Uint8List iv = Uint8List.fromList('Initialization Vector'.codeUnits);

  Future<void> generateKeys() async {
    final prefs = await SharedPreferences.getInstance();
    String derivedBitsString = (prefs.getString('derivedBits') ?? '');
    if (derivedBitsString.isNotEmpty) {
      derivedBits = Uint8List.fromList(derivedBitsString.codeUnits);
      print('derivedBits present');
      return;
    }

    // 1. Generate keys
    keyPair = await EcdhPrivateKey.generateKey(EllipticCurve.p256);
    Map<String, dynamic> publicKeyJwk =
        await keyPair.publicKey.exportJsonWebKey();
    Map<String, dynamic> privateKeyJwk =
        await keyPair.privateKey.exportJsonWebKey();

    print('keypair $keyPair, $publicKeyJwk, $privateKeyJwk');

    deriveBits();
  }

  Future<void> deriveBits() async {
    // 2. Derive bits
    derivedBits = await keyPair.privateKey.deriveBits(256, keyPair.publicKey);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('derivedBits', String.fromCharCodes(derivedBits));
    print('derivedBits $derivedBits');
  }

  Future<String> encrypt(String message) async {
    // 3. Encrypt
    aesGcmSecretKey = await AesGcmSecretKey.importRawKey(derivedBits);
    List<int> list = message.codeUnits;
    Uint8List data = Uint8List.fromList(list);
    Uint8List encryptedBytes = await aesGcmSecretKey.encryptBytes(data, iv);
    String encryptedString = String.fromCharCodes(encryptedBytes);

    print('encryptedString $encryptedString');
    return encryptedString;
  }

  Future<String> decrypt(String encryptedMessage) async {
    // 4. Decrypt
    aesGcmSecretKey = await AesGcmSecretKey.importRawKey(derivedBits);
    List<int> message = Uint8List.fromList(encryptedMessage.codeUnits);
    Uint8List decryptdBytes = await aesGcmSecretKey.decryptBytes(message, iv);
    String decryptdString = String.fromCharCodes(decryptdBytes);

    print('decryptdString $decryptdString');
    return decryptdString;
  }
}
