# flutter_comms

[![codestyle][pub_badge_style]][pub_badge_link]

`flutter_comms` builds on top of [comms], making it easier to implement comms pattern
in Flutter projects.

For use in dart only projects, use [comms].

## Installation

```console
$ flutter pub add flutter_comms
```

## Basic usage

You can mix in `Listener` and `Sender` mixins to widgets but for more convenience
helper widgets have been prepared.

### MessageListener

A `MessageListener` works exactly like `Listener` but calls `listen` and `cancel`
functions for you, enabling it to receive messages from any `Sender`sharing the
same message type.

```dart
MessageListener<MessageA>(
  onMessage: (message) {
    // handle received messages
  },
  onIntialMessage: (message) {
    // handle initial message
  },
  child: Widget(),
)
```

### MultiMessageListener

Merges multiple `MessageListener` widgets, improving the readability of
nested `MessageListener`s.

```dart
MultiMessageListener(
  listeners: [
    MessageListener<MessageA>(
      onMessage: (message) {},
    ),
    MessageListener<MessageB>(
      onMessage: (message) {},
    ),
  ],
  child: Widget(),
)
```

### useMessageListener

`useMessageListener` hook calls `onMessage` everytime a message of type `Message`
is received. Works similarly to `Listener` but handles starting message receiving
and cleaning up itself.

This hook will receive messages only when `HookWidget` using it is built.

```dart
Widget build(BuildContext context) {
  useMessageListener<MessageA>(
    (message) {
      // handle received messages
    },
    onInitialMessage: (message) {
      // handle initial message
    }
  );
}
```

[pub_badge_style]: https://img.shields.io/badge/style-leancode__lint-black
[pub_badge_link]: https://pub.dartlang.org/packages/leancode_lint
[comms]: https://pub.dev/packages/comms
