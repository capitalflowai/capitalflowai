import 'package:CapitalFlowAI/pages/cfsignup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CFWebView extends ConsumerStatefulWidget {
  final String? url;
  const CFWebView({super.key, this.url});

  @override
  ConsumerState<CFWebView> createState() => _CFWebViewState();
}

class _CFWebViewState extends ConsumerState<CFWebView> {
  int progress = 0;
  bool doNotSetState = false;
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  @override
  void initState() {
    super.initState();

    controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (value) {
          if (!doNotSetState) {
            if (value != 100) {
              progress = value;
            } else {
              progress = 0;
            }
            setState(() {});
          }
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://setu.co')) {
            if (request.url.contains("true")) {
              ref.watch(consentAcceptCheck.notifier).state = true;
            }
            doNotSetState = true;
            setState(() {});
            Future.delayed(const Duration(milliseconds: 1), () {
              Navigator.of(context).pop();
            });

            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
    controller.loadRequest(
      Uri.https(
        "fiu-uat.setu.co",
        "/consents/webview/${widget.url}",
      ),
    );
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
                      GoRouter.of(context).pop();
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
            Expanded(child: WebViewWidget(controller: controller)),
          ],
        ),
      ),
    );
  }
}
