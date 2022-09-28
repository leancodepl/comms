part of '../comms.dart';

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

mixin MultiListener {
  List<ListenerDelegate> get listenerDelegates;

  @protected
  @nonVirtual
  void listen() => listenerDelegates.forEach(_listen);

  void _listen(ListenerDelegate listenerDelegate) =>
      listenerDelegate.._init(onMessage);

  @protected
  void onMessage(dynamic message);

  @protected
  @nonVirtual
  void cancel() => listenerDelegates.forEach(_cancel);

  void _cancel(ListenerDelegate listenerDelegate) => listenerDelegate.cancel();
}
