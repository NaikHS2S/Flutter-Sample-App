import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/counter_bloc.dart';
import 'package:flutter_app/bloc/user_bloc.dart';
import 'package:flutter_app/db/sql_lite_helper.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/model/custom_arguments.dart';
import 'package:flutter_app/model/dog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'model/counter_model.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  getDatabase();

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

Future<Database> getDatabase() async {
 if(SQLiteHelper.dataBase == null) {
   SQLiteHelper.dataBase = openDatabase(
     join(await getDatabasesPath(), 'doggie_database.db'),
     onCreate: (db, version) {
       return db.execute(
         "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",);
     },
     version: 1,
   );
 }
 return SQLiteHelper.dataBase;
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

                  doDBOperation();

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

void doDBOperation() async {
  var sqLiteHelper = SQLiteHelper();

  var fido = Dog(id: 0, name: 'Fido', age: 35,);
  await sqLiteHelper.insertDog(fido);
  print(await sqLiteHelper.dogs());
  fido = Dog(id: fido.id, name: fido.name, age: fido.age + 7,);
  await sqLiteHelper.updateDog(fido);

  print(await sqLiteHelper.dogs());
  await sqLiteHelper.deleteDog(fido.id);
  print(await sqLiteHelper.dogs());

}
