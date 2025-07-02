class Constants {
  // Base API URL (adjust to your backend server's IP/hostname and port)
  static const String apiBaseUrl = 'http://10.0.2.2:5209';//'http://20.64.235.138:8080'; // Use 10.0.2.2 for Android emulator

  // Endpoints
  static const String rabbitEndpoint = '$apiBaseUrl/api/Rabbits';

  // Common strings (optional, to reuse in UI and avoid typos)
  static const String appName = 'Rabbit Manager';
  static const String defaultBreed = 'Unknown';
  static const String imagePlaceholder = 'assets/images/rabbit_placeholder.png';

  // Keys (optional: for shared preferences, form keys, etc.)
  static const String formKey = 'rabbitForm';
}
