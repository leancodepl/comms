import 'package:bloc/bloc.dart';
import 'package:comms/comms.dart';
import '../messages/product_count_changed.dart';

class BasketCubitSender extends Cubit<List<String>>
    with Sender<ProductCountChangedMessage> {
  BasketCubitSender() : super([]);

  void add(String product) {
    emit([...state, product]);
    send(ProductCountIncremented());
  }

  void removeLast() {
    emit([...state]..removeLast());
    send(ProductCountDecremented());
  }
}
