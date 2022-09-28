part of '../comms.dart';

/// Helper class used in [MultiListener] to create [Listener]s of specified
/// types.
class ListenerDelegate<T> with Listener<T> {
  ListenerDelegate();

  late final OnMessage _onMessage;

  @protected
  @nonVirtual
  void _init(OnMessage onMessage) {
    _onMessage = onMessage;
    listen();
  }

  @protected
  @nonVirtual
  @override
  void onMessage(T message) => _onMessage(message);
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
  List<ListenerDelegate> get listenerDelegates;

  /// Starts message receiving.
  ///
  /// Registers message sinks based on [listenerDelegates] in
  /// [MessageSinkRegister].
  @protected
  @nonVirtual
  void listen() => listenerDelegates.forEach(_listen);

  void _listen(ListenerDelegate listenerDelegate) =>
      listenerDelegate.._init(onMessage);

  /// Called every time a new [message] of type specified in [listenerDelegates]
  /// is received.
  @protected
  void onMessage(dynamic message);

  /// Stops receiving messages.
  ///
  /// Removes message sinks from [MessageSinkRegister].
  @protected
  @nonVirtual
  void cancel() => listenerDelegates.forEach(_cancel);

  void _cancel(ListenerDelegate listenerDelegate) => listenerDelegate.cancel();
}
