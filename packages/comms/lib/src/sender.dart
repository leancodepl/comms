part of '../comms.dart';

/// Signature for functions sending message to [Listener]s listening for type
/// [Message].
typedef Send<Message> = void Function(Message message);

/// A mixin used on classes that want to send messages of type [Message], by
/// providing [send] function.
///
/// See also:
///
///  * [getSend], which returns [send] function
mixin Sender<Message> {
  @protected
  @nonVirtual
  void send(Message message) {
    MessageSinkRegister().sendToSinksOfType<Message>(message);
  }
}

/// Returns function to send messages to all [Listener]s of type of the type
/// parameterer [Message], without the need of instatiating class with [Sender]
/// mixin.
Send<Message> getSend<Message>() {
  return MessageSinkRegister().sendToSinksOfType<Message>;
}
