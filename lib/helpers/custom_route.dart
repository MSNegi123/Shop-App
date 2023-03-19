import 'package:flutter/material.dart';

class CustomRoute extends MaterialPageRoute {
  /// Setting custom route transition (animation) for single Route
  CustomRoute({
    WidgetBuilder builder,
    RouteSettings settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
      BuildContext buildContext,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(
        opacity: animation,
        child: child,
      );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  /// Setting custom page transition (animation) for all pages for a single Target Platform
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext buildContext,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (route.settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
