import 'package:flutter/material.dart';
import 'package:formation_flutter/api/auth_service.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:pocketbase/pocketbase.dart';

class HomepageFetcher extends ChangeNotifier {
  HomepageFetcher() : _state = HomepageFetcherLoading() {
    loadHistory();
  }

  HomepageFetcherState _state;

  Future<void> loadHistory() async {
    _state = HomepageFetcherLoading();
    notifyListeners();

    try {
      final pb = AuthService().pb;
      final user = pb.authStore.model;

      if (user == null) {
        _state = HomepageFetcherError('Utilisateur non connecté');
        notifyListeners();
        return;
      }

      final String userId = (user as RecordModel).id;

      // Récupère l'historique de scans de l'utilisateur connecté
      final records = await pb.collection('scan_history').getFullList(
        filter: 'user = "$userId"',
        sort: '-created',
      );

      // Extrait les barcodes
      final barcodes = records
          .map((r) {
            final value = r.data['barcode'];
            if (value == null) return '';
            if (value is num) {
              return value.toInt().toString();
            }
            return value.toString();
          })
          .where((b) => b.isNotEmpty && b != '0')
          .toList();

      // Récupère les infos produits depuis Open Food Facts
      // On traite chaque barcode un par un de manière ultra-sécurisée
      final List<Product?> results = await Future.wait(
        barcodes.map((barcode) async {
          try {
            // On appelle l'API
            final product = await OpenFoodFactsAPI().getProduct(barcode);
            return product;
          } catch (e) {
            // Si le produit n'est pas trouvé (404, 500, etc.), on retourne null pour ne pas l'afficher
            debugPrint('Produit ignoré de l\'historique (erreur API) : $barcode');
            return null;
          }
        }),
      );

      // On ne garde que les produits valides (on enlève les nulls)
      final products = results.whereType<Product>().toList();

      _state = HomepageFetcherSuccess(products);
    } catch (error) {
      debugPrint('--- Global History Error: $error');
      // En cas d'erreur vraiment critique (ex: PocketBase), on affiche l'erreur
      _state = HomepageFetcherError(error);
    } finally {
      notifyListeners();
    }
  }

  HomepageFetcherState get state => _state;
}

sealed class HomepageFetcherState {}

class HomepageFetcherLoading extends HomepageFetcherState {}

class HomepageFetcherSuccess extends HomepageFetcherState {
  HomepageFetcherSuccess(this.products);

  final List<Product> products;
}

class HomepageFetcherError extends HomepageFetcherState {
  HomepageFetcherError(this.error);

  final dynamic error;
}
