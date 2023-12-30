import 'package:comms/comms.dart';
import 'package:test/test.dart';

import 'listeners/product_count_listener.dart';
import 'listeners/product_count_listener_cubit.dart';
import 'messages/product_count_changed.dart';
import 'senders/basket_cubit_sender.dart';
import 'senders/basket_sender.dart';

int numberOfProductCountMessageSink() =>
    MessageSinkRegister().getSinksOfType<ProductCountChangedMessage>().length;

void main() {
  setUp(() => MessageSinkRegister().clear());

  group('Listener - Sender', () {
    test(
      'ProductCountListener message sink is added to register after it calls listen in constructor',
      () {
        final productCount = ProductCountListener();
        expect(numberOfProductCountMessageSink(), 1);
        productCount.dispose();
      },
    );

    test(
      'ProductCountListener message sink is removed from register after it calls cancel in dispose',
      () {
        final productCount = ProductCountListener();
        expect(numberOfProductCountMessageSink(), 1);
        productCount.dispose();
        expect(numberOfProductCountMessageSink(), 0);
      },
    );

    test(
      'ProductCountListener value is consistent with number of elements in BasketSender',
      () async {
        final basket = BasketSender();
        final productCount = ProductCountListener();

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

    test(
      'ProductCountListener value correctly sets initial state using buffered message',
      () async {
        final basket = BasketSender()..add('Jeans');
        final productCount = ProductCountListener();

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

    test(
      'ProductCountIncrementedListener listens only for ProductCountIncremented',
      () async {
        final basket = IncrementingBasket();
        final productCount = ProductCountIncrementedListener();

        basket
          ..add('Jeans')
          ..add('T-shirt');

        await Future<void>.delayed(Duration.zero);

        expect(productCount.value, 2);

        getSend<ProductCountDecremented>()(ProductCountDecremented());
        await Future<void>.delayed(Duration.zero);

        expect(productCount.value, 2);

        getSend<ProductCountChangedMessage>()(ProductCountIncremented());
        await Future<void>.delayed(Duration.zero);

        expect(productCount.value, 3);

        getSend<ProductCountChangedMessage>()(ProductCountChangedMessage());
        await Future<void>.delayed(Duration.zero);

        expect(productCount.value, 3);

        productCount.dispose();
      },
    );

    test(
      'ProductCountIncrementedListener receives buffered message of exact same type',
      () async {
        final basket = IncrementingBasket()..add('Product');
        final productCount = ProductCountIncrementedListener();

        basket
          ..add('Jeans')
          ..add('T-shirt');

        await Future<void>.delayed(Duration.zero);

        expect(productCount.value, 3);

        productCount.dispose();
      },
    );

    test(
      'ProductCountListener receives buffered message of sub type',
      () async {
        getSend<ProductCountIncremented>()(ProductCountIncremented());
        final productCount = ProductCountListener();

        await Future<void>.delayed(Duration.zero);

        expect(productCount.value, 1);

        productCount.dispose();
      },
    );

    test(
      'ProductCountIncrementedListener does not receive buffered message of super type',
      () async {
        getSend<ProductCountChangedMessage>()(ProductCountChangedMessage());
        final productCount = ProductCountIncrementedListener();

        await Future<void>.delayed(Duration.zero);

        expect(productCount.value, 0);

        productCount.dispose();
      },
    );
  });

  group('ListenerCubit - Sender:', () {
    test(
      'ProductCountListenerCubit message sink is added to register after constructor',
      () async {
        final cubit = ProductCountListenerCubit();
        expect(numberOfProductCountMessageSink(), 1);
        await cubit.close();
      },
    );

    test(
      'ProductCountListenerCubit message sink is removed from register after close',
      () async {
        final cubit = ProductCountListenerCubit();
        expect(numberOfProductCountMessageSink(), 1);
        await cubit.close();
        expect(numberOfProductCountMessageSink(), 0);
      },
    );

    test(
      'ProductCountListenerCubit state is consistent with number of elements in BasketCubitSender state',
      () async {
        final basketCubit = BasketCubitSender();
        final productCountCubit = ProductCountListenerCubit();

        basketCubit
          ..add('T-shirt')
          ..add('Socks');
        await Future<void>.delayed(Duration.zero);

        expect(productCountCubit.state, basketCubit.state.length);

        basketCubit.removeLast();
        await Future<void>.delayed(Duration.zero);

        expect(productCountCubit.state, basketCubit.state.length);

        await basketCubit.close();
        await productCountCubit.close();
      },
    );

    test(
      'ProductCountListenerCubit correctly sets initial state using buffered message',
      () async {
        final basketCubit = BasketCubitSender()..add('Jeans');
        final productCountCubit = ProductCountListenerCubit();

        basketCubit
          ..add('T-shirt')
          ..add('Socks');
        await Future<void>.delayed(Duration.zero);

        expect(productCountCubit.state, basketCubit.state.length);

        basketCubit.removeLast();
        await Future<void>.delayed(Duration.zero);

        expect(productCountCubit.state, basketCubit.state.length);

        await basketCubit.close();
        await productCountCubit.close();
      },
    );
  });
}
