import 'package:comms/comms.dart';
import 'package:flutter/material.dart' hide Listener;
import 'package:nested/nested.dart';

/// Mixin which allows [MultiMessageListener] to infer the types
/// of multiple [MessageListener]s.
mixin MessageListenerSingleChildWidget on SingleChildWidget {}

/// Takes a [OnMessage] function wchich will be called each time any [Sender]
/// of type argument [Message] sends a message.
///
/// ```dart
/// MessageListener<MessageA>(
///   onMessage: (message) {
///     // do stuff here based on message
///   },
///   child: Container(),
/// )
/// ```
class MessageListener<Message> extends SingleChildStatefulWidget
    with MessageListenerSingleChildWidget {
  const MessageListener({
    Key? key,
    required this.onMessage,
    Widget? child,
  }) : super(key: key, child: child);

  final OnMessage<Message> onMessage;

  @override
  State<MessageListener> createState() => _MessageListenerState<Message>();
}

class _MessageListenerState<Message> extends SingleChildState<MessageListener>
    with Listener<Message> {
  @override
  void initState() {
    super.initState();
    listen();
  }

  @override
  void onMessage(Message message) => widget.onMessage(message);

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '''${widget.runtimeType} used outside of MultiMessageListener must specify a child''',
    );
    return child!;
  }
}

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
