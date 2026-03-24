import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/favorites/favorite_product_card.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:formation_flutter/screens/homepage/homepage_fetcher.dart';
import 'package:formation_flutter/api/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:pocketbase/pocketbase.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return ChangeNotifierProvider(
      create: (_) => HomepageFetcher(),
      child: Scaffold(
        backgroundColor: AppColors.grey1,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(localizations.my_scans_screen_title),
          centerTitle: false,
          actions: <Widget>[
            Builder(
              builder: (innerContext) => IconButton(
                onPressed: () => _onScanButtonPressed(innerContext),
                icon: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                  child: SvgPicture.asset(
                    'res/svg/bouton_barcode.svg',
                    width: 31,
                    height: 23,
                  ),
                ),
              ),
            ),
            Builder(
              builder: (innerContext) => IconButton(
                onPressed: () => innerContext.push('/favorites'),
                icon: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                  child: SvgPicture.asset(
                    'res/svg/bouton_favorites.svg',
                    width: 24.05,
                    height: 23,
                  ),
                ),
              ),
            ),
            Builder(
              builder: (innerContext) => IconButton(
                onPressed: () => _onLogoutButtonPressed(innerContext),
                icon: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                  child: SvgPicture.asset(
                    'res/svg/bouton_deco.svg',
                    width: 23,
                    height: 23,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Consumer<HomepageFetcher>(
          builder: (consumerContext, notifier, _) {
            switch (notifier.state) {
              case HomepageFetcherLoading():
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.blue),
                );
              case HomepageFetcherError(error: var err):
                return Center(
                  child: Text(
                    'Erreur: $err',
                    style: const TextStyle(color: AppColors.blueDark),
                  ),
                );
              case HomepageFetcherSuccess(products: var products):
                if (products.isEmpty) {
                  return HomePageEmpty(
                    onScan: () => _onScanButtonPressed(consumerContext),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return FavoriteProductCard(product: product);
                  },
                );
            }
          },
        ),
      ),
    );
  }

  Future<void> _onScanButtonPressed(BuildContext context) async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(
          appBarTitle: 'Retour',
          cancelButtonText: 'Annuler',
        ),
      ),
    );

    if (res is String && res != '-1' && res.isNotEmpty) {
      if (!context.mounted) return;

      try {
        if (!context.mounted) return;
        
        // Navigation vers la page produit
        await context.push('/product', extra: res);

        // Rafraichit l'historique de la page d'accueil
        if (context.mounted) {
          context.read<HomepageFetcher>().loadHistory();
        }
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Une erreur est survenue lors de l\'enregistrement du scan.'),
            backgroundColor: AppColors.blueDark,
          ),
        );
      }
    }
  }

  Future<void> _onLogoutButtonPressed(BuildContext context) async {
    final bool? disconnect = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Déconnexion',
            style: TextStyle(color: AppColors.blueDark),
          ),
          content: const Text('Voulez-vous vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(
                'Annuler',
                style: TextStyle(color: AppColors.grey3),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blueDark,
                foregroundColor: Colors.white,
              ),
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );

    if (disconnect == true && context.mounted) {
      AuthService().logout();
      context.go('/');
    }
  }
}
