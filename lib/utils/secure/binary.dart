import 'dart:convert';
import 'dart:typed_data';

class Binary {
  static String mixBinary(String salt, String data) {
    var bytes = utf8.encode(data);
    var saltBytes = utf8.encode(salt);
    var saltBinary = dataFromBinary(saltBytes);
    var binary = dataFromBinary(bytes);
    var index = binary.length ~/ 3;
    var pre = binary.substring(0, index);
    var end = binary.substring(index, binary.length);
    var mix = pre + saltBinary + end;
    return mix;
  }

  static List<int> demixBinary(String salt, String data) {
    var saltBytes = utf8.encode(salt);
    var saltBinary = dataFromBinary(saltBytes);
    var index = (data.length - saltBinary.length) ~/ 3;
    var pre = data.substring(0, index);
    var end = data.substring(index + saltBinary.length, data.length);
    var pure = pre + end;
    return binaryFromData(pure);
  }

  static String binary8(int value) {
    var data = value.toRadixString(2);
    while (data.length < 8) {
      data = "0" + data;
    }
    return data;
  }

  static String binary16(int value) {
    var data = value.toRadixString(2);
    while (data.length < 16) {
      data = "0" + data;
    }
    return data;
  }

  static String dataFromBinary(List<int> data) {
    var binary = '';
    for (var value in data) {
      var d = binary8(value);
      binary = binary + d;
    }
    return binary;
  }

  static List<int> binaryFromData(String data) {
    List<int> list = [];
    var temp = '';
    var dataList = data.split('');
    for (var i = 0; i < dataList.length; i++) {
      temp = temp + dataList[i];
      if ((i + 1) % 8 == 0) {
        var value = int.parse(temp, radix: 2);
        list.add(value);
        temp = '';
      }
    }
    return list;
  }

  // hex change to uint8 list
  static List<int> hexFormatData(String str) {
    int length = str.length;
    if (length % 2 != 0) {
      str = "0" + str;
      length++;
    }
    List<int> s = str.toUpperCase().codeUnits;
    List<int> bArr = List<int>(length >> 1);
    for (int i = 0; i < length; i += 2) {
      bArr[i >> 1] = ((hex(s[i]) << 4) | hex(s[i + 1]));
    }
    return bArr;
  }

  static hex(int c) {
    if (c >= '0'.codeUnitAt(0) && c <= '9'.codeUnitAt(0)) {
      return c - '0'.codeUnitAt(0);
    }
    if (c >= 'A'.codeUnitAt(0) && c <= 'F'.codeUnitAt(0)) {
      return (c - 'A'.codeUnitAt(0)) + 10;
    }
  }

  static int binary2dec(String data) {
    var sum = 0;
    var dataList = data.split('');
    for (var c in dataList) {
      sum = sum * 2 + int.parse(c);
    }
    return sum;
  }

  static base64formatHex(String data) {
    var bytes = base64Decode(data);
    var hex = dataFormatHex(bytes);
    return hex;
  }

  static String dataFormatHex(List<int> bArr) {
    int length;
    if (bArr == null || (length = bArr.length) <= 0) {
      return "";
    }
    List<int> cArr = new List<int>(length << 1);
    int i = 0;
    for (int i2 = 0; i2 < length; i2++) {
      int i3 = i + 1;
      var cArr2 = [
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        'A',
        'B',
        'C',
        'D',
        'E',
        'F'
      ];

      var index = (bArr[i2] >> 4) & 15;
      cArr[i] = cArr2[index].codeUnitAt(0);
      i = i3 + 1;
      cArr[i3] = cArr2[bArr[i2] & 15].codeUnitAt(0);
    }
    return new String.fromCharCodes(cArr);
  }

  static String hexFormatBase64(String hexKey) {
    var dataList = Binary.hexFormatData(hexKey);
    var data = base64Encode(dataList);
    return data;
  }

  /// Converts binary data to a hexdecimal representation.
  static String _formatBytesAsHexString(Uint8List bytes) {
    var result = StringBuffer();
    for (var i = 0; i < bytes.lengthInBytes; i++) {
      var part = bytes[i];
      result.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return result.toString();
  }

  /// Converts a hexdecimal representation to binary data.
  static Uint8List _createUint8ListFromHexString(String hex) {
    var result = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < hex.length; i += 2) {
      var num = hex.substring(i, i + 2);
      var byte = int.parse(num, radix: 16);
      result[i ~/ 2] = byte;
    }
    return result;
  }
}
