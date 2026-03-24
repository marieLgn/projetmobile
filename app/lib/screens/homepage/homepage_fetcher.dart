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

      // Garde uniquement la première occurrence de chaque barcode (le plus récent)
      final uniqueBarcodes = <String>[];
      for (final b in barcodes) {
        if (!uniqueBarcodes.contains(b)) {
          uniqueBarcodes.add(b);
        }
      }

      // Récupère les infos produits depuis Open Food Facts
      // On les charge l'une après l'autre plutôt qu'en bloc pour ne pas faire d'erreur réseau
      final List<Product> products = [];
      for (final barcode in uniqueBarcodes) {
        try {
          final product = await OpenFoodFactsAPI().getProduct(barcode);
          products.add(product);
        } catch (e) {
          debugPrint('Produit $barcode en erreur lors du chargement de l\'historique : $e');
          // Ajout d'un produit "fantôme" pour signaler le souci sans faire sauter la liste
          products.add(Product(
            barcode: barcode,
            name: 'Données non disponibles',
            brands: ['Code : $barcode'],
          ));
        }
      }

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
