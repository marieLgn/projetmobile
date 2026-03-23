import 'dart:io';
import 'package:flutter/foundation.dart';
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
      final baseUrl = (!kIsWeb && Platform.isAndroid) ? 'http://10.0.2.2:8090' : 'http://127.0.0.1:8090';
      final pb = PocketBase(baseUrl);

      final record = await pb.collection('Rappel_Produit').getFirstListItem(
            'gtin = "$_barcode"',
          );

      _state = RecallFetcherSuccess(
        data: {
          'dateDebut' : record.getStringValue('date_debut_comm'),
          'dateFin' : record.getStringValue('date_fin_comm'),
          'distributeurs': record.getStringValue('distributeur'),
          'zone_geo': record.getStringValue('zone'),
          'motif':record.getStringValue('motif'),
          'conseil':record.getStringValue('conseil')
        },
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
    RecallFetcherSuccess({required this.data});
    final Map<String, dynamic> data;
}

class RecallFetcherError extends RecallFetcherState {
  RecallFetcherError(this.error);
  final dynamic error;
}