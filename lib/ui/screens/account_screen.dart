import 'package:flutter/material.dart';
import 'package:flutter_back4app/constants.dart';
import 'package:flutter_back4app/core/extensions/context_extension.dart';
import 'package:flutter_back4app/core/navigator_context.dart';
import 'package:flutter_back4app/ui/screens/signin_screen.dart';
import 'package:flutter_back4app/ui/widgets/avatar.dart';
import 'package:flutter_back4app/ui/widgets/custom_button.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = 'AccountScreen';
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();

  String? _avatarUrl;
  bool _loading = true;

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    final user = await ParseUser.currentUser() as ParseUser;
    setState(() {
      _usernameController.text = user.username!;
    });
    try {} catch (error) {
      if (mounted) {
        context.showErrorSnackBar('Unexpected error occurred');
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final userName = _usernameController.text.trim();
    final website = _websiteController.text.trim();

    final updates = {
      'id': '',
      'username': userName,
      'website': website,
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      if (mounted) context.showSnackBar('Successfully updated profile!');
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred');
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    try {
      final user = await ParseUser.currentUser() as ParseUser;
      var response = await user.logout();

      if (response.success) {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        context.showSuccess("User was successfully logout!");
        NavigatorContext.go(SignInScreen.routeName);
      } else {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        context.showError(response.error!.message);
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred');
      }
    } finally {
      if (mounted) {
        NavigatorContext.go(SignInScreen.routeName);
      }
    }
  }

  /// Called when image has been uploaded to Supabase storage from within Avatar widget
  Future<void> _onUpload(String imageUrl) async {
    try {
      if (mounted) {
        context.showSnackBar('Updated your profile image!');
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred');
      }
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _avatarUrl = imageUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          Avatar(
            imageUrl: _avatarUrl,
            onUpload: _onUpload,
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'User Name'),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _websiteController,
            decoration: const InputDecoration(labelText: 'Website'),
          ),
          const SizedBox(height: 18),
          CustomButton(
            _loading ? 'Saving...' : 'Update',
            onPressed: _loading ? null : _updateProfile,
            isLoading: _loading,
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: _signOut,
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
