import 'package:flutter/material.dart';

class AppNavigator extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  String _currentRoute = '/home';

  String get currentRoute => _currentRoute;

  void goHome() {
    _navigate('/home');
  }

  void goPaywall({required String source}) {
    _navigate('/paywall', arguments: {'source': source});
  }

  void _navigate(String routeName, {Object? arguments}) {
    _currentRoute = routeName;
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
    notifyListeners();
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }

  void popUntil(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }
}
