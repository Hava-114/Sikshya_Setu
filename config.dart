// central configuration for network endpoints
// when running your Flutter app against a backend hosted on a
// local laptop (offline network), supply the IP:PORT on the
// command line:
//   flutter run --dart-define=API_HOST="192.168.1.42:8000"
// default falls back to the emulator loopback address.

const String _defaultHost = '172.16.45.152:8000';
const String apiHost = String.fromEnvironment('API_HOST', defaultValue: _defaultHost);

String get baseUrl => 'http://$apiHost';
