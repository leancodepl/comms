import 'package:bloc/bloc.dart';
import 'package:comms/comms.dart';
import 'package:meta/meta.dart' show mustCallSuper;

/// Handles [Listener]'s [listen] and [close].
///
/// If your bloc needs to extend another class use [Listener] mixin.
///
/// Type argument [Message] marks what type of messages can be received.
///
/// See also:
///
///  * ListenerCubit, a class extending [Cubit] which handles calling [listen]
/// and [cancel] automatically.
///  * useMessageListener, a hook that provides [Listener]'s functionality
/// which handles calling [listen] and [cancel] automatically.
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
