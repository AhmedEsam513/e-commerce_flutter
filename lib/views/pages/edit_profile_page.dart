import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/view_models/profile_cubit/profile_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;

    final profileBloc = BlocProvider.of<ProfileBloc>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: themeData.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.symmetric(
            horizontal: deviceSize.width * 0.09,
            vertical: deviceSize.height * 0.035),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: deviceSize.height * 0.01,
            ),
            ProfilePhotoWidget(
              user: widget.user,
              isRemovable: true,
            ),
            SizedBox(
              height: deviceSize.height * 0.09,
            ),
            Form(
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
                          newFirstName.isNotEmpty &&
                          newFirstName != widget.user.firstName) {
                        _firstNameController.text = newFirstName;
                        profileBloc.add(UpdateUserInfoEvent(newFirstName));
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
                      if (newLastName != null &&
                          newLastName.isNotEmpty &&
                          newLastName != widget.user.lastName) {
                        _lastNameController.text = newLastName;
                        profileBloc.add(UpdateUserInfoEvent(newLastName));
                      }
                    },
                  )
                ],
              ),
            ),
            Spacer(),
            BlocBuilder(
              bloc: profileBloc,
              //buildWhen: (previous, current) => current is UserInfoUpdated || current is ProfileLoaded,
              builder: (context, state) {
                if (state is UserInfoUpdated) {
                  return MainButton(
                    text: "Save Changes",
                    onPressed: () {
                      Navigator.of(context).pop();
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
          ],
        ),
      ),
    );
  }
}
