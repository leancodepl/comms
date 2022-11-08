part of '../comms.dart';

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

  final _logger = Logger('MessageSinkRegister');

  /// Used to create unique id for each message sink added with [_add].
  final _uuid = const Uuid();

  /// All message sinks and their id's added with [_add].
  final _messageSinks = <String, StreamSink>{};

  /// All last messages sent with each type
  final _messageBuffers = <Type, dynamic>{};

  /// Adds a [messageSink] to [MessageSinkRegister]'s [_messageSinks] with
  /// unique id from [_uuid]
  String _add<Message>(
    StreamSink<Message> messageSink, {
    OnMessage<Message>? onInitialMessage,
  }) {
    final id = _uuid.v1();
    _messageSinks[id] = messageSink;
    _logger.info('Added sink ${messageSink.runtimeType}');

    final bufferedMessage = _messageBuffers[Message] as Message?;
    if (bufferedMessage != null) {
      onInitialMessage?.call(bufferedMessage);
    }

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
    final sinks = _messageSinks.values.whereType<StreamSink<Message>>();
    if (sinks.isEmpty) {
      _logger.info('Found no sinks of type $Message');
    }

    return sinks.toList();
  }

  /// Adds [message] to all sinks in [MessageSinkRegister]'s [_messageSinks]
  /// of type [Message] and updates [_messageBuffers].
  void sendToSinksOfType<Message>(Message message) {
    getSinksOfType<Message>().forEach(
      (sink) => sink.add(message),
    );

    _messageBuffers[Message] = message;
  }
}
