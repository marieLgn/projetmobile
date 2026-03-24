import 'package:flutter/material.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/api/auth_service.dart';
import 'package:pocketbase/pocketbase.dart';


class ProductFetcher extends ChangeNotifier {
  ProductFetcher({required String barcode})
    : _barcode = barcode,
      _state = ProductFetcherLoading() {
    loadProduct();
  }

  final String _barcode;
  ProductFetcherState _state;

  Future<void> loadProduct() async {
    _state = ProductFetcherLoading();
    notifyListeners();

    try {
      Product product = await OpenFoodFactsAPI().getProduct(_barcode);
      _state = ProductFetcherSuccess(product);
      
      // Enregistrement dans l'historique car la page s'est chargée avec succès
      _addToHistory();
    } catch (error) {
      String errorMessage = "Désolé, une erreur est survenue lors de la récupération du produit.";
      
      // On personnalise un peu selon l'erreur si besoin
      if (error.toString().contains('404')) {
        errorMessage = "Ce produit n'est pas répertorié sur Open Food Facts.";
      } else if (error.toString().contains('500')) {
        errorMessage = "Le serveur de données rencontre un problème avec ce code spécifique.";
      }
      
      _state = ProductFetcherError(errorMessage);
    } finally {
      notifyListeners();
    }
  }

  ProductFetcherState get state => _state;

  Future<void> _addToHistory() async {
    try {
      final pb = AuthService().pb;
      final user = pb.authStore.model;
      if (user != null) {
        await pb.collection('scan_history').create(body: {
          'user': (user as RecordModel).id,
          'barcode': _barcode,
        });
      }
    } catch (e) {
      // On ignore silencieusement si l'historique ne s'enregistre pas
      // pour ne pas bloquer l'utilisateur qui a déjà le produit chargé.
      debugPrint('Erreur lors de l\'ajout à l\'historique : $e');
    }
  }
}

sealed class ProductFetcherState {}

class ProductFetcherLoading extends ProductFetcherState {}

class ProductFetcherSuccess extends ProductFetcherState {
  ProductFetcherSuccess(this.product);

  final Product product;
}

class ProductFetcherError extends ProductFetcherState {
  ProductFetcherError(this.error);

  final dynamic error;
}
