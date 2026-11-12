import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isSigningIn = false;

  Future<void> _signInWithDiscord() async {
    setState(() => _isSigningIn = true);
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.discord,
        redirectTo: kIsWeb
            ? null
            : 'io.supabase.cs_elective_2://login-callback/',
      );
    } on AuthException catch (error) {
      final message = error.message.contains('provider is not enabled')
          ? 'Discord sign-in is disabled. Enable Discord under Supabase '
                'Dashboard > Authentication > Providers.'
          : error.message;
      _showError(message);
    } catch (error) {
      _showError('Unable to start GitHub sign-in: $error');
    } finally {
      if (mounted) {
        setState(() => _isSigningIn = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '龙 WUXIA',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sign in to browse the collection.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isSigningIn ? null : _signInWithDiscord,
                        icon: _isSigningIn
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.code),
                        label: Text(
                          _isSigningIn
                              ? 'Opening GitHub...'
                              : 'Continue with Discord',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
