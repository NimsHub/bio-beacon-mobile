import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bio_beacon_mobile/utils/storage_item.dart';

class StorageService {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> writeSecureData(StorageItem newItem) async {
    await _secureStorage.write(key: newItem.key, value: newItem.value);
  }

  Future<String?> readSecureData(String key) async {
    var readData = await _secureStorage.read(key: key);
    return readData;
  }
}
