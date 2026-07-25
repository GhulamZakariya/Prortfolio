class AppEnvironment {
  static const amplitudeAPIKey = String.fromEnvironment("amplitude_api_key");

  /// Web3Forms access key for the contact form. Injected at build time:
  /// `--dart-define=web3forms_access_key=YOUR_KEY` (never hardcoded).
  static const web3formsAccessKey =
      String.fromEnvironment("web3forms_access_key");
}
