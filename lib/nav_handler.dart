import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_demo/main.dart';
import 'package:go_router_demo/pages.dart';

class NavHandler extends ChangeNotifier {
  final GoRouter rootRouter;
  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  set currentTabIndex(int v) {
    _currentTabIndex = v;
    notifyListeners();
  }

  NavHandler(this.rootRouter);

  final TabInfo feedTabInfo = TabInfo(
    id: 'feed',
    router: GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const FeedPage(),
          ),
          routes: [
            GoRoute(
              path: 'details',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const FeedItemDetails(),
              ),
            ),
          ],
        ),
      ],
      errorPageBuilder: defaultErrorPageBuilder(),
    ),
  );

  final TabInfo searchTabInfo = TabInfo(
    id: 'search',
    router: GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const SearchPage(),
          ),
        ),
      ],
      errorPageBuilder: defaultErrorPageBuilder(),
    ),
  );

  late final List<TabInfo> tabInfos = [
    feedTabInfo,
    searchTabInfo,
  ];

  /// Navigate to a root [location] and change the bottom nav index accordingly
  void goToRoot(String location, {Object? extra}) {
    if (!location.startsWith("/")) {
      throw Exception("Root location doesn't start with slash: $location");
    }

    if (!location.endsWith("/")) {
      location = location + "/";
    }

    // Maybe handle it with a nested router
    for (var tabInfo in tabInfos) {
      final id = tabInfo.id;
      if (location.startsWith("/" + id + "/")) {
        final thisTabIndex = tabInfos.indexOf(tabInfo);

        // Update current tab index with the new route
        currentTabIndex = thisTabIndex;

        _handleRootRouteWithTab(thisTabIndex, location, extra: extra);
        return;
      }
    }

    rootRouter.go(location, extra: extra);
  }

  void _handleRootRouteWithTab(int tabIndex, String location, {Object? extra}) {
    final splitted = location.split("/");

    // Remote first path (the tab id) to do a "relative" navigation
    String effectiveLocation = splitted.sublist(2).join("/");
    if (!effectiveLocation.startsWith("/")) {
      effectiveLocation = "/" + effectiveLocation;
    }

    final currentRouter = tabInfos[tabIndex].router;
    currentRouter.go(effectiveLocation, extra: extra);
  }
}

class TabInfo {
  final String id;
  final GoRouter router;

  TabInfo({required this.id, required this.router});
}
