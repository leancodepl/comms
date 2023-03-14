import 'package:comms/comms.dart';
import 'package:flutter/material.dart' hide Listener;
import 'package:nested/nested.dart';

/// Mixin which allows MultiMessageListener to infer the types
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
    super.key,
    required this.onMessage,
    this.onInitialMessage,
    super.child,
  });

  final OnMessage<Message> onMessage;
  final OnMessage<Message>? onInitialMessage;

  @override
  State<MessageListener<Message>> createState() =>
      _MessageListenerState<Message>();
}

class _MessageListenerState<Message>
    extends SingleChildState<MessageListener<Message>> with Listener<Message> {
  @override
  void initState() {
    super.initState();
    listen();
  }

  @override
  void onMessage(Message message) => widget.onMessage(message);

  @override
  void onInitialMessage(Message message) =>
      widget.onInitialMessage?.call(message);

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
