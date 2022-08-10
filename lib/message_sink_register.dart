part of 'comms.dart';

/// Responsible for allowing communication between [Listener] and [Sender] of 
/// the same type, without the need of them knowing about each other.
@visibleForTesting
class MessageSinkRegister {
  /// Singleton constructor, there should be only one [MessageSinkRegister] in 
  /// the system.
  factory MessageSinkRegister() => _instance;

  MessageSinkRegister._();

  static final MessageSinkRegister _instance = MessageSinkRegister._();

  final _logger = Logger('MessageSinkRegister');

  /// Used to create unique id for each message sink added with [_add].
  final _uuid = const Uuid();

  /// All message sinks and their id's in the system added with [_add].
  final _messageSinks = <String, StreamSink>{};

  /// Adds a [messageSink] to [MessageSinkRegister]'s [_messageSinks] with
  /// unique id from [_uuid]
  String _add(StreamSink messageSink) {
    final id = _uuid.v1();
    _messageSinks[id] = messageSink;
    _logger.info('Added sink ${messageSink.runtimeType}');
    return id;
  }

  /// Removes messageSink with [id] from [MessageSinkRegister]'s [_messageSinks]
  void _remove(String id) {
    final sink = _messageSinks.remove(id);
    _logger.info('Removed sink ${sink.runtimeType}');
    sink?.close();
  }

  /// Returns all sinks in [MessageSinkRegister]'s [_messageSinks] of type
  /// [Message]
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
