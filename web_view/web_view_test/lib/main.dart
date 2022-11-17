import 'dart:async';

import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
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

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

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

  void _navigatePrev(WebViewController controller) async {
    if (await controller.canGoBack()) {
      await controller.goBack();
    } else {
      return;
    }
  }

  void _navigateNext(WebViewController controller) async {
    if (await controller.canGoForward()) {
      await controller.goForward();
    } else {
      return;
    }
  }

  void _browserClose() {}

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

            //////////////////////////////////
            //                              //
            // BELOW IS A CUSTOM WEB WIDGET //
            //                              //
            //////////////////////////////////
            AnimatedSlide(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 300),
              offset: _offset,
              onEnd: () {
                if (_isVisible) {
                  setState(() {
                    _isVisible = false;
                  });
                } else {
                  setState(() {
                    _isVisible = true;
                  });
                }
              },
              child: Visibility(
                maintainState: true,
                visible: true,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(66, 165, 245, 1),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      border: Border.all(
                          color: const Color.fromRGBO(66, 165, 245, 1),
                          style: BorderStyle.none,
                          width: 5,
                          strokeAlign: StrokeAlign.outside)),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18)),
                    child: Column(
                      children: [
                        GestureDetector(
                          onDoubleTap: toggleWebView,
                          child: Container(
                              padding: const EdgeInsets.all(15),
                              color: const Color.fromRGBO(66, 165, 245, 1),
                              height: 70,
                              child: Row(
                                children: [
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          child: Text(
                                            'Random Title',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                        Row(children: const [
                                          SizedBox(
                                            child: Text(
                                              '@Random_User',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                            child: Text(
                                              '|',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(
                                            child: Text(
                                              'Apr 15, 2022',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ]),
                                      ]),
                                  const Expanded(
                                    child: SizedBox(
                                      height: 40,
                                    ),
                                  ),
                                  DefaultButton(
                                    invert: true,
                                    text: 'Prev',
                                    onTap: () => {
                                      _controller.future
                                          .then((value) => _navigatePrev(value))
                                    },
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                    height: 40,
                                  ),
                                  DefaultButton(
                                    invert: true,
                                    text: 'Next',
                                    onTap: () => {
                                      _controller.future
                                          .then((value) => _navigateNext(value))
                                    },
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                    height: 40,
                                  ),
                                  DefaultButton(
                                    invert: true,
                                    text: 'Close',
                                    onTap: _slideDown,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
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
                                child: Stack(children: [
                                  WebView(
                                    allowsInlineMediaPlayback: true,
                                    zoomEnabled: true,
                                    initialUrl:
                                        'https://twitter.com/Tesla/status/1590018135977259009',
                                    javascriptMode: JavascriptMode.unrestricted,
                                    onWebViewCreated: (controller) {
                                      _controller.complete(controller);
                                    },
                                    onProgress: (int progress) {
                                      setState(() {
                                        _progressVal = progress;
                                      });
                                    },
                                    navigationDelegate:
                                        (NavigationRequest request) {
                                      if (request.url.startsWith(
                                          'https://www.youtube.com/')) {
                                        print(
                                            'blocking navigation to $request}');
                                        return NavigationDecision.prevent;
                                      }
                                      print('allowing navigation to $request');
                                      return NavigationDecision.navigate;
                                    },
                                    onPageStarted: (String url) async {
                                      print('Page started loading: $url');
                                      var iconUrl =
                                          await FaviconFinder.getBest(url);
                                      print('favicon: ' + iconUrl.toString());
                                    },
                                    onPageFinished: (String url) {},
                                    gestureNavigationEnabled: true,
                                    backgroundColor: Colors.blue[400],
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
