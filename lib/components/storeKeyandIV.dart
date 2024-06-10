import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

const String encryptionKey = '1234567890abcdef';
const String initializationVector = '1234567890abcdef';

Future<void> storeKeyAndIV() async {
  await storage.write(key: 'SRMAP_APP', value: encryptionKey);
  await storage.write(key: 'iv', value: initializationVector);
}
