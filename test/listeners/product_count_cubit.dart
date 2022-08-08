import 'package:bloc/bloc.dart';
import 'package:comms/comms.dart';

class ProductCountCubitWithListener extends Cubit<int>
    with Listener<ProductCountChangedMessage> {
  ProductCountCubitWithListener() : super(0) {
    listen();
  }

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
    emit(state + 1);
  }

  void _decrement() {
    emit(state - 1);
  }

  @override
  Future<void> close() {
    cancel();
    return super.close();
  }
}

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
