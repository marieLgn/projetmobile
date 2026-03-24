import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

class ProductTab2 extends StatelessWidget {
  const ProductTab2({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();
    final NutritionFacts? facts = product.nutritionFacts;
    final NutrientLevels? levels = product.nutrientLevels;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Repères nutritionnels pour 100g',
              style: TextStyle(
                color: AppColors.grey3,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _NutrientRow(
            name: 'Matières grasses / lipides',
            nutriment: facts?.fat,
            level: levels?.fat,
          ),
          _NutrientRow(
            name: 'Acides gras saturés',
            nutriment: facts?.saturatedFat,
            level: levels?.saturatedFat,
          ),
          _NutrientRow(
            name: 'Sucres',
            nutriment: facts?.sugar,
            level: levels?.sugars,
          ),
          _NutrientRow(
            name: 'Sel',
            nutriment: facts?.salt,
            level: levels?.salt,
          ),
        ],
      ),
    );
  }
}

class _NutrientRow extends StatelessWidget {
  final String name;
  final Nutriment? nutriment;
  final String? level;

  const _NutrientRow({
    required this.name,
    required this.nutriment,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    String valueText = '?';
    if (nutriment != null && nutriment!.per100g != null) {
      valueText = '${nutriment!.per100g}${nutriment!.unit}';
    }

    String levelText = '';
    Color levelColor = AppColors.grey3;

    final String normalizedLevel = level?.toLowerCase() ?? '';

    switch (normalizedLevel) {
      case 'low':
        levelText = 'Faible quantité';
        levelColor = AppColors.nutrientLevelLow;
        break;
      case 'moderate':
        levelText = 'Quantité modérée';
        levelColor = AppColors.nutrientLevelModerate;
        break;
      case 'high':
        levelText = 'Quantité élevée';
        levelColor = AppColors.nutrientLevelHigh;
        break;
      default:
        levelText = '';
        levelColor = AppColors.grey3;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.blueDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      valueText,
                      style: TextStyle(
                        color: levelColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (levelText.isNotEmpty)
                      Text(
                        levelText,
                        style: TextStyle(
                          color: levelColor,
                          fontSize: 12.0,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1.0, color: AppColors.grey2),
      ],
    );
  }
}
