import 'package:comms/comms.dart';
import 'package:test/test.dart';

import 'listeners/basket_multi_listener.dart';
import 'messages/basket_cleared.dart';
import 'messages/product_count_changed.dart';

int numberOfSinks<Message>() =>
    MessageSinkRegister().getSinksOfType<Message>().length;

Future<void> nextEventLoop() => Future<void>.delayed(Duration.zero);

void main() {
  setUp(() => MessageSinkRegister().clear());

  final variants = <String, BasketMultiListener Function()>{
    'getter': GetterBasketMultiListener.new,
    'field': FieldBasketMultiListener.new,
  };

  for (final MapEntry(key: form, value: create) in variants.entries) {
    group('MultiListener with listenerDelegates as a $form', () {
      test('listen adds a message sink for every delegate', () {
        final listener = create()..start();

        expect(numberOfSinks<ProductCountChangedMessage>(), 1);
        expect(numberOfSinks<BasketClearedMessage>(), 1);

        listener.stop();
      });

      test('cancel removes the message sinks added by listen', () {
        create()
          ..start()
          ..stop();

        expect(numberOfSinks<ProductCountChangedMessage>(), 0);
        expect(numberOfSinks<BasketClearedMessage>(), 0);
      });

      test('receives messages of every delegate type until cancel', () async {
        final listener = create()..start();

        getSend<ProductCountChangedMessage>()(ProductCountIncremented());
        getSend<BasketClearedMessage>()(BasketClearedMessage());
        await nextEventLoop();

        expect(listener.messages, hasLength(2));

        listener.stop();
        getSend<BasketClearedMessage>()(BasketClearedMessage());
        await nextEventLoop();

        expect(listener.messages, hasLength(2));
      });

      test('cancel before listen does nothing', () {
        create().stop();

        expect(numberOfSinks<ProductCountChangedMessage>(), 0);
      });

      test('listen twice keeps a single message sink per delegate', () async {
        final listener = create()
          ..start()
          ..start();

        expect(numberOfSinks<ProductCountChangedMessage>(), 1);

        getSend<ProductCountChangedMessage>()(ProductCountIncremented());
        await nextEventLoop();

        expect(listener.messages, hasLength(1));

        listener.stop();
        expect(numberOfSinks<ProductCountChangedMessage>(), 0);
      });

      test('listen after cancel receives messages again', () async {
        final listener = create()
          ..start()
          ..stop()
          ..start();

        getSend<BasketClearedMessage>()(BasketClearedMessage());
        await nextEventLoop();

        expect(listener.messages, hasLength(1));

        listener.stop();
      });

      test('onInitialMessage receives the last buffered message', () {
        getSend<BasketClearedMessage>()(BasketClearedMessage());

        final listener = create()..start();

        expect(listener.messages.single, isA<BasketClearedMessage>());

        listener.stop();
      });
    });
  }
}
