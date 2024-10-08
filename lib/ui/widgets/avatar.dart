import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_back4app/core/extensions/context_extension.dart';
import 'package:flutter_back4app/ui/widgets/custom_button.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });

  final String? imageUrl;
  final void Function(String) onUpload;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: const [
                Text('No Image'),
                CircularProgressIndicator(),
              ],
            ),
          )
        else
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                  widget.imageUrl!,
                ),
              ),
            ),
          ),
        const SizedBox(height: 8),
        CustomButton(
          _isLoading ? 'Loading...' : 'Upload',
          onPressed: _isLoading ? null : _upload,
        ),
      ],
    );
  }

  Future<void> _upload() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;


    } catch (error) {
      if (mounted) {
        context.showErrorSnackBar('Unexpected error occurred');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
