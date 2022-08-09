part of 'comms.dart';

@visibleForTesting
class MessageSinkRegister {
  factory MessageSinkRegister() => _instance;

  MessageSinkRegister._();

  static final MessageSinkRegister _instance = MessageSinkRegister._();

  final _logger = Logger('MessageSinkRegister');
  final _uuid = const Uuid();
  final _messageSinks = <String, StreamSink>{};
  
  String _add(StreamSink sink) {
    final id = _uuid.v1();
    _messageSinks[id] = sink;
    _logger.info('Added sink ${sink.runtimeType}');
    return id;
  }

  void _remove(String id) {
    final sink = _messageSinks.remove(id);
    _logger.info('Removed sink ${sink.runtimeType}');
  }

  @visibleForTesting
  List<StreamSink<Message>> getSinksOfType<Message>() {
    final sinks =
        _messageSinks.values.whereType<StreamSink<Message>>().toList();
    if (sinks.isEmpty) {
      _logger.info('Found no sinks of type $Message');
    }
    return sinks;
  }
}
