import 'package:flutter/material.dart';

void main() {
  runApp(DCFCalculatorApp());
}

class DCFCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DCF Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DCFCalculatorScreen(),
    );
  }
}

class DCFCalculatorScreen extends StatefulWidget {
  @override
  _DCFCalculatorScreenState createState() => _DCFCalculatorScreenState();
}

class _DCFCalculatorScreenState extends State<DCFCalculatorScreen> {
  // Add your state variables and logic here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DCF Calculator'),
      ),
      body: Center(
        // Add your UI components here
        child: Text(
          'Welcome to DCF Calculator!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
```

 