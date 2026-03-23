import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// اختيار صورة من المعرض
  Future<File?> pickImage() async {
    final XFile? picked =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return null;
    return File(picked.path);
  }

  /// رفع صورة المستخدم إلى المسار users/{uid}/profile.jpg
  Future<String?> uploadUserImage({
    required String uid,
    required File file,
  }) async {
    try {
      final ref = _storage.ref().child('users/$uid/profile.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      // ممكن تطبع الخطأ للـ debug
      print('Upload error: $e');
      return null;
    }
  }
}
