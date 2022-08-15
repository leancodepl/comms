import 'package:comms/comms.dart';

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

abstract class ProductCountChangedMessage {}

class ProductCountIncremented extends ProductCountChangedMessage {}

class ProductCountDecremented extends ProductCountChangedMessage {}
