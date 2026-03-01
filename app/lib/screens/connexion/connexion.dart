import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:go_router/go_router.dart';

class PageConnexion extends StatefulWidget {
  const PageConnexion({super.key});

  @override
  State<PageConnexion> createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion>{

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child:Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blueDark,
                    fontFamily: 'Avenir'
                  ),
                ),
                const SizedBox(height: 79),

                ZoneDeTexte(controller: _emailController, hint: "Adresse Email", icon: Icons.email_outlined),
                const SizedBox(height: 14),

                ZoneDeTexte(controller: _passwordController, hint: "Mot de passe", icon: Icons.lock_outline, isPassword: true),
                const SizedBox(height: 40),

                bouton_dore(label: "Créer un compte", onPressed: () => context.push('/inscription')),
                const SizedBox(height: 14),

                bouton_dore(label: "Se connecter", onPressed: () {print("Tentative connexion");})
              ],
            ),
          ),
        )
      )
    );
  }
}

class ZoneDeTexte extends StatelessWidget{
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPassword;

  ZoneDeTexte({required this.controller, required this.hint, required this.icon, this.isPassword = false});
  
  @override 
  Widget build(BuildContext context)
  {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.black),
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.grey3),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.black)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.black, width: 2),
        )
      )
    );
  }
}

class bouton_dore extends StatelessWidget{
  final String label;
  final VoidCallback onPressed;

  const bouton_dore({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.yellow,
        foregroundColor: AppColors.blueDark,
        fixedSize: Size(197, 45),
        shape: const StadiumBorder(),
        padding : const EdgeInsets.symmetric(vertical: 0),
        elevation : 0
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)
          ),
          const SizedBox(width: 7.5),
          const Icon(Icons.arrow_forward, size: 15)
        ],
      ),
    );
  }
}
