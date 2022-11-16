import 'dart:async';

import 'package:flutter/material.dart';
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
      home: const MyHomePage(title: 'Cool Webview Demo'),
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
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  void toggleWebView() {
    setState(() {
      _isVisible = !_isVisible;
    });
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
              height: 60,
            ),
            GestureDetector(
              onTap: toggleWebView,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.blue[400],
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Text(
                  'Toggle Content',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(
                height: 10,
              ),
            ),
            Visibility(
              visible: _isVisible,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    border: Border.all(
                        color: const Color.fromRGBO(66, 165, 245, 1),
                        style: BorderStyle.solid,
                        width: 3,
                        strokeAlign: StrokeAlign.outside)),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Column(
                    children: [
                      GestureDetector(
                        onDoubleTap: toggleWebView,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            color: const Color.fromRGBO(66, 165, 245, 1),
                            height: 42,
                            child: const SizedBox(
                              width: 500,
                              child: Text(
                                'Random Title',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: 600,
                          color: const Color.fromRGBO(66, 165, 245, 1),
                          child: WebView(
                            initialUrl:
                                'https://twitter.com/Tesla/status/1582901412312207361',
                            javascriptMode: JavascriptMode.unrestricted,
                            onWebViewCreated: (controller) {
                              _controller.complete(controller);
                            },
                            onProgress: (int progress) {
                              print(
                                  'WebView is loading (progress : $progress%)');
                            },
                            navigationDelegate: (NavigationRequest request) {
                              if (request.url
                                  .startsWith('https://www.youtube.com/')) {
                                print('blocking navigation to $request}');
                                return NavigationDecision.prevent;
                              }
                              print('allowing navigation to $request');
                              return NavigationDecision.navigate;
                            },
                            onPageStarted: (String url) {
                              print('Page started loading: $url');
                            },
                            onPageFinished: (String url) {
                              print('Page finished loading: $url');
                            },
                            gestureNavigationEnabled: true,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
