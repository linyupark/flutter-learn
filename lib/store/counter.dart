import 'package:mobx/mobx.dart';

part 'counter.g.dart';

class Counter = _Counter with _$Counter;

abstract class _Counter with Store {
  @observable
  int value = 0;

  @computed
  String get username => '${user['lastName']} ${user['firstName']}';

  @observable
  ObservableMap<String, String> user = ObservableMap.of({
    'firstName': 'Yu',
    'lastName': 'Lin',
  });

  @action
  void increment() {
    value++;
  }
}

final counter0 = Counter();
