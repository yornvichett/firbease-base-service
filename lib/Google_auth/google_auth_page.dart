import 'package:base_service/Google_auth/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class GoogleAuthPage extends StatefulWidget {
  const GoogleAuthPage({super.key});

  @override
  State<GoogleAuthPage> createState() => _GoogleAuthPageState();
}

class _GoogleAuthPageState extends State<GoogleAuthPage> {
  final GoogleAuthService _authService = GoogleAuthService();

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
      final result = await _authService.signInWithGoogle();

      setState(() {
        _user = result?.user;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
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
        title: const Text('Google Auth Test'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: user == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_circle, size: 100),
                    const SizedBox(height: 20),

                    const Text(
                      'Not signed in',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (_error != null) ...[
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                    ],

                    ElevatedButton.icon(
                      onPressed: _loading ? null : _signIn,
                      icon: const Icon(Icons.login),
                      label: Text(
                        _loading ? 'Signing in...' : 'Sign in with Google',
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: user.photoURL != null
                          ? NetworkImage(user.photoURL!)
                          : null,
                      child: user.photoURL == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(height: 16),

                    Text(
                      user.displayName ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),
                    Text(user.email ?? ''),

                    const SizedBox(height: 10),
                    Text(
                      'UID:\n${user.uid}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: _signOut,
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}