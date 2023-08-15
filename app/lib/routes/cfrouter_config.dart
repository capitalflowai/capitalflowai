import 'package:CapitalFlowAI/pages/home/cfhome.dart';
import 'package:CapitalFlowAI/pages/home/cfmidas.dart';
import 'package:CapitalFlowAI/pages/profile/cfprofile.dart';
import 'package:CapitalFlowAI/pages/signin/cfsignin.dart';
import 'package:CapitalFlowAI/pages/welcome/cfonboarding.dart';
import 'package:CapitalFlowAI/pages/welcome/cfsplash.dart';
import 'package:CapitalFlowAI/pages/welcome/cfwelcome.dart';
import 'package:CapitalFlowAI/pages/signup/cfsignup.dart';
import 'package:CapitalFlowAI/pages/signup/cfwebview.dart';
import 'package:CapitalFlowAI/routes/cfroute_names.dart';
import 'package:flutter/material.dart';
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
        pageBuilder: (context, state) {
          final query = state.pathParameters['url'];

          return CustomTransitionPage(
            key: state.pageKey,
            child: CFWebView(
              url: query,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.decelerate).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: CFRouteNames.signInRouteName,
        path: "/sign-in",
        builder: (context, state) => const CFSignIn(),
      ),
      GoRoute(
        name: CFRouteNames.homeRouteName,
        path: "/home",
        builder: (context, state) => const CFHome(),
      ),
      GoRoute(
        name: CFRouteNames.midasRouteName,
        path: "/midas",
        builder: (context, state) => const CFMidas(),
      ),
      GoRoute(
        name: CFRouteNames.profileRouteName,
        path: "/profile",
        builder: (context, state) => const CFProfile(),
      ),
    ],
  );
}
