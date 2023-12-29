import 'package:comms/comms.dart';
import '../messages/product_count_changed.dart';

class BasketSender with Sender<ProductCountChangedMessage> {
  List<String> products = [];

  void add(String product) {
    products.add(product);
    send(ProductCountIncremented());
  }

  void removeLast() {
    products.removeLast();
    send(ProductCountDecremented());
  }
}

class IncrementingBasket with Sender<ProductCountChangedMessage> {
  List<String> products = [];

  void add(String product) {
    products.add(product);
    send(ProductCountIncremented());
  }
}
