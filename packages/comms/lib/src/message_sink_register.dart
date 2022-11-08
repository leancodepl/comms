part of '../comms.dart';

typedef _LogggerCallback = void Function(String message);

/// Allows communication between [Listener]s and [Sender]s of the same type,
/// without the need of them knowing about each other.
@visibleForTesting
class MessageSinkRegister {
  /// A singleton constructor.
  ///
  /// There's no need for more than a single [MessageSinkRegister] to exist.
  factory MessageSinkRegister() => _instance;

  MessageSinkRegister._();

  static final MessageSinkRegister _instance = MessageSinkRegister._();

  static bool loggingEnabled = true;
  static _LogggerCallback? log;
  final _logger = Logger('MessageSinkRegister');

  void _log(String message) {
    if (!loggingEnabled) {
      return;
    }

    final logFunction = log;
    if (logFunction != null) {
      logFunction(message);
      return;
    }

    _logger.info(message);
  }

  /// Used to create unique id for each message sink added with [_add].
  final _uuid = const Uuid();

  /// All message sinks and their id's added with [_add].
  final _messageSinks = <String, StreamSink>{};

  /// Adds a [messageSink] to [MessageSinkRegister]'s [_messageSinks] with
  /// unique id from [_uuid]
  String _add(StreamSink messageSink) {
    final id = _uuid.v1();
    _messageSinks[id] = messageSink;
    _log('Added sink ${messageSink.runtimeType}');
    return id;
  }

  /// Removes messageSink with [id] from [MessageSinkRegister]'s [_messageSinks]
  void _remove(String id) {
    final sink = _messageSinks.remove(id);
    _log('Removed sink ${sink.runtimeType}');
    sink?.close();
  }

  /// Returns all sinks in [MessageSinkRegister]'s [_messageSinks] of type
  /// of the type argument [Message]
  @visibleForTesting
  List<StreamSink<Message>> getSinksOfType<Message>() {
    final sinks =
        _messageSinks.values.whereType<StreamSink<Message>>().toList();
    if (sinks.isEmpty) {
      _log('Found no sinks of type $Message');
    }
    return sinks;
  }
}
