import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:webcrypto/webcrypto.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _generateKeys() async {
    // final digest = await Hash.sha256.digestBytes(utf8.encode('Hello World'));
    // print(base.encode(digest));
    // 1. Generate keys
    KeyPair<EcdhPrivateKey, EcdhPublicKey> keyPair =
        await EcdhPrivateKey.generateKey(EllipticCurve.p256);
    Map<String, dynamic> publicKeyJwk =
        await keyPair.publicKey.exportJsonWebKey();
    Map<String, dynamic> privateKeyJwk =
        await keyPair.privateKey.exportJsonWebKey();

    // 2. Derive bits
    Uint8List derivedBits =
        await keyPair.privateKey.deriveBits(256, keyPair.publicKey);

    // 3. Encrypt
    AesGcmSecretKey aesGcmSecretKey =
        await AesGcmSecretKey.importRawKey(derivedBits);
    List<int> list = 'hello'.codeUnits;
    Uint8List data = Uint8List.fromList(list);
    Uint8List iv = Uint8List.fromList('Initialization Vector'.codeUnits);
    Uint8List encryptedBytes = await aesGcmSecretKey.encryptBytes(data, iv);
    String encryptedString = String.fromCharCodes(encryptedBytes);

    // 4. Decrypt
    Uint8List decryptdBytes =
        await aesGcmSecretKey.decryptBytes(encryptedBytes, iv);
    String decryptdString = String.fromCharCodes(decryptdBytes);

    print(
        'keypair $keyPair, $publicKeyJwk, $privateKeyJwk, $encryptedString, $decryptdString');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SHA-1 Hashing'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    _generateKeys();
                  },
                  child: Text('generate both keys'))
            ],
          ),
        ),
      ),
    );
  }
}
