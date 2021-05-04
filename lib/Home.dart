import 'package:flutter/material.dart';
import 'package:flutter_app/api/Services.dart';
import 'package:flutter_app/bloc/CounterBloc.dart';
import 'package:flutter_app/events/CounterEvent.dart';
import 'package:flutter_app/model/CustomArguments.dart';
import 'package:flutter_app/model/Joke.dart';
import 'package:flutter_app/state/CounterState.dart';
import 'package:flutter_app/bloc/UserBloc.dart';
import 'package:flutter_app/events/UserInfoEvents.dart';
import 'package:flutter_app/state/UserState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/animation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/model/CounterModel.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Future<List<Joke>> futureJokes;
  Animation<double> animation;
  AnimationController controller;
  String welcomeText = 'Welcome';
  bool selected = false;

  @override
  void initState() {
    super.initState();
    futureJokes = UserServices().fetchJoke();
    _loadAlbums();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: 220).animate(controller)
      ..addListener(() {
        // setState(() {
        //   welcomeText = 'Welcome';
        // });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          //controller.forward();
        }
      })
      ..addStatusListener((state) => print('$state'));

    controller.forward();
  }

  void _incrementCounter() {
    Provider.of<CounterModel>(context, listen: false).increment();
  }

  _loadAlbums() async {
    BlocProvider.of<UserBloc>(context).add(UserInfoEvents.fetchUser);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snack bar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This is a Snack bar.')));
            },
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            selected = !selected;
          });
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  BlocBuilder<UserBloc, UserState>(
                      builder: (BuildContext context, UserState state) {
                        if (state is UserListError) {
                          return Text(state.error.message, style: TextStyle(color: Colors.amber, fontSize: 18));
                        }
                        if (state is Loaded) {
                          return Text(state.userInfoList[0].title, style: TextStyle(color: Colors.amber, fontSize: 18));
                        }
                        return CircularProgressIndicator();
                      }),

                  AnimatedContainer(
                    width: double.infinity,
                    height: selected ? 100.0 : 200.0,
                    color: selected ? Colors.red : Colors.blue,
                    alignment: selected ? Alignment.center : AlignmentDirectional.centerStart,
                    duration: const Duration(seconds: 2),
                    curve: Curves.fastOutSlowIn,
                    child: const FlutterLogo(size: 75),
                  ),
                  AnimatedBuilder(
                    animation: animation,
                    child: Text('$welcomeText'),
                    builder: (context, child) => Container(
                      height: animation.value / 3, width: double.infinity,
                      child: SizedBox(child: FittedBox(child: Text('$welcomeText', style: TextStyle(color: Colors.blue, fontSize: 22),)),
                      ),
                    ),
                  ),
                  Consumer<CounterModel>(
                    builder: (context, modelClass, child) => Stack(
                      children: [
                        if (child != null) child,
                        Text(getTextToDisplay(context), style: Theme.of(context).textTheme.bodyText1,),
                      ],
                    ),
                    //child: SomeExpensiveWidget(),
                  ),
                  SizedBox(width: double.infinity, child: SelectionButton()),
                  SizedBox(width: double.infinity, child: ElevatedButton(
                        onPressed: () {_ModalBottomSheetDemo()._showModalBottomSheet(context);},
                        child: Text("BottomSheetButtonText"),
                      )),
                  Text('Jokes: ', style: TextStyle(color: Colors.blue, fontSize: 25),),
                  FutureBuilder<List<Joke>>(
                    future: futureJokes,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final lItems = snapshot.data;
                        return _myListView(context, lItems);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return CircularProgressIndicator();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  String getTextToDisplay(BuildContext context) {
    final counter = Provider.of<CounterModel>(context, listen: false).counter;
    switch (counter) {
      case 0:
        return 'FloatingActionButton is not clicked yet.';
      case 1:
        return 'FloatingActionButton is clicked once.';
      default:
        return 'FloatingActionButton is clicked $counter times.';
    }
  }
}

Expanded _myListView(BuildContext context, List<Joke> jokes) {
  return Expanded(
      child: Container(
    width: double.infinity,
    height: 200,
    child: ListView.builder(
      itemBuilder: (context, position) {
        return GestureDetector(
          child: Card(
              child: Text(
                  "Q: ${jokes[position].setup} \n A: ${jokes[position].punchline}",
                  style: TextStyle(color: Colors.black, fontSize: 22))),
          onTap: () {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                  SnackBar(content: Text("Item ${position + 1} clicked")));
          },
        );
      },
      itemCount: jokes.length,
    ),
  ));
}

class SelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
      child: Text('Navigate to next route'),
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      ExtractArgumentsScreen.routeName,
      arguments: CustomArguments(
        'Accept Arguments Screen',
        'This message is extracted in the onGenerateRoute function.',
      ),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$result")));
  }
}

class ExtractArgumentsScreen extends StatelessWidget {
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    final CustomArguments args = ModalRoute.of(context).settings.arguments as CustomArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route : ${args.title}"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class PassArgumentsScreen extends StatelessWidget {
  static const routeName = '/passArguments';

  final String title;
  final String message;

  const PassArgumentsScreen({key, @required this.title, @required this.message,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: const EdgeInsets.all(8.0), child: Text('Counter'),),
                BlocBuilder<CounterBloc, CounterState>(
                  builder: (context, CounterState state) {
                    return Center(
                      child: Text(
                        state.counter.toString(),
                        style: TextStyle(fontSize: 24.0),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<CounterBloc>(context).add(Increment());
                    },
                    child: Text('Increment Counter'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<CounterBloc>(context).add(Decrement());
                    },
                    child: Text('Decrement Counter'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, 'Yep!');
                    },
                    child: Text('Yep!'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, 'Nope.');
                    },
                    child: Text('Nope.'),
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: () {
          Navigator.pop(context, 'Back Press');
        });
  }
}

class _BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Container(
            height: 70,
            child: Center(
              child: Text(
                "BottomSheetHeader",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: ListView.builder(
              itemCount: 21,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Item ${index + 1}"),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text("Item ${index + 1} clicked")));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ModalBottomSheetDemo extends StatelessWidget {
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return _BottomSheetContent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _showModalBottomSheet(context);
        },
        child: Text("Show Bottom Sheet"),
      ),
    );
  }
}



