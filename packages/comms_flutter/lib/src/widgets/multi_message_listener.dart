import 'package:comms/widgets/message_listener.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

/// Merges multiple [MessageListener] widgets, improving the readability of
/// nested [MessageListener]s.
///
/// ```dart
/// MultiMessageListener(
///   listeners: [
///     MessageListener<MessageA>(
///       onMessage: (message) {},
///     ),
///     MessageListener<MessageB>(
///       onMessage: (message) {},
///     ),
///     MessageListener<MessageC>(
///       onMessage: (message) {},
///     ),
///   ],
///   child: Container(),
/// )
/// ```
///
class MultiMessageListener extends Nested {
  MultiMessageListener({
    Key? key,
    required List<MessageListenerSingleChildWidget> listeners,
    required Widget child,
  }) : super(key: key, children: listeners, child: child);
}
