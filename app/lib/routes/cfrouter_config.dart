import 'package:CapitalFlowAI/pages/cfhome.dart';
import 'package:CapitalFlowAI/pages/cfinitconsent.dart';
import 'package:CapitalFlowAI/pages/cfsignin.dart';
import 'package:CapitalFlowAI/pages/cfonboarding.dart';
import 'package:CapitalFlowAI/pages/cfsignup.dart';
import 'package:CapitalFlowAI/pages/cfsplash.dart';
import 'package:CapitalFlowAI/pages/cfwebview.dart';
import 'package:CapitalFlowAI/pages/cfwelcome.dart';
import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:go_router/go_router.dart';

class CFRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: CFRouteNames.splashRouteName,
        path: "/",
        builder: (context, state) => const CFSplash(),
      ),
      GoRoute(
        name: CFRouteNames.onboardingRouteName,
        path: "/onboarding",
        builder: (context, state) => const CFOnboarding(),
      ),
      GoRoute(
        name: CFRouteNames.welcomeRouteName,
        path: "/welcome",
        builder: (context, state) => const CFWelcome(),
      ),
      GoRoute(
        name: CFRouteNames.signUpRouteName,
        path: "/sign-up",
        builder: (context, state) => const CFSignUp(),
      ),
      GoRoute(
        name: CFRouteNames.webviewRouteName,
        path: "/webview:url",
        builder: (context, state) {
          print(state.pathParameters);
          final query = state.pathParameters['url'];
          return CFWebView(
            url: query,
          );
        },
      ),
      GoRoute(
        name: CFRouteNames.signInRouteName,
        path: "/sign-in",
        builder: (context, state) => const CFSignIn(),
      ),
      GoRoute(
        name: CFRouteNames.initConsentRouteName,
        path: "/consent-sign-up",
        builder: (context, state) => const CFInitConsent(),
      ),
      GoRoute(
        name: CFRouteNames.homeRouteName,
        path: "/home",
        builder: (context, state) => const CFHome(),
      ),
    ],
  );
}
