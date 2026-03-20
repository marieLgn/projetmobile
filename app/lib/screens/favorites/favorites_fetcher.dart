import 'package:flutter/material.dart';
import 'package:formation_flutter/api/auth_service.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:pocketbase/pocketbase.dart';

class FavoritesFetcher extends ChangeNotifier {
  FavoritesFetcher() : _state = FavoritesFetcherLoading() {
    loadFavorites();
  }

  FavoritesFetcherState _state;

  Future<void> loadFavorites() async {
    _state = FavoritesFetcherLoading();
    notifyListeners();

    try {
      final pb = AuthService().pb;
      final user = pb.authStore.model;

      if (user == null) {
        _state = FavoritesFetcherError('Utilisateur non connecté');
        notifyListeners();
        return;
      }

      final String userId = (user as RecordModel).id;

      // Récupère tous les favoris de l'utilisateur connecté
      final records = await pb.collection('favorites').getFullList(
        filter: 'user = "$userId"',
      );

      // Extrait les barcodes
      // On récupère le barcode peu importe son format (double ou int) et on le convertit en String proprement
      final barcodes = records
          .map((r) {
            final value = r.data['barcode'];
            if (value == null) return '';
            // Si c'est un nombre (double ou int), on veut éviter la notation scientifique
            if (value is num) {
              return value.toInt().toString();
            }
            return value.toString();
          })
          .where((b) => b.isNotEmpty && b != '0')
          .toList();

      // Récupère les infos produits depuis Open Food Facts
      final products = await Future.wait(
        barcodes.map((barcode) => OpenFoodFactsAPI().getProduct(barcode)),
      );

      _state = FavoritesFetcherSuccess(products);
    } catch (error) {
      _state = FavoritesFetcherError(error);
    } finally {
      notifyListeners();
    }
  }

  FavoritesFetcherState get state => _state;
}

sealed class FavoritesFetcherState {}

class FavoritesFetcherLoading extends FavoritesFetcherState {}

class FavoritesFetcherSuccess extends FavoritesFetcherState {
  FavoritesFetcherSuccess(this.products);

  final List<Product> products;
}

class FavoritesFetcherError extends FavoritesFetcherState {
  FavoritesFetcherError(this.error);

  final dynamic error;
}
