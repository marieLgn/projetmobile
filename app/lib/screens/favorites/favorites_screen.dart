import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/favorites/favorites_fetcher.dart';
import 'package:formation_flutter/screens/favorites/favorite_product_card.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesFetcher(),
      child: Scaffold(
        backgroundColor: AppColors.grey1,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.blueDark),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Mes favoris',
            style: TextStyle(
              color: AppColors.blueDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: Consumer<FavoritesFetcher>(
          builder: (context, notifier, _) {
            switch (notifier.state) {
              case FavoritesFetcherLoading():
                return const Center(child: CircularProgressIndicator(color: AppColors.blue));
              case FavoritesFetcherError(error: var err):
                return Center(
                  child: Text(
                    'Erreur de chargement: $err',
                    style: const TextStyle(color: AppColors.blueDark),
                  ),
                );
              case FavoritesFetcherSuccess(products: var products):
                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucun favori pour le moment.',
                      style: TextStyle(color: AppColors.blueDark),
                    ),
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
}
