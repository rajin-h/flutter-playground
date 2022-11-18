import 'dart:async';

import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'button.dart';

class CustomWebView extends StatefulWidget {
  final Offset offset;
  final bool isVisible;
  final Completer<WebViewController> controller;
  final double progressVal;
  final Function(bool isVisible) setVisible;
  final Function(double progressVal) updateProgressVal;
  final Function() slideUp;
  final Function() slideDown;
  final Function(WebViewController controller) navigatePrev;
  final Function(WebViewController controller) navigateNext;

  final String initialURL;
  final String webviewTitle;
  final String webviewSubtitle;
  final String webviewDate;

  const CustomWebView({
    super.key,
    required this.offset,
    required this.isVisible,
    required this.controller,
    required this.progressVal,
    required this.setVisible,
    required this.updateProgressVal,
    required this.slideUp,
    required this.slideDown,
    required this.navigatePrev,
    required this.navigateNext,
    required this.webviewTitle,
    required this.webviewSubtitle,
    required this.webviewDate,
    required this.initialURL,
  });

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  late Future<PaletteGenerator> paletteGenerator;

  @override
  void initState() {
    super.initState();
    paletteGenerator = updatePalleteGenerator(widget.initialURL);
  }

  Future<PaletteGenerator> updatePalleteGenerator(String url) async {
    var iconUrl = await FaviconFinder.getBest(url);
    String favURL = iconUrl!.url;
    return PaletteGenerator.fromImageProvider(NetworkImage(favURL),
        size: const Size(250.0, 250.0), maximumColorCount: 3);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: paletteGenerator,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AnimatedSlide(
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 300),
            offset: widget.offset,
            onEnd: () {
              if (widget.isVisible) {
                setState(() {
                  widget.setVisible(false);
                });
              } else {
                setState(() {
                  widget.setVisible(true);
                });
              }
            },
            child: Visibility(
              maintainState: true,
              visible: true,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    color: snapshot.data?.colors.first,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    border: Border.all(
                        color: snapshot.data?.colors.first ?? Colors.black,
                        style: BorderStyle.none,
                        width: 5,
                        strokeAlign: StrokeAlign.outside)),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18)),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(15),
                          color: snapshot.data?.colors.first,
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
                                          widget.webviewSubtitle,
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
                                          widget.webviewDate,
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
                                  widget.controller.future.then(
                                      (value) => widget.navigatePrev(value))
                                },
                                color:
                                    snapshot.data?.colors.first ?? Colors.black,
                              ),
                              const SizedBox(
                                width: 10,
                                height: 40,
                              ),
                              DefaultButton(
                                invert: true,
                                text: 'Next',
                                onTap: () => {
                                  widget.controller.future.then(
                                      (value) => widget.navigateNext(value))
                                },
                                color:
                                    snapshot.data?.colors.first ?? Colors.black,
                              ),
                              const SizedBox(
                                width: 10,
                                height: 40,
                              ),
                              DefaultButton(
                                invert: true,
                                text: 'Close',
                                onTap: widget.slideDown,
                                color:
                                    snapshot.data?.colors.first ?? Colors.black,
                              ),
                            ],
                          )),
                      Container(
                        color: snapshot.data?.colors.first,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              height: 600,
                              color: snapshot.data?.colors.first,
                              child: Stack(children: [
                                WebView(
                                  allowsInlineMediaPlayback: true,
                                  zoomEnabled: true,
                                  initialUrl: widget.initialURL,
                                  javascriptMode: JavascriptMode.unrestricted,
                                  onWebViewCreated: (controller) {
                                    widget.controller.complete(controller);
                                  },
                                  onProgress: (int progress) {
                                    setState(() {
                                      widget.updateProgressVal(progress / 100);
                                    });
                                  },
                                  onPageStarted: (String url) async {},
                                  onPageFinished: (String url) {},
                                  gestureNavigationEnabled: true,
                                  backgroundColor:
                                      snapshot.data?.colors.first ??
                                          Colors.black,
                                ),
                                Visibility(
                                  visible: widget.progressVal != 1.0,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        color: snapshot.data?.colors.first ??
                                            Colors.black,
                                        value: widget.progressVal),
                                  ),
                                )
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
        } else {
          return const SizedBox(
              height: 600, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
