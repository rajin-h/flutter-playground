import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_view_test/button.dart';
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
              height: 40,
            ),
            DefaultButton(
              text: 'Open Tweet',
              onTap: toggleWebView,
              color: const Color(0xFF42A5F5),
            ),
            const Expanded(
              child: SizedBox(
                height: 50,
              ),
            ),

            //////////////////////////////////
            //                              //
            // BELOW IS A CUSTOM WEB WIDGET //
            //                              //
            //////////////////////////////////
            Visibility(
              visible: _isVisible,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(66, 165, 245, 1),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    border: Border.all(
                        color: const Color.fromRGBO(66, 165, 245, 1),
                        style: BorderStyle.solid,
                        width: 5,
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
                            height: 60,
                            child: Row(
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      SizedBox(
                                        child: Text(
                                          'Random Title',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          '@Random_User',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ]),
                                const Expanded(
                                  child: SizedBox(
                                    height: 40,
                                  ),
                                ),
                                DefaultButton(
                                  text: 'Close',
                                  onTap: toggleWebView,
                                  color:
                                      const Color.fromARGB(255, 78, 137, 204),
                                ),
                              ],
                            )),
                      ),
                      Container(
                        color: const Color.fromRGBO(66, 165, 245, 1),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
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
                                navigationDelegate:
                                    (NavigationRequest request) {
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
                                onPageFinished: (String url) {},
                                gestureNavigationEnabled: true,
                                backgroundColor: Colors.blue[400],
                              ),
                            ),
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
