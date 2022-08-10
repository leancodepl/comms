import 'package:comms/comms.dart';
import 'package:flutter/material.dart' hide Listener;
import 'package:nested/nested.dart';

mixin MessageListenerSingleChildWidget on SingleChildWidget {}

class MessageListener<Message> extends SingleChildStatefulWidget
    with MessageListenerSingleChildWidget {
  const MessageListener({
    Key? key,
    Widget? child,
    required this.onMessage,
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

class MultiMessageListener extends Nested {
  MultiMessageListener({
    Key? key,
    required List<MessageListenerSingleChildWidget> listeners,
    required Widget child,
  }) : super(key: key, children: listeners, child: child);
}
