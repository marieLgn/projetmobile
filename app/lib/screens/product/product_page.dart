import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/screens/product/pocketbase_fetcher.dart';
import 'package:formation_flutter/screens/product/product_fetcher.dart';
import 'package:formation_flutter/screens/product/states/empty/product_page_empty.dart';
import 'package:formation_flutter/screens/product/states/error/product_page_error.dart';
import 'package:formation_flutter/screens/product/states/success/product_page_body.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key, required this.barcode})
      : assert(barcode.length > 0);

  final String barcode;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations materialLocalizations =
        MaterialLocalizations.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductFetcher(barcode: barcode)),
        ChangeNotifierProvider(create: (_) => PocketbaseFetcher(barcode: barcode)),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // C'est ici qu'on gère l'affichage principal selon l'état d'Open Food Facts
            Consumer<ProductFetcher>(
              builder: (context, notifier, _) {
                return switch (notifier.state) {
                  ProductFetcherLoading() => const ProductPageEmpty(),
                  ProductFetcherError(error: var err) => ProductPageError(error: err),
                  ProductFetcherSuccess() => const ProductPageBody(),
                };
              },
            ),
            
            // Icônes de navigation (Close / Share)
            PositionedDirectional(
              top: 0.0,
              start: 0.0,
              child: _HeaderIcon(
                icon: AppIcons.close,
                tooltip: materialLocalizations.closeButtonTooltip,
                onPressed: Navigator.of(context).pop,
              ),
            ),
            PositionedDirectional(
              top: 0.0,
              end: 0.0,
              child: _HeaderIcon(
                icon: AppIcons.share,
                tooltip: materialLocalizations.shareButtonLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.tooltip, this.onPressed})
    : assert(tooltip.length > 0);

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(8.0),
        child: Material(
          type: MaterialType.transparency,
          child: Tooltip(
            message: tooltip,
            child: InkWell(
              onTap: onPressed ?? () {},
              customBorder: const CircleBorder(),
              child: Ink(
                padding: const EdgeInsetsDirectional.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.0),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RecallBanner extends StatelessWidget {
  final String motif;
  final String conseil;
  final Map<String, dynamic> fullData;

  const RecallBanner({
    super.key,
    required this.motif,
    required this.conseil,
    required this.fullData
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/recall-details', extra: fullData),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFF0000).withOpacity(0.36),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFA60000)),
                const SizedBox(width: 8),
                const Text(
                  "RAPPEL PRODUIT",
                  style: TextStyle(
                    color: Color(0xFFA60000),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Color(0xFFA60000)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              motif,
              style: const TextStyle(
                color: Color(0xFFA60000),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}