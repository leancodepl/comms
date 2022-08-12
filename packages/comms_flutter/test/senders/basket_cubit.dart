import 'package:bloc/bloc.dart';
import 'package:comms/comms.dart';
import '../listeners/product_count_cubit.dart';

class BasketCubit extends Cubit<List<String>>
    with Sender<ProductCountChangedMessage> {
  BasketCubit() : super([]);

  void add(String product) {
    emit([...state, product]);
    send(ProductCountIncremented());
  }

  void removeLast() {
    emit([...state]..removeLast());
    send(ProductCountDecremented());
  }
}
