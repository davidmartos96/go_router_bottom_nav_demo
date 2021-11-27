import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_demo/nav_handler.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go("/details");
              },
              child: const Text("Go to feed details"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<NavHandler>().goToRoot("/search");
              },
              child: const Text("Go to search tab"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<NavHandler>().goToRoot("/pushed");
              },
              child: const Text("Push on top of root"),
            ),
            const SizedBox(height: 20),
            const _PersistentState(),
          ],
        ),
      ),
    );
  }
}

class FeedItemDetails extends StatelessWidget {
  const FeedItemDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed details"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Some details!!"),
            SizedBox(height: 20),
            _PersistentState(),
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<NavHandler>().goToRoot("/feed/details");
              },
              child: const Text("Go to nested feed details"),
            ),
            const SizedBox(height: 20),
            const _PersistentState(),
          ],
        ),
      ),
    );
  }
}

class _PersistentState extends StatefulWidget {
  const _PersistentState({Key? key}) : super(key: key);

  @override
  __PersistentStateState createState() => __PersistentStateState();
}

class __PersistentStateState extends State<_PersistentState> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text("Persistent state: Count = $counter"),
            const SizedBox(
              height: 10,
            ),
            IconButton(
              onPressed: () => setState(() {
                counter += 1;
              }),
              icon: const Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}
