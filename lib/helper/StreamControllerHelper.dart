import 'dart:async';
import 'package:flutter_app/events/CounterEvent.dart';
import 'package:flutter_app/state/CounterState.dart';

class StreamControllerHelper{

  CounterState counterState = new CounterState(counter:0);
  final _counterStateController = StreamController<CounterState>();

  StreamSink<CounterState> get _inCounter => _counterStateController.sink;
  Stream<CounterState> get counterStream => _counterStateController.stream;      //output

  final _counterEventController = StreamController<CounterEvent>();
  StreamSink get counterEventSink => _counterEventController.sink;  //input

  StreamControllerHelper(){
    _counterEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event){
    if(event is Increment){
      counterState.counter++;
    }
    else if(event is Decrement){
      counterState.counter--;
    }
    _inCounter.add(counterState);
  }

  void dispose(){
    _counterStateController.close();
    _counterEventController.close();
  }
}