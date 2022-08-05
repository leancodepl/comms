library comms;

import 'dart:async';

import 'package:bloc/bloc.dart' show Cubit;
import 'package:flutter/foundation.dart' show protected;
import 'package:flutter/material.dart' show mustCallSuper;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

typedef Send<Message> = void Function(Message message);
typedef OnMessage<Message> = void Function(Message message);

class _MessageSinkRegister {
  factory _MessageSinkRegister() => _instance;

  _MessageSinkRegister._();

  static final _MessageSinkRegister _instance = _MessageSinkRegister._();

  final _logger = Logger('MessageSinkRegister');
  final _uuid = const Uuid();
  final _messageSinks = <String, StreamSink>{};

  String add(StreamSink sink) {
    final id = _uuid.v1();
    _messageSinks[id] = sink;
    _logger.info('Added sink ${sink.runtimeType}');
    return id;
  }

  void remove(String id) {
    final sink = _messageSinks.remove(id);
    _logger.info('Removed sink ${sink.runtimeType}');
  }

  List<StreamSink<Message>> getSinksOfType<Message>() {
    final sinks =
        _messageSinks.values.whereType<StreamSink<Message>>().toList();
    if (sinks.isEmpty) {
      _logger.info('Found no sinks of type $Message');
    }
    return sinks;
  }
}

mixin Listener<Message> {
  final _messageStreamController = StreamController<Message>();

  late final StreamSubscription<Message> _messageSubscription;

  late final String _id;

  @protected
  @mustCallSuper
  void listen() {
    print('test');
    _id = _MessageSinkRegister().add(_messageStreamController.sink);
    _messageSubscription = _messageStreamController.stream.listen(onMessage);
  }

  @protected
  void onMessage(Message message);

  @protected
  @mustCallSuper
  void cancel() {
    // TODO: think about creating a custom lint for enforcing calling cancel
    _MessageSinkRegister().remove(_id);
    _messageSubscription.cancel();
  }
}

abstract class ListenerCubit<State, Message> extends Cubit<State>
    with Listener<Message> {
  ListenerCubit(State initialState) : super(initialState) {
    super.listen();
  }

  @override
  @mustCallSuper
  Future<void> close() {
    super.cancel();
    return super.close();
  }
}

mixin Sender<Message> {
  @protected
  @mustCallSuper
  void send(Message message) {
    _MessageSinkRegister().getSinksOfType<Message>().forEach(
          (sink) => sink.add(message),
        );
  }
}

void useListener<Message>(
  OnMessage<Message> onMessage, [
  List<Object?>? keys,
]) {
  final messageStreamController = useStreamController<Message>(keys: keys);
  final messageSubscription = useMemoized(
    () => messageStreamController.stream.listen(onMessage),
    keys ?? [],
  );

  final id = _MessageSinkRegister().add(messageStreamController.sink);

  useEffect(
    () => () {
      _MessageSinkRegister().remove(id);
      messageSubscription.cancel();
    },
    keys ?? [],
  );
}

Send<Message> getSend<Message>() {
  return (message) {
    _MessageSinkRegister().getSinksOfType<Message>().forEach(
          (sink) => sink.add(message),
        );
  };
}
