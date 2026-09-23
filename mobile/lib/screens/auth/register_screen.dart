import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget { const RegisterScreen({super.key}); @override State<RegisterScreen> createState() => _RegisterScreenState(); }
class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); final _email = TextEditingController(); final _phone = TextEditingController(); final _password = TextEditingController(); final _auth = AuthService(); bool _loading = false;
  @override void dispose() { _email.dispose(); _phone.dispose(); _password.dispose(); super.dispose(); }
  Future<void> _register() async { if (!_formKey.currentState!.validate()) return; setState(() => _loading = true); try { await _auth.register(email: _email.text, phone: _phone.text, password: _password.text); if (mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false); } on DioException catch (e) { _message('${e.response?.data?['message'] ?? 'Inscription impossible.'}'); } catch (_) { _message('Vérifiez votre connexion.'); } finally { if (mounted) setState(() => _loading = false); } }
  void _message(String text) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text))); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Créer un compte')), body: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(24), children: [TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'E-mail'), validator: (v) { final value = v?.trim() ?? ''; return value.isEmpty || !value.contains('@') ? 'E-mail obligatoire et valide' : null; }), const SizedBox(height: 16), TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Téléphone (optionnel)'), keyboardType: TextInputType.phone), const SizedBox(height: 16), TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Mot de passe'), validator: (v) => v == null || !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(v) ? '8 caractères, majuscule, minuscule et chiffre' : null), const SizedBox(height: 24), FilledButton(onPressed: _loading ? null : _register, child: Text(_loading ? 'Création...' : 'Créer mon compte'))]));
}
