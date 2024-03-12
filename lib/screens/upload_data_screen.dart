import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;

  Future getImage() async {
    final pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedImage != null) {
      image = File(pickedImage.path);
      setState(() {});
    } else {
      print('no image picked');
    }
  }

  Future<void> uploadImage() async {
    setState(() {
      showSpinner = true;
    });

    var stream = http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();
    var uri = Uri.parse('https://fakestoreapi.com/products');
    var request = http.MultipartRequest('POST', uri);

    request.fields['title'] = "static title";

    var mutiport = http.MultipartFile('image', stream, length);

    request.files.add(mutiport);
    var response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        showSpinner = true;
      });
      print('Image Uploaded');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Image Uploaded')));
    } else {
      setState(() {
        showSpinner = true;
      });
      throw Exception('Failed to Upload Image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload API call'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: Container(
                child: image == null
                    ? const Center(
                        child: Text('Pick Image'),
                      )
                    : SizedBox(
                        height: 150,
                        width: 150,
                        child: Center(
                          child: Image.file(
                            File(image!.path).absolute,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 120,
            ),
            ElevatedButton(
              onPressed: () {
                uploadImage();
              },
              child: const Text(
                'Upload Image',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
