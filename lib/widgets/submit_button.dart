import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/login_form_provider.dart';
import '../services/services.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key? key,
    required this.mounted, 
    required this.type,
  }) : super(key: key);

  final bool mounted;
  final String type;

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      disabledColor: Colors.grey,
      elevation: 0,
      color: Colors.deepPurple,
      onPressed: loginForm.isLoading ? null : () async {
        FocusScope.of(context).unfocus();
        final authService = Provider.of<AuthService>(context, listen: false);

        if(loginForm.isValidForm()) {
          loginForm.isLoading = true;
          final String? response = type == 'login' ? 
          await authService.login(loginForm.email, loginForm.password) : 
          await authService.singIn(loginForm.email, loginForm.password);
          if(response == null) {
            if(mounted) {
              Navigator.pushReplacementNamed(context, 'home');
            }
          } else {
            NotificationsService.showSnackbar(response);
          }
          loginForm.isLoading = false;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        child: Text(
          loginForm.isLoading ? 'Loading...' : 'Submit',
          style: const TextStyle(color: Colors.white)
        ),
      )
    );
  }
}