import 'package:comms/comms.dart';
import 'package:test/test.dart';

import 'listeners/product_count.dart';
import 'senders/basket.dart';

int numberOfProductCountMessageSink() =>
    MessageSinkRegister().getSinksOfType<ProductCountChangedMessage>().length;

void main() {
  test(
    'ProductCount message sink is added to register after it calls listen in constructor',
    () {
      final productCount = ProductCount();
      expect(numberOfProductCountMessageSink(), 1);
      productCount.dispose();
    },
  );

  test(
    'ProductCount message sink is removed from register after it calls cancel in dispose',
    () {
      final productCount = ProductCount();
      expect(numberOfProductCountMessageSink(), 1);
      productCount.dispose();
      expect(numberOfProductCountMessageSink(), 0);
    },
  );

  test(
    'ProductCount value is consistent with number of elements in Basket',
    () async {
      final basket = Basket();
      final productCount = ProductCount();

      basket
        ..add('T-shirt')
        ..add('Socks');
      await Future<void>.delayed(Duration.zero);

      expect(productCount.value, basket.products.length);

      basket.removeLast();
      await Future<void>.delayed(Duration.zero);

      expect(productCount.value, basket.products.length);

      productCount.dispose();
    },
  );
}
