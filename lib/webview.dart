import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebNews extends StatefulWidget {
  final String url;
  WebNews(this.url);
  @override
  _WebNewsState createState() => _WebNewsState();
}

class _WebNewsState extends State<WebNews> {
  late String finalUrl;
  bool _isLoading = true;
  final Completer<WebViewController> controller =
      Completer<WebViewController>();
  @override
  void initState() {
    if (widget.url.toString().contains("http://")) {
      finalUrl = widget.url.toString().replaceAll("http://", "https://");
      setState(() {
        _isLoading = false;
      });
    } else {
      finalUrl = widget.url;
      setState(() {
        _isLoading = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Detail"),
      ),
      body: _isLoading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(
                  color: Colors.brown,
                ),
              ),
            )
          : Container(
              child: WebView(
                initialUrl: finalUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  setState(() {
                    controller.complete(webViewController);
                  });
                },
              ),
            ),
    );
  }
}
