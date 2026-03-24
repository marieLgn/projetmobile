import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/favorites/favorite_product_card.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:formation_flutter/screens/homepage/homepage_fetcher.dart';
import 'package:formation_flutter/api/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return ChangeNotifierProvider(
      create: (_) => HomepageFetcher(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.my_scans_screen_title),
          centerTitle: false,
          actions: <Widget>[
            Builder(
              builder: (innerContext) => IconButton(
                onPressed: () => innerContext.push('/favorites'),
                icon: const Padding(
                  padding: EdgeInsetsDirectional.only(end: 8.0),
                  child: Icon(Icons.star_outline_rounded),
                ),
              ),
            ),
            Builder(
              builder: (innerContext) => IconButton(
                onPressed: () => _onScanButtonPressed(innerContext),
                icon: const Padding(
                  padding: EdgeInsetsDirectional.only(end: 8.0),
                  child: Icon(AppIcons.barcode),
                ),
              ),
            ),
            Builder(
              builder: (innerContext) => IconButton(
                onPressed: () => _onLogoutButtonPressed(innerContext),
                icon: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: AppColors.blueDark,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20.0,
                    ),
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

  void _onScanButtonPressed(BuildContext context) {
    context.push('/product', extra: '7622300689124').then((_) {
      if (context.mounted) {
        context.read<HomepageFetcher>().loadHistory();
      }
    });
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
