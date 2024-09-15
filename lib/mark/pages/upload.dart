import 'package:flutter/material.dart';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../home/components/draw.dart';
import './results.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => UploadState();
}

class UploadState extends State<Upload> {
  final user = FirebaseAuth.instance.currentUser!;
  final bool _isUploading = false;
  final List<File?> images = [];
  int _currentImageIndex = 0;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isUploading
          ? SingleChildScrollView(
              child: _buildUploadingPage(),
            )
          : SingleChildScrollView(
              child: _buildBody(),
            ),
      appBar: AppBar(
        backgroundColor: const Color(0xff000054),
        elevation: 0,
      ),
      drawer: Draw(
        onSignOut: signUserOut,
      ),
    );
  }

  Widget _buildUploadingPage() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xffCF4520),
            ),
            SizedBox(height: 20),
            Text('Your answer is currently being marked...'),
            Text('Please wait for your results'),
          ],
        ),
      ),
    );
  }

  Stream<bool> checkUploadCompletion(String documentId) {
    return FirebaseFirestore.instance
        .collection('submissions')
        .doc(documentId)
        .snapshots()
        .map(
          (documentSnapshot) => documentSnapshot.get('complete'),
        );
  }

  Future<String> uploadImage(File imageFile, String filePath) async {
    try {
      await FirebaseStorage.instance.ref(filePath).putFile(imageFile);
      return await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    } on FirebaseException {
      return '';
    }
  }

  void _showPermissionDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Map<Permission, PermissionStatus> status = await [
      Permission.photos,
      Permission.camera,
    ].request();

    if (status.isNotEmpty) {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(
          () {
            images.add(File(pickedFile.path));
            _currentImageIndex = images.length - 1;
          },
        );
      }
    } else {
      _showPermissionDialog(
        source == ImageSource.camera
            ? 'Camera Permission Required'
            : 'Gallery Permission Required',
        'Please grant ${source == ImageSource.camera ? 'camera' : 'gallery'} permission to use this feature',
      );
    }
  }

  void takePhoto() => _pickImage(ImageSource.camera);

  void selectPhoto() => _pickImage(ImageSource.gallery);

  void discardImage(int imageIndex) {
    setState(
      () {
        images.removeAt(imageIndex);

        if (_currentImageIndex >= images.length) {
          _currentImageIndex--;
        }
      },
    );
  }

// asynchronous method to upload the photos to cloud firestore
  Future<void> _submitPhotos() async {
    const snackBar = SnackBar(
      content: Text('Please wait while we mark your answer...'),
      duration: Duration(hours: 1),
    );
    // display a message at the bottom of the screen
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // format the images correctly before uploading
    var uploadTasks = images.map(
      // iteration here - for image in images...
      (image) {
        return uploadImage(
          image!,
          'uploads/${user.email}_${DateTime.now()}.png',
        );
      },
    );
    // getting correctly formatted image URLs
    var imageUrls = await Future.wait(uploadTasks);

    // checks before uploading
    if (imageUrls.isNotEmpty) {
      var userName = user.email;
      // upload to firestore
      FirebaseFirestore.instance.collection('submissions').add(
        {
          'imageUrls': imageUrls,
          'username': userName,
          'date': DateTime.now(),
          'feedback': '',
          'complete': false,
        },
      ).then(
        (DocumentReference document) {
          Stream<bool> completionStream = checkUploadCompletion(document.id);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return StreamBuilder<bool>(
                  stream: completionStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data == true) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      return Results(
                        documentId: document.id,
                      );
                    } else {
                      return _buildUploadingPage();
                    }
                  },
                );
              },
            ),
          );
        },
      );
    }
  }

  Widget _buildBody() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          color: const Color(0xff000054),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Mark',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Text(
            'Submit image(s) of your work.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 25),
        _buildPhotoActions(),
        _buildImageContainer(),
      ],
    );
  }

  Widget _buildPhotoActions() {
    return Row(
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            Icons.photo,
            'Select',
            selectPhoto,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            Icons.add_a_photo,
            'Take',
            takePhoto,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Function onPressed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffCF4520),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffCF4520),
          elevation: 0,
        ),
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed as void Function()?,
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff000054),
          width: 3.0,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Color(0xffCF4520),
                ),
                onPressed: images.isNotEmpty
                    ? () => discardImage(_currentImageIndex)
                    : null,
              ),
              Text(
                'Image ${images.isEmpty ? 0 : _currentImageIndex + 1} of ${images.isEmpty ? 0 : images.length}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xffCF4520),
                      size: 18,
                    ),
                    onPressed: _currentImageIndex > 0
                        ? () => setState(
                              () => _currentImageIndex--,
                            )
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xffCF4520),
                      size: 18,
                    ),
                    onPressed: _currentImageIndex < images.length - 1
                        ? () => setState(
                              () => _currentImageIndex++,
                            )
                        : null,
                  ),
                ],
              ),
            ],
          ),
          if (images.isEmpty) ...[
            const SizedBox(height: 100),
            Text(
              'Uploaded images will appear here',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 100),
          ] else ...[
            const SizedBox(height: 10),
            Image.file(
              images[_currentImageIndex]!,
            ),
            const SizedBox(height: 10),
          ],
          ElevatedButton(
            onPressed: images.isEmpty
                ? null
                : () {
                    _submitPhotos();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffCF4520),
            ),
            child: const Text('        Submit        '),
          ),
        ],
      ),
    );
  }
}
