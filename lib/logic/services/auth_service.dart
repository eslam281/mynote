import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

    if (!canAuthenticate) return true;

    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to view this locked note',
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Locked Note',
            signInHint: 'Verify identity',
          ),
          IOSAuthMessages(),
        ],
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      return false;
    }
  }
}
