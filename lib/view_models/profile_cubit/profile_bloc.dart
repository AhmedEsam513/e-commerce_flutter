import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/firestore_services.dart';
import 'package:e_commerce/services/hive_services.dart';
import 'package:e_commerce/utils/ApiPaths.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final _authServicesObject = AuthServicesImpl();
  final _fireStoreServices = FireStoreServices.instance;
  final _hiveServices = HiveServices();

  ProfileBloc() : super(ProfileInitial()) {
    on<LogOutEvent>((event, emit) async {
      emit(LoggingOut());
      try {
        // Get the List of favorite products IDs (using Hive)
        final favoritesIDs = _hiveServices.getFavoritesIDs();

        // Get the current user ID (using Firebase)
        final currentUserId = _authServicesObject.getCurrentUser()!.uid;

        // Add (or Update) the list of favorite products IDs to the user document in Firestore
        // { "favorites": ["product1_ID", "product2_ID", "product3_ID"] }
        await _fireStoreServices.updateData(
          {"favorites": favoritesIDs},
          ApiPaths.user(currentUserId),
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
    on<FetchProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      final currentUserId = _authServicesObject.getCurrentUser()!.uid;
      try {
        final currentUserData = await _fireStoreServices.getDocument<UserModel>(
            path: ApiPaths.user(currentUserId), builder: UserModel.fromMap);
        emit(ProfileLoaded(currentUserData));
      } catch (e) {
        emit(ProfileError());
      }
    });
    on<DeleteUserEvent>((event, emit) async {
      emit(LoggingOut());

      try {
        await _authServicesObject.deleteUser();
        emit(LoggedOut());
      } catch (e) {
        emit(LogOutError(e.toString()));
      }
    });
  }
}
