import 'package:didyoucodetoday/pages/home_page.dart';
import 'package:go_router/go_router.dart';

GoRouter buildRouter() => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
      ],
    );
