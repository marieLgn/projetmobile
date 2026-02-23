import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:formation_flutter/screens/homepage/homepage_screen.dart';
import 'package:formation_flutter/screens/product/pocketbase_fetcher.dart';
import 'package:formation_flutter/screens/product/product_fetcher.dart';
import 'package:formation_flutter/screens/product/product_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, _) => HomePage()),
    GoRoute(
      path: '/product',
      builder: (context, state) {
        final barcode = state.extra as String;

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => ProductFetcher(barcode: barcode),
            ),
            ChangeNotifierProvider(
              create: (_) => PocketbaseFetcher(barcode: barcode),
            ),
          ],
          child: ProductPage(barcode: barcode),
        );
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Open Food Facts',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        extensions: [OffThemeExtension.defaultValues()],
        fontFamily: 'Avenir',
        dividerTheme: DividerThemeData(color: AppColors.grey2, space: 1.0),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: AppColors.blue,
          unselectedItemColor: AppColors.grey2,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          indicatorColor: AppColors.blue,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
