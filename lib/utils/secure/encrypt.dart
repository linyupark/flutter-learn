import 'dart:convert';
import 'dart:math';
import 'package:crypton/crypton.dart';
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';
import 'package:asn1lib/asn1lib.dart';

import 'binary.dart';

class EncyptData {
  String secure;
  String encrypted;

  EncyptData(this.secure, this.encrypted);
}

class Encrypt {
  // 128
  static List<int> generateAesHexKey() {
    var secure = Random.secure();
    var bytes = List<int>();
    for (var i = 0; i < 16; i++) {
      bytes.add(secure.nextInt(256));
    }
    return bytes;
  }

  static RSAKeypair generateRsaKey() {
    var keypair = RSAKeypair.fromRandom(keySize: 1024);
    return keypair;
  }

  static String rsaDecryptData(String data, String randomKey) {
    var privateKey = RSAPrivateKey.fromString(randomKey);
    String encrypted = privateKey.decrypt(data);
    return encrypted;
  }

  static String rsaEncryptData(String data, RSAPublicKey publicKey) {
    String encrypted = publicKey.encrypt(data);
    return encrypted;
  }

  // key need HEX
  static Future<String> aesEncryptData(String data, String hexKey) async {
    final encrypted = await FlutterAesEcbPkcs5.encryptString(data, hexKey);
    return encrypted;
  }

  // data abd key both need HEX
  static Future<String> aesDecryptData(String hexData, String hexKey) async {
    final decrypted = await FlutterAesEcbPkcs5.decryptString(hexData, hexKey);
    return decrypted;
  }

  static RSAPublicKey rsaPublicKeyFormat(String data) {
    List<int> publicKeyData = base64Decode(data);
    var publicKeyAsn = ASN1Parser(publicKeyData);
    ASN1Sequence publicKeySeq = publicKeyAsn.nextObject();
    var modulus = publicKeySeq.elements[0] as ASN1Integer;
    var exponent = publicKeySeq.elements[1] as ASN1Integer;
    var publicKey =
        RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);
    return publicKey;
  }

  static Future<EncyptData> encrypted(
      String data, String key, String hexKey, RSAPublicKey publicKey) async {
    var secure = Encrypt.rsaEncryptData(key, publicKey);
    var hexData = await Encrypt.aesEncryptData(data, hexKey);
    var encrypted = Binary.hexFormatBase64(hexData);
    var model = EncyptData(secure, encrypted);
    return model;
  }

  static String rsaEncryptedBigData(String data, RSAPublicKey publicKey) {
    var bytes = utf8.encode(data);
    var blocSize = 128;
    var maxChunkSize = blocSize - 42;
    var encryptedDataBytes = '';
    var idx = 0;
    while (idx < bytes.length) {
      var idxEnd = min(idx + maxChunkSize, bytes.length);
      var chunkData = bytes.getRange(idx, idxEnd).toList();
      var chunkDataBase64 = base64Encode(chunkData);
      var rsaEncryptData = Encrypt.rsaEncryptData(chunkDataBase64, publicKey);
      encryptedDataBytes += rsaEncryptData;
      idx += maxChunkSize;
    }
    return encryptedDataBytes;
  }

  static Future<EncyptData> doubleEncrypted(
      String data,
      String key,
      String hexKey,
      RSAPublicKey publicKey,
      String _publicKeyStr,
      String _privteKeyStr) async {
    var rsaEncryptData =
        rsaEncryptedBigData(data, Encrypt.rsaPublicKeyFormat(_publicKeyStr));
    var privateKeyStr = _privteKeyStr;
    var privateKeyBytes = utf8.encode(privateKeyStr);
    var privateStr = Binary.dataFromBinary(privateKeyBytes);
    var rsaEncryptDataBytes = utf8.encode(rsaEncryptData);
    var encryptStr = Binary.dataFromBinary(rsaEncryptDataBytes);
    var maxSplit = min(1 << 16, rsaEncryptData.length);
    var encryptSplitValue = Random().nextInt(maxSplit ~/ 2) + 1;
    var splitValue = Random().nextInt(privateStr.length ~/ 2) + 1;
    var offset = Random().nextInt(8) + 1;
    var offsetBinary = Binary.binary8(offset);
    var firstKey = privateStr.substring(0, splitValue);
    var secondKey = privateStr.substring(splitValue, privateStr.length);
    var firstData = encryptStr.substring(0, encryptSplitValue);
    var secondData =
        encryptStr.substring(encryptSplitValue, rsaEncryptData.length);
    var mixStr = firstData + firstKey + secondData + secondKey;
    var firstBinary = Binary.binary16(firstData.length + offset) +
        Binary.binary16(firstKey.length + offset);
    var secondBinary = Binary.binary16(secondKey.length + offset);
    var mixStrPrevious = mixStr.substring(0, 60);
    var mixStrEnd = mixStr.substring(60, mixStr.length);
    var mixEnd =
        firstBinary + mixStrPrevious + secondBinary + mixStrEnd + offsetBinary;
    var mixEndData = Binary.binaryFromData(mixEnd);
    var mixEndDataBase64 = base64Encode(mixEndData);
    var model = encrypted(mixEndDataBase64, key, hexKey, publicKey);
    return model;
  }

  static String rsaDecryptedBigData(String data, String privateKey) {
    var bytes = utf8.encode(data);
    var blocSize = 128;
    var maxChunkSize = blocSize - 42;
    var encryptedDataBytes = '';
    var idx = 0;
    while (idx < bytes.length) {
      var idxEnd = min(idx + maxChunkSize, bytes.length);
      var chunkData = bytes.getRange(idx, idxEnd).toList();
      var chunkDataBase64 = base64Encode(chunkData);
      var rsaEncryptData = Encrypt.rsaDecryptData(chunkDataBase64, privateKey);
      encryptedDataBytes += rsaEncryptData;
      idx += maxChunkSize;
    }
    return encryptedDataBytes;
  }

  static Future<String> doubleDecryptData(String data) async {
    var bytes = utf8.encode(data);
    var encryptStr = Binary.dataFromBinary(bytes);
    var offsetStr = encryptStr.substring(encryptStr.length - 8);
    var offsetValue = Binary.binary2dec(offsetStr);
    var firstBinary = encryptStr.substring(0, 32);
    var secondBinary = encryptStr.substring(92, 92 + 16);
    var pureFirst = encryptStr.substring(32, 32 + 60);
    var pureSecond = encryptStr.substring(108, encryptStr.length - 108 - 8);
    var pureData = pureFirst + pureSecond;
    var firstBeginData = firstBinary.substring(0, 16);
    var firstEndData = firstBinary.substring(16, firstBinary.length);
    var firstBeiginValue = Binary.binary2dec(firstBeginData) - offsetValue;
    var firstLength = Binary.binary2dec(firstEndData) - offsetValue;
    var secondLength = Binary.binary2dec(secondBinary) - offsetValue;
    var firstKey =
        pureData.substring(firstBeiginValue, firstBeiginValue + firstLength);
    var secondKey =
        pureData.substring(pureData.length - secondLength, pureData.length);
    var privateKey = firstKey + secondKey;
    var firstPure = pureData.substring(0, firstBeiginValue);

    var secondPure = pureData.substring(
        firstBeiginValue + firstLength, pureData.length - secondLength);
    var encryptData = firstPure + secondPure;
    var privateKeyEndData = Binary.binaryFromData(privateKey);
    var encryptEndData = Binary.binaryFromData(encryptData);
    var decryptData = rsaDecryptedBigData(
        base64Encode(encryptEndData), base64Encode(privateKeyEndData));
    return decryptData;
  }
}
