import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String heading;
  final String hint;
  final IconData prefixIcon;
  final String? Function(String? value) validator;
  final bool? obscureText;

  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    required this.heading,
    required this.hint,
    required this.prefixIcon,
    required this.validator,
    this.obscureText=false,
  });

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {

  bool isHidden = true;

  void toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final themeData = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.heading,
          style: themeData.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: deviceSize.height * 0.01),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          //keyboardType: TextInputType.number,
          obscureText: widget.obscureText!? isHidden:false,
          decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(widget.prefixIcon),
              prefixIconColor: Colors.grey,
              suffixIcon: widget.obscureText!? IconButton(
                onPressed: toggleVisibility,
                icon: isHidden? Icon(Icons.visibility_off_outlined):Icon(Icons.visibility_outlined),
              ):null,
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.red))),
        ),
        SizedBox(
          height: deviceSize.height * 0.03,
        )
      ],
    );
  }
}
