part of '../comms.dart';

/// Signature for callbacks that are run when a message is received.
typedef OnMessage<Message> = void Function(Message message);

/// A mixin used on classes that want to receive messages of type [Message].
///
/// Subclasses must call [listen] when they want to start receiving messages and
/// [cancel] when they want to stop receiving messages.
///
/// Subclasses must implement [onMessage].
mixin Listener<Message> {
  late final StreamController<Message> _messageStreamController;

  late final StreamSubscription<Message> _messageSubscription;

  /// Unique identifier of the [Listener]'s messageSink in [MessageSinkRegister].
  String? _id;

  /// Starts message receiving.
  ///
  /// Registers message sink in [MessageSinkRegister].
  ///
  /// If this [Listener]s message sink is already registered, it's automatically
  /// unregistered first.
  @protected
  @nonVirtual
  void listen() {
    if (_id != null) {
      cancel();
    }
    _messageStreamController = StreamController<Message>();
    _id = MessageSinkRegister().add(_messageStreamController.sink);
    _messageSubscription = _messageStreamController.stream.listen(onMessage);
  }

  /// Called every time a new [message] is received.
  @protected
  void onMessage(Message message);

  /// Stops receiving messages.
  ///
  /// Removes message sink from [MessageSinkRegister].
  ///
  /// When called before [listen] does nothing.
  @protected
  @nonVirtual
  void cancel() {
    if (_id != null) {
      MessageSinkRegister().remove(_id!);
      _messageStreamController.close();
      _messageSubscription.cancel();
      _id = null;
    }
  }
}
