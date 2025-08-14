import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/firebase_storage_services.dart';
import 'package:e_commerce/services/firestore_services.dart';
import 'package:e_commerce/services/hive_services.dart';
import 'package:e_commerce/services/media_services.dart';
import 'package:e_commerce/utils/ApiPaths.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final _authServicesObject = AuthServicesImpl();
  final _fireStoreServices = FireStoreServices.instance;
  final _hiveServices = HiveServices();
  final _media = MediaServices();
  final _storage = FirebaseStorageServices();

  String get _currentUserId => _authServicesObject.getCurrentUser()!.uid;

  ProfileBloc() : super(ProfileInitial()) {
    /// Log out
    on<LogOutEvent>((event, emit) async {
      emit(LoggingOut());
      try {
        // Get the List of favorite products IDs (using Hive)
        final favoritesIDs = _hiveServices.getFavoritesIDs();

        // Add (or Update) the list of favorite products IDs to the user document in Firestore
        // { "favorites": ["product1_ID", "product2_ID", "product3_ID"] }
        await _fireStoreServices.updateData(
          {"favorites": favoritesIDs},
          ApiPaths.user(_currentUserId),
        );

        // Clear the Hive favorites box
        await _hiveServices.clearFavorites();

        // Log out the user
        await _authServicesObject.logOut();

        // Emit the LoggedOut state
        emit(LoggedOut());
      } catch (e) {
        emit(LogOutError(e.toString()));
      }
    });

    /// Fetch Profile
    on<FetchProfileEvent>((event, emit) async {
      emit(ProfileLoading());

      try {
        // Get the current user's data from FireStore
        final currentUserData = await _fireStoreServices.getDocument<UserModel>(
          path: ApiPaths.user(_currentUserId),
          builder: UserModel.fromMap,
        );

        // Emit the ProfileLoaded state with the current user's data
        emit(ProfileLoaded(currentUserData));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    /// Delete User
    on<DeleteUserEvent>((event, emit) async {
      emit(LoggingOut());
      try {
        await _authServicesObject.deleteUser();
        emit(LoggedOut());
      } catch (e) {
        emit(LogOutError(e.toString()));
      }
    });

    /// Update Profile Photo
    on<UpdateProfilePhotoEvent>((event, emit) async {
      try {
        // Pick an image from the device
        final picked = await _media.pickImage();

        // Check if an image was picked (nullability check)
        if (picked != null) {
          emit(ProfilePhotoLoading());

          // Upload the image to Firebase Storage
          final imageUrl = await _storage.uploadImage(
            picked,
            ApiPaths.userProfilePhoto(_currentUserId),
          );
          print("Image URL: $imageUrl");

          // Update the user's profile photo URL in FireStore
          await _fireStoreServices.updateData(
            {"profilePhotoUrl": imageUrl},
            ApiPaths.user(_currentUserId),
          );

          // Get the updated user data from FireStore
          final newUserData = await _fireStoreServices.getDocument<UserModel>(
            path: ApiPaths.user(_currentUserId),
            builder: UserModel.fromMap,
          );

          emit(ProfilePhotoLoaded(newUserData));
        } else {
          // If no image was picked, emit an error
          emit(ProfilePhotoError("No Image Selected"));
        }
      } catch (e) {
        emit(ProfilePhotoError(e.toString()));
      }
    });

    /// Delete Profile Photo
    on<DeleteProfilePhotoEvent>((event, emit) async {
      try {
        emit(ProfilePhotoLoading());

        // Delete the image from Firebase Storage
        await _storage.deleteImage(ApiPaths.userProfilePhoto(_currentUserId));

        // Update the user's profile photo URL in FireStore
        await _fireStoreServices.updateData(
          {"profilePhotoUrl": null},
          ApiPaths.user(_currentUserId),
        );

        // Get the updated user data from FireStore
        final newUserData = await _fireStoreServices.getDocument<UserModel>(
          path: ApiPaths.user(_currentUserId),
          builder: UserModel.fromMap,
        );

        emit(ProfilePhotoLoaded(newUserData));
      } catch (e) {
        emit(ProfilePhotoError(e.toString()));
      }
    });

    /// Change User Info
    on<ChangeUserInfoEvent>((event, emit) {
      if ((event.oldFirstName != event.newFirstName) ||
          (event.oldLastName != event.newLastName)) {
        emit(UserInfoChanged(event.newFirstName, event.newLastName));
      } else {
        emit(UserInfoChangedToOriginal());
      }
    });

    on<UpdateUserInfoEvent>((event, emit) {
      _fireStoreServices.updateData(
        {"firstName": event.newFirstName, "lastName": event.newLastName},
        ApiPaths.user(_currentUserId),
      );
    });
  }
}
