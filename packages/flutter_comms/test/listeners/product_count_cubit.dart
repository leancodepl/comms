import 'package:flutter_comms/flutter_comms.dart';

class ProductCountListenerCubit
    extends ListenerCubit<int, ProductCountChangedMessage> {
  ProductCountListenerCubit() : super(0);

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
    emit(state + 1);
  }

  void _decrement() {
    emit(state - 1);
  }
}

abstract class ProductCountChangedMessage {}

class ProductCountIncremented extends ProductCountChangedMessage {}

class ProductCountDecremented extends ProductCountChangedMessage {}
