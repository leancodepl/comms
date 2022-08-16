import 'package:comms/comms.dart';
import 'package:flutter_test/flutter_test.dart';

import 'listeners/product_count_cubit.dart';
import 'senders/basket_cubit.dart';

int numberOfProductCountMessageSink() =>
    MessageSinkRegister().getSinksOfType<ProductCountChangedMessage>().length;

void main() {
  group('ListenerCubit - Sender:', () {
    test(
      'ProductCountListenerCubit message sink is added to register after constructor',
      () {
        final cubit = ProductCountListenerCubit();
        expect(numberOfProductCountMessageSink(), 1);
        cubit.close();
      },
    );

    test(
      'ProductCountListenerCubit message sink is removed from register after close',
      () {
        final cubit = ProductCountListenerCubit();
        expect(numberOfProductCountMessageSink(), 1);
        cubit.close();
        expect(numberOfProductCountMessageSink(), 0);
      },
    );

    test(
      'ProductCountListenerCubit state is consistent with number of elements in BasketCubit state',
      () async {
        final basketCubit = BasketCubit();
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
