# comms

[![codestyle][pub_badge_style]][pub_badge_link]

`comms` is a simple communication pattern abstraction on streams, created for
communication between any classes. It allows `Listener`s to easily react to
messages sent by `Sender`s.

For use in Flutter projects, check out [flutter_comms].

## Installation

```console
$ dart pub add comms
```

## Basic usage

Imagine you had to connect a light bulb and its light switch. In real world you'd
have to use a wire and connect them, in code we can create a `Stream` in the
light bulb and pass its `Sink` to the light switch, but instead of writing all the
boilerplate code you can use `Listener` and `Sender` mixins which do it all for you.

### Creating a Listener

A `Listener` is a mixin which allows your class to receive messages from any
`Sender` sharing the same message type.

```dart
/// Add a `Listener` mixin with type of messages to listen for.
class LightBulb with Listener<bool> {
  LightBulb() {
    /// Call `listen` to start listening.
    listen();
  }

  bool enabled = false;
  
  /// Override `onMessage` to specify how to react to messages.
  @override
  void onMessage(bool message) {
    enabled = message;
  }

  void dispose() {
    /// Call `cancel` to stop listening and clean up.
    cancel();
  }
}
```

### Creating a Sender

```dart
/// Add a `Sender` mixin with type of messages to send.
class LightSwitch with Sender<bool> {
  void enable() {
    /// Call `send` to deliver the message to a Listener.
    send(true);
  }
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
so whenever any `Sender<A>` sends a message every `Listener<A>` will get the it.

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
[flutter_comms]: https://pub.dev/packages/flutter_comms