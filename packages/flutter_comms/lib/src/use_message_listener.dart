import 'package:comms/comms.dart';
import 'package:flutter/material.dart' hide Listener;
import 'package:flutter_hooks/flutter_hooks.dart';

/// Calls [onMessage] everytime a message of type [Message] is received.
///
/// Works similarly to [Listener] but handles starting receiving messages and
/// cleaning up itself.
void useMessageListener<Message>(
  OnMessage<Message> onMessage, {
  OnMessage<Message>? onInitialMessage,
  List<Object?> keys = const <Object>[],
}) {
  use(
    _MessageListenerHook<Message>(
      onMessage: onMessage,
      onInitialMessage: onInitialMessage,
      keys: keys,
    ),
  );
}

class _MessageListenerHook<Message> extends Hook<void> {
  const _MessageListenerHook({
    required this.onMessage,
    required List<Object?> keys,
    this.onInitialMessage,
  }) : super(keys: keys);

  final OnMessage<Message> onMessage;
  final OnMessage<Message>? onInitialMessage;

  @override
  _MessageListenerHookState<Message> createState() =>
      _MessageListenerHookState<Message>();
}

class _MessageListenerHookState<Message>
    extends HookState<void, _MessageListenerHook<Message>>
    with Listener<Message> {
  @override
  void initHook() {
    super.initHook();
    listen();
  }

  @override
  void onMessage(Message message) => hook.onMessage(message);

  @override
  void onInitialMessage(Message message) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => hook.onInitialMessage?.call(message),
    );
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  @override
  void build(BuildContext context) {}

  @override
  String get debugLabel => 'useMessageListener<$Message>';
}
