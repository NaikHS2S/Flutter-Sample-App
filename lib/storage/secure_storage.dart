import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{

void setValue(String key, String value) async{
  final storage = new FlutterSecureStorage();
  await storage.write(key: key, value:value);
}

void deleteValue(String key) async{
  final storage = new FlutterSecureStorage();
  await storage.delete(key: key);
}

void deleteAllValues() async{
  final storage = new FlutterSecureStorage();
  await storage.deleteAll();
}

Future<String> getValue(String key) async{
  final storage = new FlutterSecureStorage();
  return await storage.read(key: key) ?? "";
}

Future<Map<String, String>> getAllValues() async{
  final storage = new FlutterSecureStorage();
  return await storage.readAll() ?? "";
}

}