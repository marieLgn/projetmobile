import 'package:flutter/material.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/api/user_service.dart';

class FavoritesFetcher extends ChangeNotifier {
  FavoritesFetcher() : _state = FavoritesFetcherLoading() {
    loadFavorites();
  }

  FavoritesFetcherState _state;

  Future<void> loadFavorites() async {
    _state = FavoritesFetcherLoading();
    notifyListeners();

    try {
      final barcodes = await UserService().getFavoriteBarcodes();
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
