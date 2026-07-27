import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

    if (!canAuthenticate) return true; // If device has no security, allow access

    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to view this locked note',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Locked Note',
            biometricHint: 'Verify identity',
          ),
          IOSAuthMessages(
            lockOut: 'Please re-enable Touch ID',
          ),
        ],
      );
    } catch (e) {
      return false;
    }
  }
}
