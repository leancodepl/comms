part of '../comms.dart';

/// Signature for callbacks that are run when a message is received.
typedef OnMessage<Message> = void Function(Message message);

/// A mixin used on classes that want to receive messages of type [Message].
///
/// Subclasses must call [listen] when they want to start receiving messages and
/// [cancel] when they want to stop receiving messages.
///
/// Subclasses must implement [onMessage].
///
/// See also:
///
///  * [Listener2], which enables listening to two different types of messages.
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
    _id = MessageSinkRegister()._add(_messageStreamController.sink);
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
      MessageSinkRegister()._remove(_id!);
      _messageStreamController.close();
      _messageSubscription.cancel();
      _id = null;
    }
  }
}

/// A mixin used on classes that want to receive messages of type [Message1] and
/// [Message2].
///
/// Subclasses must call [listen] when they want to start receiving messages and
/// [cancel] when they want to stop receiving messages.
///
/// Subclasses must implement [onMessage1] and [onMessage2].
mixin Listener2<Message1, Message2> {
  late final StreamController<Message1> _messageStreamController1;
  late final StreamController<Message2> _messageStreamController2;

  late final StreamSubscription<Message1> _messageSubscription1;
  late final StreamSubscription<Message2> _messageSubscription2;

  /// Unique identifier of the [Listener]'s messageSink1 in
  /// [MessageSinkRegister].
  String? _id1;

  /// Unique identifier of the [Listener]'s messageSink2 in
  /// [MessageSinkRegister].
  String? _id2;

  /// Starts message receiving.
  ///
  /// Registers message sink in [MessageSinkRegister].
  ///
  /// If this [Listener]s message sink is already registered, it's automatically
  /// unregistered first.
  @protected
  @nonVirtual
  void listen() {
    if (_id1 != null && _id2 != null) {
      cancel();
    }

    _messageStreamController1 = StreamController<Message1>();
    _messageStreamController2 = StreamController<Message2>();

    _id1 = MessageSinkRegister()._add(_messageStreamController1.sink);
    _id2 = MessageSinkRegister()._add(_messageStreamController2.sink);

    _messageSubscription1 = _messageStreamController1.stream.listen(onMessage1);
    _messageSubscription2 = _messageStreamController2.stream.listen(onMessage2);
  }

  /// Called every time a new [message] of type [Message1] is received.
  @protected
  void onMessage1(Message1 message);

  /// Called every time a new [message] of type [Message2] is received.
  @protected
  void onMessage2(Message2 message);

  /// Stops receiving messages.
  ///
  /// Removes message sinks from [MessageSinkRegister].
  ///
  /// When called before [listen] does nothing.
  @protected
  @nonVirtual
  void cancel() {
    if (_id1 != null && _id2 != null) {
      MessageSinkRegister()._remove(_id1!);
      MessageSinkRegister()._remove(_id2!);

      _messageStreamController1.close();
      _messageStreamController2.close();

      _messageSubscription1.cancel();
      _messageSubscription2.cancel();

      _id1 = null;
      _id2 = null;
    }
  }
}
