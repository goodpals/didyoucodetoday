import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  final String supabaseUrl;
  final String supabaseKey;

  const Environment({
    required this.supabaseUrl,
    required this.supabaseKey,
  });
}

Future<Environment> loadDotEnv() async {
  final dotenv = DotEnv();
  await dotenv.load();
  return Environment(
    supabaseUrl: dotenv.env['SUPABASE_URL']!,
    supabaseKey: dotenv.env['SUPABASE_KEY']!,
  );
}
