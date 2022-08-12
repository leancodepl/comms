part of 'comms.dart';

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
///  * [ListenerCubit], a class extending [Cubit] which handles calling [listen]
/// and [cancel] automatically.
///  * [ListenerBloc], a class extending [Bloc] which handles calling [listen]
/// and [cancel] automatically.
///  * [useMessageListener], hook that can be used in the build method of [HookWidget]
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

/// Handles [Listener]'s [listen] and [close]. Use instead of [Cubit].
///
/// Type argument [Message] marks what type of messages can be received.
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

/// Handles [Listener]'s [listen] and [close].
///
/// Use instead of [Bloc], if your Bloc already extends different
///
/// Type argument [Message] marks what type of messages can be received.
abstract class ListenerBloc<Event, State, Message> extends Bloc<Event, State>
    with Listener<Message> {
  ListenerBloc(State initialState) : super(initialState) {
    super.listen();
  }

  @override
  @mustCallSuper
  Future<void> close() {
    super.cancel();
    return super.close();
  }
}

/// Calls [onMessage] everytime a message of type [Message] is received.
///
/// Works similarly to [Listener] but handles starting receiving messages and
/// cleaning up itself.
void useMessageListener<Message>(
  OnMessage<Message> onMessage, [
  List<Object?>? keys,
]) {
  final messageStreamController = useStreamController<Message>(keys: keys);

  final messageSubscription = useMemoized(
    () => messageStreamController.stream.listen(onMessage),
    keys ?? [],
  );

  final id = MessageSinkRegister()._add(messageStreamController.sink);

  useEffect(
    () => () {
      MessageSinkRegister()._remove(id);
      messageStreamController.close();
      messageSubscription.cancel();
    },
    keys ?? [],
  );
}
