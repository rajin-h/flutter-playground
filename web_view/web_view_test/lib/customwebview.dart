import 'dart:async';
import 'dart:ui';

import 'package:favicon/favicon.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'button.dart';

class CustomWebView extends StatefulWidget {
  const CustomWebView(
      {super.key,
      required this.webviewTitle,
      required this.username,
      required this.date,
      required this.webviewColor,
      required this.initialURL});

  final String webviewTitle;
  final String username;
  final String date;
  final Color webviewColor;
  final String initialURL;

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
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

  @override
  Widget build(BuildContext context) {
    return
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
              color: widget.webviewColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              border: Border.all(
                  color: widget.webviewColor,
                  style: BorderStyle.none,
                  width: 5,
                  strokeAlign: StrokeAlign.outside)),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            child: Column(
              children: [
                GestureDetector(
                  onDoubleTap: toggleWebView,
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      color: widget.webviewColor,
                      height: 70,
                      child: Row(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    widget.webviewTitle,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                Row(children: [
                                  SizedBox(
                                    child: Text(
                                      widget.username,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                    child: Text(
                                      '|',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text(
                                      widget.date,
                                      style: const TextStyle(
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
                            color: const Color.fromARGB(255, 255, 255, 255),
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
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          const SizedBox(
                            width: 10,
                            height: 40,
                          ),
                          DefaultButton(
                            invert: true,
                            text: 'Close',
                            onTap: _slideDown,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ],
                      )),
                ),
                Container(
                  color: widget.webviewColor,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        height: 600,
                        color: widget.webviewColor,
                        child: Stack(children: [
                          WebView(
                            allowsInlineMediaPlayback: true,
                            zoomEnabled: true,
                            initialUrl: widget.initialURL,
                            javascriptMode: JavascriptMode.unrestricted,
                            onWebViewCreated: (controller) {
                              _controller.complete(controller);
                            },
                            onProgress: (int progress) {
                              setState(() {
                                _progressVal = progress;
                              });
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
                            onPageStarted: (String url) async {
                              print('Page started loading: $url');
                              var iconUrl = await FaviconFinder.getBest(url);
                              print('favicon: ' + iconUrl.toString());
                            },
                            onPageFinished: (String url) {},
                            gestureNavigationEnabled: true,
                            backgroundColor: widget.webviewColor,
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
    );
  }
}
