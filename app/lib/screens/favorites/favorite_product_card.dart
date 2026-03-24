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
      onTap: () => context.push('/product', extra: product.barcode),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Stack(
          children: [
            // 1. LA CARTE BLANCHE
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 18.0), // On descend la carte de 20px
              padding: const EdgeInsets.only(
                left: 140.0,
                right: 16.0,
                top: 16.0,
                bottom: 16.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(2, 4),
                      blurRadius: 8,
                    ),
                  ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name ?? '',
                    style: const TextStyle(
                      fontFamily: 'Avenir-Heavy',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blueDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.brands?.join(', ') ?? '',
                    style: const TextStyle(
                      fontFamily: 'Avenir-Roman',
                      fontSize: 14,
                      color: AppColors.grey2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          color: _getNutriScoreColor(),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Text(
                        'Nutriscore : ${_getNutriScoreLabel()}',
                        style: const TextStyle(
                          fontFamily: 'Avenir-Roman',
                          fontSize: 14,
                          color: AppColors.blueDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. L'IMAGE (par-dessus)
            Positioned(
              top: 0,
              left: 18,
               // L'image reste à l'intérieur de la carte horizontalement
              child: Container(
                width: 113, // Image plus grande
                height: 113,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: product.picture != null
                      ? Image.network(product.picture!, fit: BoxFit.cover)
                      : Container(
                          color: AppColors.grey1,
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            color: AppColors.grey2,
                            size: 40,
                          ),
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