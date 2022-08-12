part of 'comms.dart';

/// Signature for callbacks sending message to [Listener]'s of type of the type
/// parameter [Message]
typedef Send<Message> = void Function(Message message);

/// A mixin used on classes that want to send messages of type given by the
/// type argument [Message], by providing [send] function.
///
/// See also:
///
///  * [getSend], which returns [send] function
mixin Sender<Message> {
  @protected
  @nonVirtual
  void send(Message message) {
    MessageSinkRegister().getSinksOfType<Message>().forEach(
          (sink) => sink.add(message),
        );
  }
}

/// Returns function to send messages to all [Listener]'s of type of the type
/// parameterer [Message], without the need of instatiating class with [Sender]
/// mixin.
Send<Message> getSend<Message>() {
  return (message) {
    MessageSinkRegister().getSinksOfType<Message>().forEach(
          (sink) => sink.add(message),
        );
  };
}
