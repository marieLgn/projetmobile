import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';

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

                _ZoneDeTexte(controller: _emailController, hint: "Adresse Email", icon: Icons.email_outlined),
                const SizedBox(height: 14),

                _ZoneDeTexte(controller: _passwordController, hint: "Mot de passe", icon: Icons.lock_outline, isPassword: true),
                const SizedBox(height: 40),

                _bouton_dore(label: "Créer un compte", onPressed: () {print("Envoie sur la page inscrption");}),
                const SizedBox(height: 14),

                _bouton_dore(label: "Se connecter", onPressed: () {print("Tentative connexion");})
              ],
            ),
          ),
        )
      )
    );
  }

  Widget _ZoneDeTexte({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
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

class _bouton_dore extends StatelessWidget{
  final String label;
  final VoidCallback onPressed;

  const _bouton_dore({required this.label, required this.onPressed});

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
