part of '../comms.dart';

/// Helper class used in [MultiListener] to create [Listener]s of specified
/// types.
class ListenerDelegate<T> with Listener<T> {
  ListenerDelegate();

  late OnMessage<T> _onMessage;
  late OnMessage<T> _onInitialMessage;

  @protected
  @nonVirtual
  void _init(OnMessage<T> onMessage, OnMessage<T> onInitialMessage) {
    _onMessage = onMessage;
    _onInitialMessage = onInitialMessage;
    listen();
  }

  @protected
  @nonVirtual
  @override
  void onMessage(T message) => _onMessage(message);

  @protected
  @nonVirtual
  @override
  void onInitialMessage(T message) => _onInitialMessage(message);
}

/// A mixin used on classes that want to receive messages of multiple types.
///
/// Subclasses must call [listen] when they want to start receiving messages and
/// [cancel] when they want to stop receiving messages.
///
/// Subclasses must implement [onMessage].
///
/// See also:
///
///  * [Listener], which enables listening to messages of single type.
mixin MultiListener {
  List<ListenerDelegate<dynamic>> get listenerDelegates;

  /// The delegates registered by the last [listen], cancelled by [cancel].
  ///
  /// [listenerDelegates] may return new instances on every read, so [cancel]
  /// has to use these rather than reading [listenerDelegates] again.
  final _registeredDelegates = <ListenerDelegate<dynamic>>[];

  /// Starts message receiving.
  ///
  /// Registers message sinks based on [listenerDelegates] in
  /// [MessageSinkRegister]. Calling it again cancels the previous registration
  /// first.
  @protected
  @nonVirtual
  void listen() {
    cancel();
    for (final listenerDelegate in listenerDelegates) {
      _registeredDelegates
          .add(listenerDelegate.._init(onMessage, onInitialMessage));
    }
  }

  /// Called every time a new [message] of type specified in [listenerDelegates]
  /// is received.
  @protected
  void onMessage(dynamic message);

  /// Called when registering [MultiListener] if a message of type specified in
  /// [listenerDelegates] was sent earlier by [Sender].
  @protected
  void onInitialMessage(dynamic message) {}

  /// Stops receiving messages.
  ///
  /// Removes message sinks from [MessageSinkRegister].
  @protected
  @nonVirtual
  void cancel() {
    for (final listenerDelegate in _registeredDelegates) {
      listenerDelegate.cancel();
    }
    _registeredDelegates.clear();
  }
}
