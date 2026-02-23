import 'package:flutter/material.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/model/product.dart';
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
      
      //récupération données PB
      final pb = PocketBase('http://127.0.0.1:8090');
      try{
        final DataRappel = await pb.collection('Rappel_Produit').getFirstListItem('gtin = '"$_barcode");
        //un rappel a été trouvé
      }
      catch(e){
        //aucun rappel trouvé
      }
      _state = ProductFetcherSuccess(product);
    } catch (error) {
      _state = ProductFetcherError(error);
    } finally {
      notifyListeners();
    }
  }

  ProductFetcherState get state => _state;
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
