part of 'comms.dart';

typedef Send<Message> = void Function(Message message);

mixin Sender<Message> {
  @protected
  @nonVirtual
  void send(Message message) {
    MessageSinkRegister().getSinksOfType<Message>().forEach(
          (sink) => sink.add(message),
        );
  }
}

Send<Message> getSend<Message>() {
  return (message) {
    MessageSinkRegister().getSinksOfType<Message>().forEach(
          (sink) => sink.add(message),
        );
  };
}
