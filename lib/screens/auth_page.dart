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
  bool _isSignUp = false;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _firstname.dispose();
    _lastname.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    setState(() => _isSigningIn = true);
    try {
      final email = _email.text.trim();
      final password = _password.text;
      if (email.isEmpty || password.length < 6) {
        throw const AuthException(
          'Enter an email and a password of at least 6 characters.',
        );
      }
      if (_isSignUp) {
        if (_firstname.text.trim().isEmpty ||
            _lastname.text.trim().isEmpty) {
          throw const AuthException(
            'Enter your first name and last name.',
          );
        }
        final response = await supabase.auth.signUp(
          email: email,
          password: password,
          data: {
            'firstname': _firstname.text.trim(),
            'lastname': _lastname.text.trim(),
          },
        );
        if (response.session == null && mounted) {
          _showError(
            'Account created. Check your email to confirm your account.',
          );
        }
      } else {
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
      }
    } on AuthException catch (error) {
      _showError(error.message);
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isSigningIn = true);
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb
            ? null
            : 'io.supabase.cs_elective_2://login-callback/',
      );
    } on AuthException catch (error) {
      final message = error.message.contains('provider is not enabled')
          ? 'Google sign-in is disabled. Enable Google under Supabase '
                'Dashboard > Authentication > Providers.'
          : error.message;
      _showError(message);
    } catch (error) {
      _showError('Unable to start Google sign-in: $error');
    } finally {
      if (mounted) {
        setState(() => _isSigningIn = false);
      }
    }
  }

  Future<void> _resetPassword() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      _showError('Enter your email first.');
      return;
    }
    try {
      await supabase.auth.resetPasswordForEmail(email);
      _showError('Password reset instructions were sent to your email.');
    } on AuthException catch (error) {
      _showError(error.message);
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
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: Column(
        children: [
          Container(
            height: 49,
            width: double.infinity,
            color: const Color(0xFF303030),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, size: 19, color: Color(0xFFB8B8B8)),
                SizedBox(width: 8),
                Text(
                  'WUXIAWORLD',
                  style: TextStyle(
                    color: Color(0xFFE7E7E7),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .5,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 42,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 328),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _isSignUp ? 'Sign up' : 'Log in',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 26),
                      if (_isSignUp) ...[
                        const Text(
                          'First name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _AuthField(
                          controller: _firstname,
                          hintText: 'First name',
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Last name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _AuthField(
                          controller: _lastname,
                          hintText: 'Last name',
                        ),
                        const SizedBox(height: 20),
                      ],
                      const Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _AuthField(
                        controller: _email,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (!_isSignUp)
                            GestureDetector(
                              onTap: _resetPassword,
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: Color(0xFF9A9A9A),
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _AuthField(
                        controller: _password,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 21),
                      _PrimaryAuthButton(
                        label: _isSignUp ? 'Sign up' : 'Log in',
                        loading: _isSigningIn,
                        onPressed: _isSigningIn ? null : _submitEmail,
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              _isSignUp
                                  ? 'Already have an account? '
                                  : "Don't have an account? ",
                              style: const TextStyle(
                                color: Color(0xFF777777),
                                fontSize: 12,
                              ),
                            ),
                            GestureDetector(
                              onTap: _isSigningIn
                                  ? null
                                  : () =>
                                        setState(() => _isSignUp = !_isSignUp),
                              child: Text(
                                _isSignUp ? 'Log in' : 'Sign up',
                                style: const TextStyle(
                                  color: Color(0xFF1689E8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 38),
                      const _OrDivider(),
                      const SizedBox(height: 18),
                      _ProviderButton(
                        label: _isSigningIn
                            ? 'Opening Google...'
                            : 'Continue with Google',
                        icon: Icons.g_mobiledata,
                        backgroundColor: const Color(0xFF4285F4),
                        onPressed: _isSigningIn ? null : _signInWithGoogle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF858585), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF202020),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFF898989)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFF1689E8), width: 2),
        ),
      ),
    );
  }
}

class _PrimaryAuthButton extends StatelessWidget {
  const _PrimaryAuthButton({
    required this.label,
    required this.onPressed,
    required this.loading,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF1689E8),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: loading
            ? const SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class _ProviderButton extends StatelessWidget {
  const _ProviderButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFF838383))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Text(
            'Or',
            style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFF838383))),
      ],
    );
  }
}
