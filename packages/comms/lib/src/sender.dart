part of '../comms.dart';

/// Signature for functions sending message to [Listener]s listening for type
/// [Message].
typedef Send<Message> = void Function(Message message, {bool oneOff});

/// A mixin used on classes that want to send messages of type [Message], by
/// providing [send] function.
///
/// See also:
///
///  * [getSend], which returns [send] function
mixin Sender<Message> {
  /// Sends [message] to all [Listener]s of type [Message].
  ///
  /// When [oneOff] is `true`, [message] will only be received by any [Listener]
  /// currently listening for type [Message]. If there aren't any it will only
  /// be received by the first [Listener] that calls `listen()` in
  /// `onInitialMessage()`.
  @protected
  @nonVirtual
  void send(Message message, {bool oneOff = false}) {
    MessageSinkRegister().sendToSinksOfType<Message>(message, oneOff: oneOff);
  }
}

/// Returns function to send messages to all [Listener]s of type [Message],
/// without the need of instatiating class with [Sender] mixin.
Send<Message> getSend<Message>() {
  return MessageSinkRegister().sendToSinksOfType<Message>;
}
