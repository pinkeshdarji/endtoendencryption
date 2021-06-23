import 'dart:convert';
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
    // KeyPair<EcdhPrivateKey, EcdhPublicKey> keyPair =
    //     await EcdhPrivateKey.generateKey(EllipticCurve.p256);
    // Map<String, dynamic> publicKeyJwk =
    //     await keyPair.publicKey.exportJsonWebKey();
    // Map<String, dynamic> privateKeyJwk =
    //     await keyPair.privateKey.exportJsonWebKey();

    // 2. Derive bits
    Map<String, dynamic> publicjwk = json.decode(
        '{"kty": "EC", "crv": "P-256", "x": "31MyHDPKNllGkr56jvpH_8wpBkKMtqgcQqBM7ZjPHc4", "y": "DMrG4SnjNFEsHOPjtA7JCfkji51c81jno2AgQ37AYDQ"}');
    EcdhPublicKey ecdhPublicKey =
        await EcdhPublicKey.importJsonWebKey(publicjwk, EllipticCurve.p256);
    Map<String, dynamic> privatejwk = json.decode(
        '{"kty": "EC", "crv": "P-256", "x": "WnVvrbooqRiw88JyFAGpuX0uc1wTsAUXTSx6GH4lMwU", "y": "u42IFm9ZGKQrsdXZEZAR2RJJvlPNLwMfHQveIP6NX8U", "d": "GUwEOAb4z7R4XugKf-I-sBSLsbCa4ViLlZym9Zg8pgM"}');
    EcdhPrivateKey ecdhPrivateKey =
        await EcdhPrivateKey.importJsonWebKey(privatejwk, EllipticCurve.p256);
    Uint8List derivedBits = await ecdhPrivateKey.deriveBits(256, ecdhPublicKey);

    // 3. Encrypt
    AesGcmSecretKey aesGcmSecretKey =
        await AesGcmSecretKey.importRawKey(derivedBits);
    // List<int> list = 'hello'.codeUnits;
    // Uint8List data = Uint8List.fromList(list);
    // Uint8List iv = Uint8List.fromList('Initialization Vector'.codeUnits);
    // Uint8List encryptedBytes = await aesGcmSecretKey.encryptBytes(data, iv);
    // String encryptedString = String.fromCharCodes(encryptedBytes);

    // 4. Decrypt
    Uint8List decryptdBytes = await aesGcmSecretKey.decryptBytes(
        Uint8List.fromList('P^-Uº-¬"ë¦ìÂ='.codeUnits),
        Uint8List.fromList('Initialization Vector'.codeUnits));
    String decryptdString = String.fromCharCodes(decryptdBytes);

    // print(
    //     'keypair $keyPair, $publicKeyJwk, $privateKeyJwk, $encryptedString, $decryptdString');

    //print('encrypted strring is $encryptedString');
    print('decrypted strring is $decryptdString');
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
