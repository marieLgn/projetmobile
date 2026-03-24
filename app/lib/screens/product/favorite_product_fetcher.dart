import 'package:flutter/material.dart';
import 'package:formation_flutter/api/auth_service.dart';
import 'package:pocketbase/pocketbase.dart';

class FavoriteProductFetcher extends ChangeNotifier {
  final String barcode;
  bool _isFavorite = false;
  String? _favoriteRecordId;
  bool _isLoading = true;

  FavoriteProductFetcher({required this.barcode}) {
    checkIfFavorite();
  }

  bool get isFavorite => _isFavorite;
  bool get isLoading => _isLoading;

  Future<void> checkIfFavorite() async {
    _isLoading = true;
    notifyListeners();

    try {
      final pb = AuthService().pb;
      final user = pb.authStore.model;

      if (user != null) {
        final userId = (user as RecordModel).id;
        final records = await pb.collection('favorites').getList(
          page: 1,
          perPage: 1,
          filter: 'user = "$userId" && barcode = "$barcode"',
        );

        if (records.items.isNotEmpty) {
          _isFavorite = true;
          _favoriteRecordId = records.items.first.id;
        } else {
          _isFavorite = false;
          _favoriteRecordId = null;
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la vérification du favori: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite() async {
    final pb = AuthService().pb;
    final user = pb.authStore.model;

    if (user == null) return;
    final userId = (user as RecordModel).id;

    try {
      if (_isFavorite && _favoriteRecordId != null) {
        // Supprimer des favoris
        await pb.collection('favorites').delete(_favoriteRecordId!);
        _isFavorite = false;
        _favoriteRecordId = null;
      } else {
        // Ajouter aux favoris
        final record = await pb.collection('favorites').create(body: {
          'user': userId,
          'barcode': barcode,
        });
        _isFavorite = true;
        _favoriteRecordId = record.id;
      }
    } catch (e) {
      debugPrint('Erreur lors du changement de favori: $e');
    } finally {
      notifyListeners();
    }
  }
}
