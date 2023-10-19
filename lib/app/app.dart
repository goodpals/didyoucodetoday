import 'package:didyoucodetoday/app/bloc_provider_group.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DidYouCodeToday extends StatelessWidget {
  final GoRouter router;

  const DidYouCodeToday({
    super.key,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProviderGroup(
      child: MaterialApp.router(
        title: 'Did You Code Today?',
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        theme: ThemeData(
          textTheme: GoogleFonts.ralewayTextTheme(),
        ),
      ),
    );
  }
}
