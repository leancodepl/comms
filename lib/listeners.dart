part of 'comms.dart';

typedef OnMessage<Message> = void Function(Message message);

mixin Listener<Message> {
  late final StreamController<Message> _messageStreamController;

  late final StreamSubscription<Message> _messageSubscription;

  String? _id;

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

  @protected
  void onMessage(Message message);

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

void useListener<Message>(
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
      messageSubscription.cancel();
    },
    keys ?? [],
  );
}
