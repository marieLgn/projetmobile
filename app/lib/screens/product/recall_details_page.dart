import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecallDetailsPage extends StatelessWidget {
  final Map<String, dynamic> recallData;

  const RecallDetailsPage({super.key, required this.recallData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rappel produit',
          style: TextStyle(color: Color(0xFF1A1A40), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.reply, color: Color(0xFF1A1A40)),
            onPressed: () async {
              final url = Uri.parse(recallData['pdfUrl'] ?? '');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (recallData['imageUrl'] != null)
              Image.network(
                recallData['imageUrl'],
                height: 181,
                width: 188,
                fit: BoxFit.contain,
              ),
            _buildSection(
              "Dates de commercialisation",
              "Du ${recallData['dateDebut'] ?? ''} au ${recallData['dateFin'] ?? ''}",
            ),
            _buildSection(
              "Distributeurs",
              recallData['distributeurs'],
            ),
            _buildSection(
              "Zone géographique",
              recallData['zoneGeographique'],
            ),
            _buildSection(
              "Motif du rappel",
              recallData['motif'],
            ),
            _buildSection(
              "Risques encourus",
              recallData['risques'],
            ),
            _buildSection(
              "Informations complémentaires",
              recallData['infosComplementaires'],
            ),
            _buildSection(
              "Conduite à tenir",
              recallData['conduiteATenir'],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String? content) {
    if (content == null || content.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: const Color(0xFFF5F5F9),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A40),
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF4A4A4A),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}