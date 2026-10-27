import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    publishableKey: dotenv.get('SUPABASE_ANON_KEY'),
  );

  runApp(
    const ProviderScope(child: PokedexApp()),
  );
}

final supabase = Supabase.instance.client;