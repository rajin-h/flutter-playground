import 'dart:async';

import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:web_view_test/widgets/button.dart';
import 'package:web_view_test/widgets/customwebview.dart';
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
  // internal states
  bool _isVisible = true;
  double _progressVal = 0;
  Offset _offset = Offset.zero;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  // toggles the web view by sliding up or down
  void toggleWebView() {
    if (_isVisible) {
      _slideDown();
    } else {
      _slideUp();
    }
  }

  // updates offset to slide up
  void _slideUp() {
    setState(() => _offset -= const Offset(0, 1));
  }

  // updates offset to slide down
  void _slideDown() {
    setState(() => _offset += const Offset(0, 1));
  }

  // pop navigation on browser
  void _navigatePrev(WebViewController controller) async {
    if (await controller.canGoBack()) {
      await controller.goBack();
    } else {
      return;
    }
  }

  // push navigation on browser
  void _navigateNext(WebViewController controller) async {
    if (await controller.canGoForward()) {
      await controller.goForward();
    } else {
      return;
    }
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
            CustomWebView(
                initialURL:
                    'https://stackoverflow.com/questions/62061728/how-to-resolve-future-in-dart',
                webviewTitle: "Cool Title",
                webviewSubtitle: "Cool Subtitle",
                webviewDate: DateTime.now().toUtc().toString().substring(0, 11),
                offset: _offset,
                isVisible: _isVisible,
                controller: _controller,
                progressVal: _progressVal,
                setVisible: ((isVisible) =>
                    setState(() => _isVisible = isVisible)),
                updateProgressVal: ((progressVal) =>
                    setState(() => _progressVal = progressVal)),
                slideUp: _slideUp,
                slideDown: _slideDown,
                navigatePrev: _navigatePrev,
                navigateNext: _navigateNext)
          ],
        ),
      ),
    );
  }
}
