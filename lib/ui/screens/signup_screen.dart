import 'package:flutter/material.dart';
import 'package:flutter_back4app/constants.dart';
import 'package:flutter_back4app/ui/screens/home_screen.dart';
import 'package:flutter_back4app/ui/widgets/custom_button.dart';
import 'package:flutter_back4app/utils/dialogs.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = 'SignUpScreen';

  const SignUpScreen({super.key});
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  setLoading(value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Flutter Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 16),
              Center(
                child: const Text(
                  'Create new Back4App account',
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
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: controllerEmail,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  labelText: 'E-mail',
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
              SizedBox(height: 8),
              CustomButton(
                isLoading ? 'Signing up...' : 'Sign Up',
                onPressed: isLoading ? null : () => doUserRegistration(),
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void doUserRegistration() async {
    if (_formKey.currentState!.validate()) {
      setLoading(true);
      final username = controllerUsername.text.trim();
      final email = controllerEmail.text.trim();
      final password = controllerPassword.text.trim();

      final user = ParseUser.createUser(username, password, email);

      var response = await user.signUp();

      if (response.success) {
        setLoading(false);
        Dialogs.showSuccess(
            context: context,
            message: 'Your account was successfully created!',
            onPressed: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
              );
            });
      } else {
        setLoading(false);
        Dialogs.showError(context: context, message: response.error!.message);
      }
    }
  }
}
