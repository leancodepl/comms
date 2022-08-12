import 'package:comms/comms.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
