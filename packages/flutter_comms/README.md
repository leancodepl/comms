# flutter_comms

[![codestyle][pub_badge_style]][pub_badge_link]

`flutter_comms` builds on top of [comms], making it easier to implement comms pattern
in Flutter projects.

For use in Dart projects, use [comms].

## Installation

```console
$ flutter pub add flutter_comms
```

## Communicating between blocs

To communicate between blocs you can use `Sender` and `Listener` mixins, but for 
more convenience there are added `ListenerCubit` or `ListenerBloc` classes and 
`StateSender` mixin.

### Creating a ListenerCubit

A `ListenerCubit` works exactly like `Listener` but calls `listen` and `cancel`
functions for you, enabling your `Cubit` to receive messages from any `Sender`
sharing the same message type.

```dart
/// Use `ListenerCubit` instead of `Cubit`
class LightBulbCubit with ListenerCubit<LightBulbState, LightBulbMessage> {
  LightBulbCubit() : super(LightBulbState(false));
  
  /// Override `onMessage` to specify how to react to messages.
  @override
  void onMessage(LightBulbMessage message) {
    if (message is LightBulbEnable) {
      emit(LightBulbState(true));
    } else if (message is LightBulbDisable) {
      emit(LightBulbState(false));
    }
  }
}

class LightBulbState {
  LightBulbState(this.enabled)
  final bool enabled;
}

abstract class LightBulbMessage {}
class LightBulbEnable extends LightBulbMessage {}
class LightBulbDisable extends LightBulbMessage {}
```

TODO below this
### Creating a Sender

```dart
/// Add a `Sender` mixin with type of messages to send.
class LightSwitchBloc extends Bloc<LightSwitchEvent, bool> 
  with Sender<LightBulbMessage> {
  LightSwitchBloc() : super(false) {
    on<LightSwitchEnable>
  };
}
```

### Using Listener and Sender

```dart
void main() async {
  // Just create instances of both classes, comms will 
  // handle connection between them.
  final lightBulb = LightBulb();
  final lightSwitch = LightSwitch();

  print(lightBulb.enabled); // false

  lightSwitch.enable();
    
  // Because communication is asynchronous we have to wait until the
  // next event loop iteration for the message to reach the `lightBulb`.
  await Future<void>.delayed(Duration.zero);

  print(lightBulb.enabled); // true

  // Clean up resources once done.
  lightBulb.dispose();
}
```

### Multiple Listeners and Senders

A `Sender` sends a message to all `Listener`s sharing the same message type,
so whenever any `Sender<A>` sends a message every `Listener<A>` will get it.

```dart
void main() async {
  final lightBulbA = LightBulb();
  final lightSwitchA = LightSwitch();
  
  final lightBulbB = LightBulb();
  final lightSwitchB = LightSwitch();

  print(lightBulbA.enabled); // false
  print(lightBulbB.enabled); // false

  lightSwitchB.enable();

  print(lightBulbA.enabled); // true
  print(lightBulbB.enabled); // true
}
```

## Handling initial message
To handle the last message sent before creating an instance of `Listener` you
can override `onInitialMessage`, which is called after your `Listener` calls `listen`
passing the last sent message of specified message type as argument.

```dart
abstract class CounterMessage {}
class CounterIncremented extends CounterMessage {}
class CounterDecremented extends CounterMessage {}

class CounterController with Sender<CounterMessage> {
  void increment() => send(CounterIncremented());
  void decrement() => send(CounterDecremented());
}

class Counter with Listener<CounterMessage> {
  Counter() {
    listen();
  }

  int count = 0;

  @override
  void onMessage(CounterMessage message) {
    if (message is CounterIncremented) {
      count--;
    }
    if (message is CounterDecremented) {
      count++
    }
  }

  @override
  void onInitialMessage(CounterMessage message) => onMessage(message);
}

void main() {
  final counterController = CounterController();

  counterController.increment();

  final counter = Counter();
    
  print(counter.count); // 1
}
```

## Listening for multiple message types
If you need to receive more than one message type in a single `Listener` class, you
can use the `MultiListener` mixin.

```dart
class MyListener with MultiListener {
  MyListener() {
    listen();
  }

  @override
  List<ListenerDelegate> get listenerDelegates => [
        ListenerDelegate<CounterMessage>(),
        ListenerDelegate<AuthMessage>(),
      ];

  @override
  void onMessage(dynamic message) {
    if (message is CounterMessage) {...}
    if (message is AuthMessage) {...}
  }
}
```

## Custom Senders
To create a custom `Sender` for example to send multiple message types, you
 can use `getSend` which returns `send` method for messages of passed type.

```dart
mixin CustomSender {
  final sendString = getSend<String>();
  final sendInt = getSend<int>();

  void sendMessages() {
    sendString('hello');
    sendInt(1);
  }
}
```

You can also use the `getSend` function to send messages from anywhere without even
creating a `Sender`.

```dart
void main() {
  getSend<bool>()(true);
}
```

[pub_badge_style]: https://img.shields.io/badge/style-leancode__lint-black
[pub_badge_link]: https://pub.dartlang.org/packages/leancode_lint
[comms]: https://pub.dev/packages/comms
