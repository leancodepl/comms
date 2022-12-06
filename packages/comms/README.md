# comms

[![codestyle][pub_badge_style]][pub_badge_link]

`comms` is a simple communication pattern abstraction on streams, created for
communication between any logic classes. It allows `Listener`s to easily 
react to messages sent by `Sender`s.

For use in flutter projects checkout [flutter_comms].

## Installation

```console
$ dart pub add comms
```

## Basic usage
Imagine you had to connect a light bulb and its light switch. In real world
you'd have to use cables, but in code we can use `comms` for them to communicate
easily without having to "tear down the walls".

### Creating a Listener

```dart
/// Add a `Listener` mixin with type of messages to listen for.
class LightBulb with Listener<bool> {
  LightBulb() {
    /// Call `listen` to start listening
    listen();
  }

  bool enabled = false;
  
  /// Override `onMessage` to specify how to react on messages.
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
    
  // Because communication is asynchronuos we have to wait
  // just a little bit for the message to reach the `lightBulb`.
  await Future<void>.delayed(Duration.zero);

  print(lightBulb.enabled); // true

  // At the end don't forget to close the connection and cleanup.
  lightBulb.dispose();
}
```

### Multiple Listeners and Senders

With `comms` any `Sender` will send a message to any `Listener` sharing the same
message type.

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
can use `onInitialMessage` which will be invoked after `Listener` calls `listen`
passing the last sent message of specified message type as argument.

```dart
abstract class CounterMessage {}
class CounterIncremented extends CounterMessage {}
class CounterDecremented extends CounterMessage {}

class CounterController with Sender<CounterChanged> {
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
If you need to receive more than one message type in a single `Listener` you
can use `MultiListener` mixin.

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

You can also use `getSend` to send messages from anywhere without even
creating a `Sender`.

```dart
void main() {
  getSend<bool>()(true);
}
```

[pub_badge_style]: https://img.shields.io/badge/style-leancode__lint-black
[pub_badge_link]: https://pub.dartlang.org/packages/leancode_lint
[flutter_comms]: https://pub.dev/packages/flutter_comms