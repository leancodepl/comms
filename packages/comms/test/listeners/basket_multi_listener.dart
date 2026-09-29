import 'package:comms/comms.dart';

import '../messages/basket_cleared.dart';
import '../messages/product_count_changed.dart';

abstract class BasketMultiListener with MultiListener {
  final messages = <dynamic>[];

  @override
  void onMessage(dynamic message) => messages.add(message);

  @override
  void onInitialMessage(dynamic message) => onMessage(message);

  void start() => listen();

  void stop() => cancel();
}

/// Declares [listenerDelegates] as a getter, which creates new delegates on
/// every read.
class GetterBasketMultiListener extends BasketMultiListener {
  @override
  List<ListenerDelegate<dynamic>> get listenerDelegates => [
        ListenerDelegate<ProductCountChangedMessage>(),
        ListenerDelegate<BasketClearedMessage>(),
      ];
}

/// Declares [listenerDelegates] as a field, which returns the same delegates
/// on every read.
class FieldBasketMultiListener extends BasketMultiListener {
  @override
  final List<ListenerDelegate<dynamic>> listenerDelegates = [
    ListenerDelegate<ProductCountChangedMessage>(),
    ListenerDelegate<BasketClearedMessage>(),
  ];
}
