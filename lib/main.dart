import 'package:didyoucodetoday/app/app.dart';
import 'package:didyoucodetoday/app/environment.dart';
import 'package:didyoucodetoday/app/locator.dart';
import 'package:didyoucodetoday/app/router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final env = await loadDotEnv();
  final env = tempEnvironment();

  await Supabase.initialize(
    url: env.supabaseUrl,
    anonKey: env.supabaseKey,
    authFlowType: AuthFlowType.pkce,
  );
  setupLocator(environment: env);
  await GoogleFonts.pendingFonts([GoogleFonts.raleway()]);
  runApp(DidYouCodeToday(
    router: buildRouter(),
  ));
}
