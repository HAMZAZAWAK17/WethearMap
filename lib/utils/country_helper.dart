class CountryHelper {
  /// Obtenir l'emoji du drapeau à partir du code pays (ISO 3166-1 alpha-2)
  static String getFlagEmoji(String countryCode) {
    if (countryCode.isEmpty || countryCode.length != 2) {
      return '🌍'; // Globe par défaut
    }
    
    // Convertir le code pays en emoji de drapeau
    // Chaque lettre est convertie en son équivalent Regional Indicator Symbol
    final int firstLetter = countryCode.codeUnitAt(0);
    final int secondLetter = countryCode.codeUnitAt(1);
    
    // Les Regional Indicator Symbols commencent à 0x1F1E6 (A)
    // et sont espacés de 0x41 (65) de A-Z
    return String.fromCharCode(0x1F1E6 + (firstLetter - 0x41)) +
           String.fromCharCode(0x1F1E6 + (secondLetter - 0x41));
  }
  
  /// Obtenir le nom du pays à partir du code pays
  static String getCountryName(String countryCode) {
    final Map<String, String> countries = {
      'MA': 'Maroc',
      'FR': 'France',
      'GB': 'Royaume-Uni',
      'US': 'États-Unis',
      'JP': 'Japon',
      'AE': 'Émirats Arabes Unis',
      'ES': 'Espagne',
      'IT': 'Italie',
      'DE': 'Allemagne',
      'NL': 'Pays-Bas',
      'PT': 'Portugal',
      'CA': 'Canada',
      'AU': 'Australie',
      'CN': 'Chine',
      'IN': 'Inde',
      'BR': 'Brésil',
      'MX': 'Mexique',
      'AR': 'Argentine',
      'CL': 'Chili',
      'CO': 'Colombie',
      'PE': 'Pérou',
      'VE': 'Venezuela',
      'EG': 'Égypte',
      'ZA': 'Afrique du Sud',
      'NG': 'Nigeria',
      'KE': 'Kenya',
      'GH': 'Ghana',
      'TN': 'Tunisie',
      'DZ': 'Algérie',
      'SN': 'Sénégal',
      'CI': 'Côte d\'Ivoire',
      'BE': 'Belgique',
      'CH': 'Suisse',
      'AT': 'Autriche',
      'SE': 'Suède',
      'NO': 'Norvège',
      'DK': 'Danemark',
      'FI': 'Finlande',
      'PL': 'Pologne',
      'CZ': 'République Tchèque',
      'HU': 'Hongrie',
      'RO': 'Roumanie',
      'GR': 'Grèce',
      'TR': 'Turquie',
      'RU': 'Russie',
      'UA': 'Ukraine',
      'SA': 'Arabie Saoudite',
      'QA': 'Qatar',
      'KW': 'Koweït',
      'BH': 'Bahreïn',
      'OM': 'Oman',
      'JO': 'Jordanie',
      'LB': 'Liban',
      'SY': 'Syrie',
      'IQ': 'Irak',
      'IR': 'Iran',
      'PK': 'Pakistan',
      'BD': 'Bangladesh',
      'LK': 'Sri Lanka',
      'TH': 'Thaïlande',
      'VN': 'Vietnam',
      'MY': 'Malaisie',
      'SG': 'Singapour',
      'ID': 'Indonésie',
      'PH': 'Philippines',
      'KR': 'Corée du Sud',
      'NZ': 'Nouvelle-Zélande',
    };
    
    return countries[countryCode.toUpperCase()] ?? countryCode;
  }
  
  /// Base de données locale des codes pays pour les villes courantes
  static final Map<String, String> cityCountryCodes = {
    // Maroc
    'casablanca': 'MA',
    'rabat': 'MA',
    'marrakech': 'MA',
    'fes': 'MA',
    'tangier': 'MA',
    'agadir': 'MA',
    'meknes': 'MA',
    'oujda': 'MA',
    'kenitra': 'MA',
    'tetouan': 'MA',
    
    // France
    'paris': 'FR',
    'lyon': 'FR',
    'marseille': 'FR',
    'nice': 'FR',
    'bordeaux': 'FR',
    'toulouse': 'FR',
    'nantes': 'FR',
    'strasbourg': 'FR',
    'lille': 'FR',
    'rennes': 'FR',
    
    // Monde
    'london': 'GB',
    'new york': 'US',
    'tokyo': 'JP',
    'dubai': 'AE',
    'madrid': 'ES',
    'rome': 'IT',
    'berlin': 'DE',
    'amsterdam': 'NL',
    'barcelona': 'ES',
    'lisbon': 'PT',
  };
  
  /// Obtenir le code pays à partir du nom de la ville
  static String? getCountryCodeFromCity(String cityName) {
    return cityCountryCodes[cityName.toLowerCase().trim()];
  }
}
