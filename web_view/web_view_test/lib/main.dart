import 'dart:async';

import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:web_view_test/button.dart';
import 'package:web_view_test/customwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Cool Web View Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isVisible = true;
  int _progressVal = 0;

  Offset _offset = Offset.zero;

  void toggleWebView() {
    if (_isVisible) {
      _slideDown();
    } else {
      _slideUp();
    }
  }

  void _slideUp() {
    setState(() => _offset -= const Offset(0, 1));
  }

  void _slideDown() {
    setState(() => _offset += const Offset(0, 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            DefaultButton(
              invert: false,
              text: '${_isVisible ? 'Hide' : 'Show'} Content',
              onTap: toggleWebView,
              color: const Color(0xFF42A5F5),
            ),
            const Expanded(
              child: SizedBox(
                height: 50,
              ),
            ),
            const CustomWebView(
                webviewTitle: 'Cool Title',
                username: '@cool_user',
                date: 'Apr 15, 2023',
                webviewColor: Color.fromARGB(255, 99, 99, 255),
                initialURL:
                    'https://twitter.com/Tesla/status/1592725355328311300')
          ],
        ),
      ),
    );
  }
}
