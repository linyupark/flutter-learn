import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ValueNotifier<T> useLogState<T>(T initialData) {
  final result = useState<T>(initialData);
  useValueChanged(result.value, (_, __) {
    print('result.value: ${result.value}');
  });
  return result;
}
