import 'package:flutter_app/events/counter_events.dart';
import 'package:flutter_app/state/counter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBloc extends Bloc<CounterEvent,CounterState>{
  CounterBloc():super(CounterState(counter: 1));
  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async*{
    if(event is Increment){
      yield CounterState(counter: state.counter + 1);
    }
    else if(event is Decrement){
      if(state.counter > 0) {
        yield CounterState(counter: state.counter - 1);
      }
    }
  }
}



