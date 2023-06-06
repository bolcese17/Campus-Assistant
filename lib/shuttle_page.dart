import 'package:campus_assistant/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'colors.dart';

class ShuttlePage extends StatefulWidget {
  const ShuttlePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShuttlePageState();
}

class _ShuttlePageState extends State<ShuttlePage> {
  late WebViewController controller = WebViewController();

  @override
  void initState() {
    if (!kIsWeb) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.google.com/%27')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(
            'https://my.hofstra.edu/hofutils/applications/bus-map/map/schedules.jsp'));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Scaffold(
        backgroundColor: backgroundGray,
        drawer: drawerWidget(context),
        appBar: appBarWidget(context, Icons.bus_alert_sharp),
        body: WebViewWidget(controller: controller),
        floatingActionButton: backButtonWidget(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      );
    } else {
      return Scaffold(
        backgroundColor: backgroundGray,
        drawer: drawerWidget(context),
        appBar: appBarWidget(context, Icons.bus_alert_sharp),
        body: Center(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                color: Colors.blueGrey,
                child: RichText(
                  text: TextSpan(
                      text: 'Open Shuttle Schedule in new tab',
                      style: const TextStyle(color: Colors.black),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Uri shuttleURL = Uri.parse(
                              'https://my.hofstra.edu/hofutils/applications/bus-map/map/schedules.jsp');
                          launchUrl(shuttleURL);
                        }),
                ))),
        floatingActionButton: backButtonWidget(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      );
    }
  }
}
