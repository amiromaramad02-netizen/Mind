enum Environment { dev, prod }

class EnvConfig {
  final Environment environment;
  final String apiBaseUrl;
  final bool enableLogging;

  EnvConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.enableLogging = true,
  });

  static EnvConfig dev() => EnvConfig(
        environment: Environment.dev,
        apiBaseUrl: 'https://dev-api.mindsync.com',
        enableLogging: true,
      );

  static EnvConfig prod() => EnvConfig(
        environment: Environment.prod,
        apiBaseUrl: 'https://api.mindsync.com',
        enableLogging: false,
      );
}
