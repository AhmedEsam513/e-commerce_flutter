import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  FireStoreServices._();

  static final instance = FireStoreServices._();

  final _fireStore = FirebaseFirestore.instance;

  // setData() used to set new document or update existing document (overwrites whole document)
  // must pass a document path(ex: collectionName/documentID ) and data
  Future<void> setData(Map<String, dynamic> data, String path) async {
    await _fireStore.doc(path).set(data);
  }

  Future<void> updateData(Map<String, dynamic> data, String docPath) async {
    await _fireStore.doc(docPath).update(data);
  }


  Future<void> addDocument(Map<String, dynamic> document,String path) async {
    await _fireStore.collection(path).add(document);
  }


  Future<void> deleteData(String path) async {
    await _fireStore.doc(path).delete();
  }

  // one-time request to get data
  Future<T> getDocument<T>({
    required String path,
    required T Function(Map<String, dynamic> data , String) builder,
  }) async {
    final reference = _fireStore.doc(path);
    final documentSnapshot = await reference.get();

    return builder(
        documentSnapshot.data() as Map<String, dynamic>,documentSnapshot.id);
  }

  Future<T> getDocument1<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
  }) async {
    final reference = _fireStore.doc(path);
    final snapshot = await reference.get();
    return builder(snapshot.data() as Map<String, dynamic>, snapshot.id);
  }


  Future<List<T>> getCollection<T>({
    required String path,
    required T Function(Map<String, dynamic>, String) builder,
  }) async {
    final reference = _fireStore.collection(path);
    final querySnapshot = await reference.get();

    return querySnapshot.docs
        .map((docSnapshot) => builder(docSnapshot.data(), docSnapshot.id))
        .toList();
  }

  Future<bool> doesCollectionExist(String path) async {
    final querySnapshot = await _fireStore.collection(path).limit(1).get();
    return querySnapshot.docs.isNotEmpty;
  }

}
