# flutter_comms

[![flutter_comms-pub-badge]][flutter_comms-pub-badge-link] [![flutter_comms-build-badge]][flutter_comms-build-badge-link] [![codestyle][pub_badge_style]][pub_badge_link]

`flutter_comms` builds on top of [comms], making it easier to implement comms pattern
in Flutter projects.

For use in dart only projects, use [comms].

## Installation

```console
flutter pub add flutter_comms
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

`useMessageListener` hook calls `onMessage` every time a message of type `Message`
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

## Sending messages from State Management to UI

A typical real life use case of comms pattern is showing a toast or some popup with error
or info message. States of any state management could be used for that but they are
preserved even after the toast naturally disappears, so you have to clean the state yourself.
With comms it's much more convenient.

```dart
class AuthNotifier with ChangeNotifier, Sender<AuthError> {
  AuthNotifier(AuthRepository authRepository)
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  bool _authenticated;
  bool get authenticated => _authenticated;

  Future<void> login(String username, String password) async {
    try {
      final loggedIn = await _authRepository.login(username, password);

      if (loggedIn) {
        _authenticated = true;
        notifyListeners();
      } else {
        // All messages are cached to be able to use `onInitialMessage`. This
        // time we need to set `oneOff` to `true`, otherwise on each Widget
        // rebuild this message would be received. This still allows your
        // widget to receive the message even if it gets build after message
        // is sent, provided that this widget will be the first to receive it.
        send(AuthError(message: 'Incorrect credentials'), oneOff: true);
      }
    } catch (e, st) {
      send(AuthError(message: 'An unexpected error occurred'), oneOff: true);
    }
  }
...
}
```

We can use `AuthError` messages as single-time events which disappear instantly after
displaying a snack bar, so no manual clean up is required. 

```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MessageListener<AuthError>(
      onMessage: (authError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(authError.message)),
        );
      },
      child: LoginForm(),
    );
  }
}
```

[flutter_comms-pub-badge]: https://img.shields.io/pub/v/flutter_comms
[flutter_comms-pub-badge-link]: https://pub.dev/packages/flutter_comms
[flutter_comms-build-badge]: https://img.shields.io/github/actions/workflow/status/leancodepl/comms/flutter_comms-prepare.yaml?branch=master
[flutter_comms-build-badge-link]: https://github.com/leancodepl/comms/actions/workflows/flutter_comms-prepare.yaml
[pub_badge_style]: https://img.shields.io/badge/style-leancode__lint-black
[pub_badge_link]: https://pub.dartlang.org/packages/leancode_lint
[comms]: https://pub.dev/packages/comms
