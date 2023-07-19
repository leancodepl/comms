part of '../comms.dart';

typedef LoggerCallback = void Function(String message);

typedef _Contra<T> = void Function(T);
_Contra<T> _makeContra<T>() => (_) {};

/// Allows communication between [Listener]s and [Sender]s of the same type,
/// without the need of them knowing about each other.
class MessageSinkRegister {
  /// A singleton constructor.
  ///
  /// There's no need for more than a single [MessageSinkRegister] to exist.
  factory MessageSinkRegister() => _instance;

  MessageSinkRegister._();

  static final MessageSinkRegister _instance = MessageSinkRegister._();

  static bool loggingEnabled = true;
  static LoggerCallback? log;
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

  /// All message sinks and their id's added with [_add].
  final Map<_Contra<Never>, StreamSink<dynamic>> _messageSinks = {};
  final List<_Contra<Never>> _messageSinkKeys = [];

  /// All last messages sent with each type
  final Map<Type, _BufferedMessage<dynamic>> _messageBuffers = {};

  /// Adds a [messageSink] to [MessageSinkRegister]'s [_messageSinks]
  _Contra<Message> _add<Message>(
    StreamSink<Message> messageSink, {
    required OnMessage<Message> onInitialMessage,
  }) {
    final key = _makeContra<Message>();
    _messageSinkKeys.add(key);
    _messageSinks[key] = messageSink;

    _log('Added sink of type $Message');

    final bufferedMessage = _messageBuffers.values
        .whereType<_BufferedMessage<Message>>()
        .firstOrNull;

    if (bufferedMessage != null) {
      onInitialMessage(bufferedMessage.message);

      if (bufferedMessage.oneOff) {
        _messageBuffers.remove(Message);
      }
    }

    return key;
  }

  /// Removes messageSink with [key] from [MessageSinkRegister]'s [_messageSinks]
  void _remove(_Contra<Never> key) {
    final sink = _messageSinks.remove(key)!;
    _messageSinkKeys.remove(key);
    sink.close();
    _log('Removed sink ${sink.runtimeType}');
  }

  /// Returns all sinks in [MessageSinkRegister]'s [_messageSinks] of type
  /// [Message]
  @visibleForTesting
  List<StreamSink<dynamic>> getSinksOfType<Message>() {
    final messageSinks = _messageSinkKeys
        .whereType<_Contra<Message>>()
        .map((key) => _messageSinks[key]!)
        .toList();

    if (messageSinks.isEmpty) {
      _log('Found no sinks of type $Message');
    }

    return messageSinks.toList();
  }

  /// Adds [message] to all sinks in [MessageSinkRegister]'s [_messageSinks]
  /// of type [Message] and updates [_messageBuffers].
  void sendToSinksOfType<Message>(Message message, {bool oneOff = false}) {
    final sinks = getSinksOfType<Message>()
      ..forEach(
        (sink) => sink.add(message),
      );

    if (sinks.isNotEmpty && oneOff) {
      return;
    }

    _messageBuffers[Message] = _BufferedMessage<Message>(
      message: message,
      oneOff: oneOff,
    );
  }

  @visibleForTesting
  void clear() {
    _messageBuffers.clear();
    _messageSinkKeys.clear();
    for (final sink in _messageSinks.values) {
      sink.close();
    }
    _messageSinks.clear();
  }
}

class _BufferedMessage<Message> {
  _BufferedMessage({
    required this.message,
    required this.oneOff,
  });

  final Message message;
  final bool oneOff;
}
