import 'package:comms/comms.dart' show Listener;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart' show mustCallSuper;

/// Handles [Listener]'s [listen] and [close].
///
/// Use instead of [Cubit].
///
/// If your cubit needs to extend another class use [Listener] mixin.
///
/// Type argument [Message] marks what type of messages can be received.
///
/// See also:
///
///  * [ListenerBloc], a class extending [Bloc] which handles calling [listen]
/// and [cancel] automatically.
///  * [useMessageListener], a hook that provides [Listener]'s functionality 
/// which handles calling [listen] and [cancel] automatically.
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
