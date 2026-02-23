import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketbaseFetcher extends ChangeNotifier {
  PocketbaseFetcher({required String barcode})
      : _barcode = barcode,
        _state = RecallFetcherLoading() {
    loadRecall();
  }

  final String _barcode;
  RecallFetcherState _state;

  Future<void> loadRecall() async {
    _state = RecallFetcherLoading();
    notifyListeners();

    try {
      final pb = PocketBase('http://127.0.0.1:8090');

      final record = await pb.collection('Rappel_Produit').getFirstListItem(
            'gtin = "$_barcode"',
          );

      _state = RecallFetcherSuccess(
        motif: record.getStringValue('motif'),
        conseil: record.getStringValue('conseil'),
        data: record.toJson(),
      );
    } catch (e) {
      _state = RecallFetcherError(e);
    } finally {
      notifyListeners();
    }
  }

  RecallFetcherState get state => _state;
}

sealed class RecallFetcherState {}

class RecallFetcherLoading extends RecallFetcherState {}

class RecallFetcherSuccess extends RecallFetcherState {
  RecallFetcherSuccess({
    required this.motif,
    required this.conseil,
    required this.data,
  });

  final String motif;
  final String conseil;
  final Map<String, dynamic> data;
}

class RecallFetcherError extends RecallFetcherState {
  RecallFetcherError(this.error);
  final dynamic error;
}