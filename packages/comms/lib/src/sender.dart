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
  /// When [oneOff] is `true` [message] will be removed from the buffer after
  /// the first [Listener] of same type calls listen().
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
