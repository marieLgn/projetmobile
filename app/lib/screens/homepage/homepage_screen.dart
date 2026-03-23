import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/favorites/favorite_product_card.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:formation_flutter/screens/homepage/homepage_fetcher.dart';
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
}
