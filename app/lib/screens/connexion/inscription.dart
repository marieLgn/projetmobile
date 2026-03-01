import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/connexion/connexion.dart';

class PageInscription extends StatefulWidget {
  const PageInscription({super.key});

  @override
  State<PageInscription> createState() => _PageInscriptionState();
}

class _PageInscriptionState extends State<PageInscription>{
  
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
                  "Inscription",
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
                
                Bouton_Dore(label: "S'inscrire", onPressed: () {print("tentative d'inscription");})
              ],
            )
          )
        )
      ),
    );
  }

}