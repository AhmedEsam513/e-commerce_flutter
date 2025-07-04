import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageServices{
  final _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image,String path) async{

    final reference = _storage.ref().child(path);

    final taskSnapshot = await reference.putFile(image);

    final downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL ;
  }
  Future<void> deleteImage(String path) async{
    await _storage.ref().child(path).delete();
  }

}