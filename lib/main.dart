import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_demo/nav_handler.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _rootRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomePage(),
        ),
        routes: [
          GoRoute(
            path: 'pushed',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: Scaffold(appBar: AppBar(), body: const Text('Pushed')),
            ),
          ),
        ],
      ),
    ],
    errorPageBuilder: defaultErrorPageBuilder(),
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavHandler>(
      create: (_) => NavHandler(_rootRouter),
      child: MaterialApp.router(
        routeInformationParser: _rootRouter.routeInformationParser,
        routerDelegate: _rootRouter.routerDelegate,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navHandler = context.watch<NavHandler>();
    final currentIndex = navHandler.currentTabIndex;

    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: currentIndex,
            children: List.generate(
              navHandler.tabInfos.length,
              (index) {
                return buildTab(context, index, navHandler);
              },
            ),
          ),
        ),
        BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) {
            navHandler.currentTabIndex = i;
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Feed',
              icon: Icon(Icons.feed),
            ),
            BottomNavigationBarItem(
              label: 'Search',
              icon: Icon(Icons.search),
            ),
          ],
        )
      ],
    );
  }

  Widget buildTab(BuildContext context, int index, NavHandler navHandler) {
    final isActive = navHandler.currentTabIndex == index;

    return ActiveTabWrapper(
      isActive: isActive,
      child: Router(
        routerDelegate: navHandler.tabInfos[index].router.routerDelegate,
      ),
    );
  }
}

class ActiveTabWrapper extends StatelessWidget {
  const ActiveTabWrapper({
    Key? key,
    required this.child,
    required this.isActive,
  }) : super(key: key);

  final Widget child;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return HeroMode(
      enabled: isActive,
      child: Offstage(
        offstage: !isActive,
        child: TickerMode(
          enabled: isActive,
          child: child,
        ),
      ),
    );
  }
}

GoRouterPageBuilder defaultErrorPageBuilder() {
  return (BuildContext context, GoRouterState state) {
    return const MaterialPage(
      child: Scaffold(
        body: Center(
          child: Text("Not found"),
        ),
      ),
    );
  };
}
