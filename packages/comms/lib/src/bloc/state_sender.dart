part of '../../comms.dart';

/// Sends emitted [State]s to all [Listener]s of type [State].
mixin StateSender<State> on BlocBase<State> {
  @override
  @mustCallSuper
  void onChange(Change<State> change) {
    super.onChange(change);
    getSend<State>()(change.nextState);
  }
}
