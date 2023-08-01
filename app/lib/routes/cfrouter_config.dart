import 'package:app/pages/cfonboarding.dart';
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
    ],
  );
}
