import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _auth.register(email: _email.text, password: _password.text);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
    } on DioException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${error.response?.data?['message'] ?? 'Inscription impossible.'}')));
    } finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Créer un compte')),
    body: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(24), children: [
      const Text('Vos données doivent rester confidentielles. Utilisez un mot de passe unique.'),
      const SizedBox(height: 24),
      TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'E-mail'), validator: (v) => v == null || !v.contains('@') ? 'E-mail invalide' : null),
      const SizedBox(height: 16),
      TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Mot de passe'), validator: (v) => v == null || v.length < 8 ? '8 caractères minimum' : null),
      const SizedBox(height: 24),
      FilledButton(onPressed: _loading ? null : _register, child: _loading ? const CircularProgressIndicator() : const Text('Créer mon compte')),
    ])),
  );
}
