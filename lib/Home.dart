import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _counter = 0;
  Future<List<Joke>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the Add button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            SelectionButton(),
            ElevatedButton(
              onPressed: () {
                _ModalBottomSheetDemo()._showModalBottomSheet(context);
              },
              child: Text("BottomSheetButtonText"),
            ),
            FutureBuilder<List<Joke>>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data[0].setup);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            )
          ],
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
      PassArgumentsScreen.routeName,
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
    final CustomArguments args =
        ModalRoute.of(context).settings.arguments as CustomArguments;

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

  const PassArgumentsScreen({
    key,
    @required this.title,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
    );
  }
}

class CustomArguments {
  final String title;
  final String message;

  CustomArguments(this.title, this.message);
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

Future<List<Joke>> fetchAlbum() async {
  final response =
      await http.get(Uri.https('official-joke-api.appspot.com', 'jokes/ten'));

  if (response.statusCode == 200) {
    Iterable iterable = jsonDecode(response.body);
    return List.from(iterable.map((data) => Joke.fromJson(data)));
  } else {
    throw Exception('Failed to load album');
  }
}

class Joke {
  final int id;
  final String type;
  final String setup;
  final String punchline;

  Joke(
      {@required this.id,
      @required this.type,
      @required this.setup,
      @required this.punchline});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'],
      type: json['type'],
      setup: json['setup'],
      punchline: json['punchline'],
    );
  }
}