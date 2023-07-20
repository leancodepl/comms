part of '../comms.dart';

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
  void send<T extends Message>(T message, {bool oneOff = false}) {
    MessageSinkRegister().sendToSinksOfType<T>(message, oneOff: oneOff);
  }
}

class SenderFunctor<Message> {
  void call<T extends Message>(T message, {bool oneOff = false}) {
    MessageSinkRegister().sendToSinksOfType<T>(message, oneOff: oneOff);
  }
}

/// Returns an object that can be called like a function (a functor) which sends
/// messages to all [Listener]s of type [Message], without the need of
/// instatiating a class with [Sender] mixin.
///
/// Example usage:
/// ```dart
/// final send = getSend<SomeType>();
/// send(SomeType());
/// ```
SenderFunctor<Message> getSend<Message>() {
  return SenderFunctor<Message>();
}
