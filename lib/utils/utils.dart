/// print
String prettyPrintList(Iterable iter) {
  if (iter == null) return 'NULL';

  final buff = StringBuffer();
  var isFirst = true;

  buff.write('[');

  for (final val in iter) {
    if (!isFirst) buff.write(', ');
    isFirst = false;
    if (val is String) {
      buff.write('"$val"');
    } else {
      buff.write(val.toString());
    }
  }

  buff.write(']');

  return buff.toString();
}

int safeInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  var valueString = value is String ? value : value.toString();
  var number = num.tryParse(valueString);
  return number.toInt();
}

double safeDouble(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value == double) {
    return value;
  }
  var valueString = value is String ? value : value.toString();
  var number = num.tryParse(valueString);
  return number.toDouble();
}

String safeString(dynamic value) {
  if (value == null) {
    return '';
  }
  var valueString = value is String ? value : value.toString();
  return valueString;
}

bool safeBool(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is bool) {
    return value;
  }
  if (value is num) {
    var valueNumber = value;
    if (valueNumber > 0) {
      return true;
    }
    return false;
  }
  return false;
}

List<int> safeListInt(dynamic value) {
  if (value is List) {
    if (value.isEmpty) {
      return List<int>();
    }
    var item = value.first;
    if (item is int) {
      return value;
    }
    if (item is String) {
      var list = value.map((e) => safeInt(e));
      return list.toList();
    }
  }
  return List<int>();
}

List<String> safeListString(dynamic value) {
  if (value is List) {
    if (value.isEmpty) {
      return List<String>();
    }
    var list = value.map((e) => safeString(e));
    return list.toList();
  }
  return List<String>();
}

List<Map<String, dynamic>> safeListMap(dynamic value) {
  if (value is List) {
    if (value.isEmpty) {
      return List<Map<String, dynamic>>();
    }
    var item = value.first;
    if (item is Map<String, dynamic>) {
      var data = value.map((e) => e as Map<String, dynamic>);
      return data.toList();
    }
  }
  return List<Map<String, dynamic>>();
}
