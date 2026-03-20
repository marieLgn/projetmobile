import 'package:flutter/material.dart';
import 'package:formation_flutter/api/auth_service.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/connexion/connexion.dart';
import 'package:go_router/go_router.dart';

class PageInscription extends StatefulWidget {
  const PageInscription({super.key});

  @override
  State<PageInscription> createState() => _PageInscriptionState();
}

class _PageInscriptionState extends State<PageInscription> {
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sInscrire() async {
    setState(() => _isLoading = true);
    try {
      await AuthService().register(_emailController.text.trim(), _passwordController.text);
      if (mounted) context.go('/homepage');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: AppColors.white,
      body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Inscription',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blueDark,
                    fontFamily: 'Avenir'
                  ),
                ),
                const SizedBox(height: 79),

                ZoneDeTexte(controller: _emailController, hint: 'Adresse email', icon: Icons.email_outlined),
                const SizedBox(height: 14),

                ZoneDeTexte(controller: _passwordController, hint: 'Mot de passe', icon: Icons.lock_outline, isPassword: true),
                const SizedBox(height: 40),
                
                _isLoading
                    ? const CircularProgressIndicator()
                    : Bouton_Dore(label: "S'inscrire", onPressed: _sInscrire),
              ],
            )
          )
        )
      );
  }

}