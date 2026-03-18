class UserService {
  // Singleton
  static final UserService _instance = UserService._internal();

  factory UserService() => _instance;

  UserService._internal();

  /// Simulates fetching a list of favorite product barcodes from a remote database
  Future<List<String>> getFavoriteBarcodes() async {
    // Simulated network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      '3168930010265', // Petits pois et carottes Cassegrain
      '3017620425035', // Nutella
      '3274080005003', // Cristaline
      '8002270014901', // San Pellegrino
      '3046920022651', // Lindt Excellence 70%
    ];
  }
}
