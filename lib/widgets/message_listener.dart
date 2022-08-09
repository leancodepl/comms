import 'package:comms/comms.dart';
import 'package:flutter/material.dart' hide Listener;

class MessageListener<Message> extends StatefulWidget {
  const MessageListener({
    Key? key,
    required this.child,
    required this.onMessage,
  }) : super(key: key);

  final Widget child;
  final OnMessage<Message> onMessage;

  @override
  State<MessageListener> createState() => _MessageListenerState<Message>();
}

class _MessageListenerState<Message> extends State<MessageListener>
    with Listener<Message> {
  @override
  void initState() {
    super.initState();
    listen();
  }

  @override
  void onMessage(Message message) => widget.onMessage(message);

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    cancel();
    super.dispose();
  }
}
