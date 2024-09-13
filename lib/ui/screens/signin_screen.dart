
import 'package:flutter/material.dart';
import 'package:flutter_back4app/constants.dart';
import 'package:flutter_back4app/ui/screens/home_screen.dart';
import 'package:flutter_back4app/ui/screens/reset_password_screen.dart';
import 'package:flutter_back4app/ui/screens/signup_screen.dart';
import 'package:flutter_back4app/ui/widgets/custom_button.dart';
import 'package:flutter_back4app/utils/dialogs.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = 'SignInScreen';

  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  bool isLoggedIn = false;
  bool isLoading = false;
  bool isChecked = false;

  setLoading(value) {
    setState(() {
      isLoading = value;
    });
  }

  void onChanged(bool? value) {
    setState(() {
      isChecked = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Flutter - Back4App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
              ),
              Center(
                child: const Text(
                  'Login to your Back4App account',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: controllerUsername,
                enabled: !isLoggedIn,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: controllerPassword,
                enabled: !isLoggedIn,
                obscureText: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(value: isChecked, onChanged: onChanged),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Remember me',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 25),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        navigateToResetPassword();
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 0, 84, 152),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              CustomButton(
                isLoading ? 'Authenticating...' : 'Login',
                onPressed: isLoading ? null : () => doUserLogin(),
                isLoading: isLoading,
              ),
              const SizedBox(height: 15),
              Container(
                height: 50,
                child: ElevatedButton(
                  child: const Text('Sign Up'),
                  onPressed: () => navigateToSignUp(),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text('or'),
              ),
              const SizedBox(height: 15),
              CustomButton(
                'Continue with Google',
                onPressed: isLoading ? null : () async {},
                iconImage: Image.asset('assets/google.png'),
                isLoading: isLoading,
                backColor: Colors.black,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void doUserLogin() async {
    if (_formKey.currentState!.validate()) {
      setLoading(true);
      final username = controllerUsername.text.trim();
      final password = controllerPassword.text.trim();

      final user = ParseUser(username, password, null);

      var response = await user.login();

      if (response.success) {
        setLoading(false);
        navigateToUser();
      } else {
        setLoading(false);
        Dialogs.showError(context: context, message: response.error!.message);
      }
    }
  }

  void navigateToUser() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  void navigateToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
    );
  }
}
