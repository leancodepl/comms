import 'package:bloc/bloc.dart';
import 'package:comms/comms.dart';
import 'package:flutter_comms/flutter_comms.dart';
import 'package:meta/meta.dart' show mustCallSuper;

/// Sends emitted [State]s to all [Listener]s of type [State].
mixin StateSender<State> on BlocBase<State> {
  @override
  @mustCallSuper
  void emit(State state) {
    super.emit(state);
    getSend<State>()(state);
  }
}
