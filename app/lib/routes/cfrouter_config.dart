import 'package:app/pages/cfsignin.dart';
import 'package:app/pages/cfonboarding.dart';
import 'package:app/pages/cfsignup.dart';
import 'package:app/pages/cfsplash.dart';
import 'package:app/pages/cfwelcome.dart';
import 'package:app/routes/cfroute_names.dart';
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
        name: CFRouteNames.signInRouteName,
        path: "/sign-in",
        builder: (context, state) => const CFSignIn(),
      ),
    ],
  );
}
