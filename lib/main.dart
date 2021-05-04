import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/CounterBloc.dart';
import 'package:flutter_app/bloc/UserBloc.dart';
import 'package:flutter_app/model/CustomArguments.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'Home.dart';
import 'model/CounterModel.dart';

void main() {
  runApp(
      // ChangeNotifierProvider(
      //   create: (context) => ModelClass(),
      //   child: MyApp(),
      // ));

      //Or can be used as
      MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CounterModel()),
      BlocProvider<CounterBloc>(create: (context) => CounterBloc()),
      BlocProvider<UserBloc>(create: (context) => UserBloc())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.lime,
          accentColor: Colors.teal,
          fontFamily: "Montserrat",
          textTheme: TextTheme(
              button: TextStyle(color: Colors.teal, fontSize: 16),
              bodyText1: TextStyle(color: Colors.indigo, fontSize: 16),
              bodyText2: TextStyle(color: Colors.lightBlue, fontSize: 15)),
       appBarTheme: AppBarTheme(
         color: Colors.indigo
       )
      ),
      home: LoginDemo(),
      routes: {
        ExtractArgumentsScreen.routeName: (context) => ExtractArgumentsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == PassArgumentsScreen.routeName) {
          final CustomArguments args = settings.arguments as CustomArguments;
          return MaterialPageRoute(
            builder: (context) {
              return PassArgumentsScreen(
                title: args.title,
                message: args.message,
              );
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    padding: EdgeInsets.all(15),
                    child: FlutterLogo(size: 90) //Image.asset('asset/images/ic_launcher.png')
                    ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter valid Username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => HomePage(title: 'Home Page')));
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Text('Create Account')
          ],
        ),
      ),
    );
  }
}
