import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:go_router/go_router.dart';

class FavoriteProductCard extends StatelessWidget {
  final Product product;

  const FavoriteProductCard({
    super.key,
    required this.product,
  });

  Color _getNutriScoreColor() {
    switch (product.nutriScore) {
      case ProductNutriScore.A:
        return AppColors.nutriscoreA;
      case ProductNutriScore.B:
        return AppColors.nutriscoreB;
      case ProductNutriScore.C:
        return AppColors.nutriscoreC;
      case ProductNutriScore.D:
        return AppColors.nutriscoreD;
      case ProductNutriScore.E:
        return AppColors.nutriscoreE;
      default:
        return AppColors.grey2;
    }
  }

  String _getNutriScoreLabel() {
    if (product.nutriScore == null || product.nutriScore == ProductNutriScore.unknown) {
      return '';
    }
    return product.nutriScore!.name.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/product', extra: product.barcode);
      },
      child: Container(
        // The total container height is defined by its children (the Stack)
        // We add some bottom margin for spacing between list items
        margin: const EdgeInsets.only(bottom: 24.0, left: 16.0, right: 16.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // White Card Background
            Container(
              margin: const EdgeInsets.only(top: 20.0, left: 16.0), // pushes card down and right so image overlaps
              padding: const EdgeInsets.only(left: 100.0, right: 16.0, top: 16.0, bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    offset: const Offset(0, 8),
                    blurRadius: 20,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Produit inconnu',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blueDark, // Or AppColors.blue
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.brands?.join(', ') ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // NutriScore
                  if (product.nutriScore != null && product.nutriScore != ProductNutriScore.unknown)
                    Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: _getNutriScoreColor(),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Nutriscore : ${_getNutriScoreLabel()}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.blueDark,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            
            // Image overriding the card
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 100,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: product.picture != null
                      ? Image.network(
                          product.picture!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppColors.grey1,
                          child: const Icon(Icons.image_not_supported, color: AppColors.grey2),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
