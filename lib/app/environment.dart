import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  final String supabaseUrl;
  final String supabaseKey;

  const Environment({
    required this.supabaseUrl,
    required this.supabaseKey,
  });
}

// just because dotenv doesn't work on web and I can't be bothered rn
Environment tempEnvironment() => const Environment(
      supabaseUrl: 'https://rppdyjstfemrfeosyplq.supabase.co',
      supabaseKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwcGR5anN0ZmVtcmZlb3N5cGxxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTc3MTkwODgsImV4cCI6MjAxMzI5NTA4OH0.RcZ57Bk9BFlcQSvFeDLg2QW_DKKj4aImX9wdlid8al8',
    );

Future<Environment> loadDotEnv() async {
  final dotenv = DotEnv();
  await dotenv.load();
  return Environment(
    supabaseUrl: dotenv.env['SUPABASE_URL']!,
    supabaseKey: dotenv.env['SUPABASE_KEY']!,
  );
}
