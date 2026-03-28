import 'package:base_service/apple_auth/apple_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppleAuthPage extends StatefulWidget {
  const AppleAuthPage({super.key});

  @override
  State<AppleAuthPage> createState() => _AppleAuthPageState();
}

class _AppleAuthPageState extends State<AppleAuthPage> {
  final AppleAuthService _authService = AppleAuthService();

  User? _user;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _user = _authService.currentUser;
  }

  Future<void> _signIn() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await _authService.signInWithApple();
      setState(() {
        _user = result.user;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    setState(() {
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apple Auth Test'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: user == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.apple, size: 90),
                    const SizedBox(height: 20),
                    const Text(
                      'Not signed in',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_error != null) ...[
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                    ],
                    ElevatedButton.icon(
                      onPressed: _loading ? null : _signIn,
                      icon: const Icon(Icons.apple),
                      label: Text(
                        _loading ? 'Signing in...' : 'Sign in with Apple',
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified_user, size: 90),
                    const SizedBox(height: 20),
                    Text(
                      user.displayName ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(user.email ?? 'No email'),
                    const SizedBox(height: 8),
                    Text(
                      'UID: ${user.uid}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _signOut,
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign out'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}