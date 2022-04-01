import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Create storage
  final storage = const FlutterSecureStorage(
    // allows fetching secure values while the app is backgrounded
    iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock),
    // use EncryptedSharedPreferences on Android
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  final String SECURE_KEY = "SECURE_TEXT_KEY";

  TextEditingController _controller = TextEditingController();
  String _loadedSecureText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secure Storage"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: ElevatedButton(
                    child: Text("LOAD", style: TextStyle(fontSize: 18),),
                    onPressed: loadStorage,
                  )),
                  SizedBox(width: 20.0,),
                  Expanded(child: ElevatedButton(
                    child: Text("SAVE", style: TextStyle(fontSize: 18),),
                    onPressed: saveStorage,
                  )),
                ],
              ),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Enter Secure Text",
                ),
              ),
              SizedBox(height: 20.0,),
              Text("Saved Secure Text: ${_loadedSecureText==""? "-" : _loadedSecureText}",
                style: TextStyle(fontSize: 18),),
            ],
          ),
        ),
      ),
    );
  }

  void loadStorage() async {
    /// Read value
    String value = await storage.read(key: SECURE_KEY) ?? "";
    setState(() {
      _loadedSecureText = value;
    });

    /// Read all values
    Map<String, String> allValues = await storage.readAll();
    /*
    {
      "KEY1": value1
      "KEY2": value2
    }
     */
    String secureText = allValues['KEY1'] ?? "";
  }

  void saveStorage() async {
    setState(() {
      _loadedSecureText = _controller.text;
    });

    /// Write value
    await storage.write(key: SECURE_KEY, value: _loadedSecureText);
  }

  void deleteStorage() async {
    /// Delete value
    await storage.delete(key: SECURE_KEY);

    /// Delete all
    await storage.deleteAll();
  }

}

