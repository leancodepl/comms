import 'package:flutter_comms/src/widgets/message_listener.dart';
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
    super.key,
    required List<MessageListenerSingleChildWidget> listeners,
    super.child,
  }) : super(children: listeners);
}
