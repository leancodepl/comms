import 'package:comms/comms.dart';

import '../messages/product_count_changed.dart';

class ProductCount with Listener<ProductCountChangedMessage> {
  ProductCount() {
    listen();
  }

  int value = 0;

  @override
  void onMessage(ProductCountChangedMessage message) {
    if (message is ProductCountIncremented) {
      _increment();
    }
    if (message is ProductCountDecremented) {
      _decrement();
    }
  }

  @override
  void onInitialMessage(ProductCountChangedMessage message) =>
      onMessage(message);

  void _increment() {
    value += 1;
  }

  void _decrement() {
    value -= 1;
  }

  void dispose() {
    cancel();
  }
}

class ProductCountIncrementedListener with Listener<ProductCountIncremented> {
  ProductCountIncrementedListener() {
    listen();
  }

  int value = 0;

  @override
  void onMessage(ProductCountIncremented message) {
    value += 1;
  }

  @override
  void onInitialMessage(ProductCountIncremented message) {
    onMessage(message);
  }

  void dispose() {
    cancel();
  }
}
