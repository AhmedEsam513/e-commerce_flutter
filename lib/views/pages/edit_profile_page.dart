import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/view_models/profile_bloc/profile_bloc.dart';
import 'package:e_commerce/views/widgets/custom_text_field_widget.dart';
import 'package:e_commerce/views/widgets/main_button.dart';
import 'package:e_commerce/views/widgets/profile_photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  // Cache the device size to prevent rebuild issues
  late final Size deviceSize;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache device size once to avoid rebuilds on keyboard open/close
    deviceSize = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final profileBloc = BlocProvider.of<ProfileBloc>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: themeData.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: deviceSize.width * 0.09,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  SizedBox(height: deviceSize.height * 0.02),

                  // Profile photo section
                  BlocBuilder<ProfileBloc, ProfileState>(
                    bloc: profileBloc,
                    buildWhen: (previous, current) =>
                        current is ProfilePhotoLoading ||
                        current is ProfilePhotoLoaded ||
                        current is ProfilePhotoError,
                    builder: (context, state) {
                      if (state is ProfilePhotoLoading) {
                        return CircleAvatar(
                          radius: deviceSize.width * 0.2,
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is ProfilePhotoLoaded) {
                        return ProfilePhotoWidget(
                          user: state.userData,
                          isRemovable: true,
                        );
                      } else {
                        return ProfilePhotoWidget(
                          user: widget.user,
                          isRemovable: true,
                        );
                      }
                    },
                  ),

                  SizedBox(height: deviceSize.height * 0.05),

                  // Form section
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFieldWidget(
                          controller: _firstNameController,
                          heading: "First Name",
                          hint: "Edit your first name",
                          prefixIcon: Icons.edit,
                          validator: (firstName) {
                            if (firstName == null || firstName.isEmpty) {
                              return "Please enter a new first name";
                            }
                            return null;
                          },
                          onChanged: (newFirstName) {
                            if (newFirstName != null &&
                                newFirstName.isNotEmpty) {
                              profileBloc.add(ChangeUserInfoEvent(
                                widget.user.firstName,
                                newFirstName,
                                widget.user.lastName,
                                _lastNameController.text,
                              ));
                            }
                          },
                        ),
                        CustomTextFieldWidget(
                          controller: _lastNameController,
                          heading: "Last Name",
                          hint: "Edit your Last name",
                          prefixIcon: Icons.edit,
                          validator: (lastName) {
                            if (lastName == null || lastName.isEmpty) {
                              return "Please enter a new last name";
                            }
                            return null;
                          },
                          onChanged: (newLastName) {
                            if (newLastName != null && newLastName.isNotEmpty) {
                              profileBloc.add(ChangeUserInfoEvent(
                                widget.user.firstName,
                                _firstNameController.text,
                                widget.user.lastName,
                                newLastName,
                              ));
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // Spacer to push button to bottom
                  Spacer(),

                  // Save button
                  BlocBuilder(
                    bloc: profileBloc,
                    buildWhen: (previous, current) =>
                        !(current is ProfilePhotoLoading ||
                            current is ProfilePhotoLoaded ||
                            current is ProfilePhotoError),
                    builder: (context, state) {
                      if (state is UserInfoChanged) {
                        return MainButton(
                          text: "Save Changes",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              profileBloc.add(
                                UpdateUserInfoEvent(
                                  newFirstName: state.firstName,
                                  newLastName: state.lastName,
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          isEnabled: true,
                        );
                      }
                      return MainButton(
                        text: "Save Changes",
                        onPressed: () {},
                        isEnabled: false,
                      );
                    },
                  ),

                  // Bottom padding to ensure button is visible above keyboard
                  SizedBox(height: deviceSize.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
