

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class CreateVideoScreen extends StatefulWidget {
  @override
  _CreateVideoScreenState createState() => _CreateVideoScreenState();
}

class _CreateVideoScreenState extends State<CreateVideoScreen> {
  final _titleController = TextEditingController();
  late File _videoFile;

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    setState(() {
      _videoFile = File(pickedFile!.path);
    });
  }

  Future<void> _uploadVideo() async {
    if (_videoFile == null) return;
    String fileName = path.basename(_videoFile.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('videos/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_videoFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    String videoUrl = await taskSnapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('videos').add({
      'title': _titleController.text,
      'videoUrl': videoUrl,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Video')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Video Title'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Pick Video'),
            ),
            _videoFile == null
                ? Container()
                : Text('Video selected: ${path.basename(_videoFile.path)}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadVideo,
              child: Text('Upload Video'),
            ),
          ],
        ),
      ),
    );
  }
}
