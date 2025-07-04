import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaServices {
  final picker = ImagePicker();

  Future<bool> requestPermission() async {
    final permissionStatus = await Permission.photos.request();
    return permissionStatus.isGranted;
  }

  Future<File?> pickImage() async {
    final hasPermission = await requestPermission();
    if (!hasPermission) throw Exception("Permission Needed");

    final picked = await picker.pickImage(source: ImageSource.gallery);
    return picked != null ? File(picked.path) : null;
  }
}
