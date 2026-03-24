import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

class ProductTab1 extends StatelessWidget {
  const ProductTab1({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader('Ingrédients'),
          _buildIngredientsList(product.ingredients, context),
          _buildSectionHeader('Substances allergènes'),
          _buildSimpleList(product.allergens, context),
          _buildSectionHeader('Additifs'),
          _buildAdditivesList(product.additives, context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      color: AppColors.grey1,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.blueDark,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget _buildIngredientsList(List<String>? ingredients, BuildContext context) {
    if (ingredients == null || ingredients.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Aucune', style: TextStyle(color: AppColors.grey3)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: ingredients.map((ingredient) {
          String name = ingredient;
          String details = '';

          if (ingredient.contains('(') && ingredient.endsWith(')')) {
            int startIndex = ingredient.indexOf('(');
            name = ingredient.substring(0, startIndex).trim();
            details = ingredient.substring(startIndex + 1, ingredient.length - 1).trim();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: AppColors.blueDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        details,
                        textAlign: TextAlign.end,
                        style: const TextStyle(color: AppColors.grey3),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1.0, color: AppColors.grey2),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSimpleList(List<String>? items, BuildContext context) {
    if (items == null || items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Text(
          'Aucune',
          style: TextStyle(
            color: AppColors.blueDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items.map((item) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  item,
                  style: const TextStyle(
                    color: AppColors.blueDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1.0, color: AppColors.grey2),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdditivesList(Map<String, String>? additives, BuildContext context) {
    if (additives == null || additives.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Text(
          'Aucune',
          style: TextStyle(
            color: AppColors.blueDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: additives.values.map((item) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  item,
                  style: const TextStyle(
                    color: AppColors.blueDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1.0, color: AppColors.grey2),
            ],
          );
        }).toList(),
      ),
    );
  }
}
