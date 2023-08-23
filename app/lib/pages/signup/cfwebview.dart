import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CFWebView extends ConsumerStatefulWidget {
  final String? url;
  const CFWebView({super.key, this.url});

  @override
  ConsumerState<CFWebView> createState() => _CFWebViewState();
}

class _CFWebViewState extends ConsumerState<CFWebView> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  int progress = 0;
  bool doNotSetState = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    spreadRadius: 1.0,
                    blurRadius: 1.0,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      GoRouter.of(context).pop(webViewController!.getUrl());
                    },
                    icon: const Icon(FeatherIcons.x),
                  ),
                  const Icon(Icons.lock, size: 17.0),
                  const SizedBox(width: 5.0),
                  const Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(right: 50.0),
                      child: Text(
                        "fiu-uat.setu.co",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          fontSize: 16.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: InAppWebView(
                key: webViewKey,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                initialUrlRequest: URLRequest(
                  url: Uri.https(
                    "fiu-uat.setu.co",
                    "/consents/webview/${widget.url}",
                  ),
                ),
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {}
                },
                onLoadStart: (controller, url) {
                  if (url.toString().startsWith("https://setu.co")) {
                    NavigationActionPolicy.CANCEL;
                    GoRouter.of(context).pop("approved");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
