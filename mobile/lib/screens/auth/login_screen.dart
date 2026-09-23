import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _auth.login(identifier: _identifier.text, password: _password.text);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on DioException catch (error) {
      _showError(error.response?.data?['message'] ?? 'Connexion impossible.');
    } on Object catch (_) {
      _showError('Une erreur est survenue. Vérifiez votre connexion.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(Object message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$message')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.shield_outlined, size: 72),
                  const SizedBox(height: 16),
                  Text('Bienvenue sur SafeHer', textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  const Text('Un espace confidentiel pour vous accompagner.', textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  TextFormField(controller: _identifier, decoration: const InputDecoration(labelText: 'E-mail ou téléphone'), validator: (v) => v == null || v.trim().isEmpty ? 'Ce champ est obligatoire' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _password, obscureText: _obscure, decoration: InputDecoration(labelText: 'Mot de passe', suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscure = !_obscure))), validator: (v) => v == null || v.length < 8 ? '8 caractères minimum' : null),
                  const SizedBox(height: 24),
                  FilledButton(onPressed: _loading ? null : _login, child: _loading ? const CircularProgressIndicator() : const Text('Se connecter')),
                  const SizedBox(height: 8),
                  TextButton(onPressed: _loading ? null : () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen())), child: const Text('Créer un compte')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
