import 'package:base_service/phone_auth/phone_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final PhoneAuthService _phoneAuthService = PhoneAuthService();

  final TextEditingController _phoneController = TextEditingController(
    text: "+855962444219",
  );
  final TextEditingController _otpController = TextEditingController();

  bool _loading = false;
  bool _codeSent = false;
  String? _verificationId;
  String? _error;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _phoneAuthService.currentUser;
  }

  Future<void> _sendCode() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      debugPrint('================ PHONE AUTH DEBUG ================');
      debugPrint('phoneNumber => ${_phoneController.text.trim()}');
      debugPrint('firebaseAppName => ${Firebase.app().name}');
      debugPrint('currentUser => ${FirebaseAuth.instance.currentUser?.uid}');
      debugPrint('==================================================');

      await _phoneAuthService.verifyPhoneNumber(
        phoneNumber: _phoneController.text.trim(),

        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            debugPrint('✅ verificationCompleted fired');
            debugPrint('providerId => ${credential.providerId}');
            debugPrint('smsCode => ${credential.smsCode}');
            debugPrint('signInMethod => ${credential.signInMethod}');

            final result = await FirebaseAuth.instance.signInWithCredential(
              credential,
            );

            debugPrint('✅ AUTO LOGIN SUCCESS');
            debugPrint('uid => ${result.user?.uid}');
            debugPrint('phone => ${result.user?.phoneNumber}');

            if (!mounted) return;
            setState(() {
              _user = result.user;
              _loading = false;
            });
          } catch (e, stack) {
            debugPrint('❌ AUTO LOGIN ERROR => $e');
            debugPrintStack(stackTrace: stack);

            if (!mounted) return;
            setState(() {
              _error = e.toString();
              _loading = false;
            });
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          debugPrint('❌ VERIFICATION FAILED');
          debugPrint('code => ${e.code}');
          debugPrint('message => ${e.message}');
          debugPrint('plugin => ${e.plugin}');
          debugPrint('full error => ${e.toString()}');

          if (!mounted) return;
          setState(() {
            _error = '[${e.code}] ${e.message}';
            _loading = false;
          });
        },

        codeSent: (String verificationId) {
          debugPrint('📩 CODE SENT');
          debugPrint('verificationId => $verificationId');

          if (!mounted) return;
          setState(() {
            _verificationId = verificationId;
            _codeSent = true;
            _loading = false;
          });
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('⏱️ AUTO RETRIEVAL TIMEOUT');
          debugPrint('verificationId => $verificationId');
          _verificationId = verificationId;
        },
      );
    } catch (e, stack) {
      debugPrint('❌ OUTER ERROR => $e');
      debugPrintStack(stackTrace: stack);

      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _verifyOtp() async {
    if (_verificationId == null) {
      setState(() {
        _error = 'Verification ID is missing. Please send OTP again.';
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await _phoneAuthService.signInWithOtp(
        verificationId: _verificationId!,
        smsCode: _otpController.text.trim(),
      );

      if (!mounted) return;
      setState(() {
        _user = result.user;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _signOut() async {
    await _phoneAuthService.signOut();

    if (!mounted) return;
    setState(() {
      _user = null;
      _codeSent = false;
      _verificationId = null;
      _error = null;
      _otpController.clear();
      _phoneController.clear();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return Scaffold(
      appBar: AppBar(title: const Text('Phone OTP Auth'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: user == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.phone_android, size: 90),
                    const SizedBox(height: 20),
                    const Text(
                      'Login with Phone Number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        hintText: '+85512345678',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_codeSent)
                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'OTP Code',
                          hintText: 'Enter 6-digit code',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _loading
                            ? null
                            : (_codeSent ? _verifyOtp : _sendCode),
                        child: Text(
                          _loading
                              ? 'Loading...'
                              : (_codeSent ? 'Verify OTP' : 'Send OTP'),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    const Icon(Icons.verified_user, size: 90),
                    const SizedBox(height: 20),
                    const Text(
                      'Phone login successful',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(user.phoneNumber ?? 'No phone number'),
                    const SizedBox(height: 8),
                    Text('UID: ${user.uid}', textAlign: TextAlign.center),
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
