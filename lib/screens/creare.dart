

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;

class CreateVideoScreen extends StatefulWidget {
  @override
  _CreateVideoScreenState createState() => _CreateVideoScreenState();
}

class _CreateVideoScreenState extends State<CreateVideoScreen> {
  final _titleController = TextEditingController();
  File? _videoFile;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  bool _isRecording = false;
  bool camara = false;

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      _cameras = cameras;
    });
  }

  void _initCameraController(CameraDescription cameraDescription) {
    _cameraController = CameraController(cameraDescription, ResolutionPreset.high);
    _cameraController!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    setState(() {
      _videoFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _recordVideo() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      _initCameraController(_cameras![_selectedCameraIndex]);
      return;
    }
    if (_isRecording) {
      XFile videoFile = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _videoFile = File(videoFile.path);
      });
    } else {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

 Future<void> _uploadVideo() async {
    if (_videoFile == null) return;

    // Mostrar un diálogo de progreso
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Subiendo video...'),
              ],
            ),
          ),
        );
      },
    );

    String fileName = path.basename(_videoFile!.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('videos/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_videoFile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String videoUrl = await taskSnapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('videos').add({
      'title': _titleController.text,
      'videoUrl': videoUrl,
    });

    // Cerrar el diálogo de progreso
    Navigator.pop(context);

    // Navegar de vuelta
    Navigator.pop(context);
  }


  void _onSwitchCamera() {
    if (_cameras != null && _cameras!.length > 1) {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
      _initCameraController(_cameras![_selectedCameraIndex]);
    }
  }

  void _toggleCamera() {
    setState(() {
      camara = !camara;
      if (camara) {
        _initCameraController(_cameras![_selectedCameraIndex]);
      } else {
        _cameraController?.dispose();
        _cameraController = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear video')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Titulo del video'),
              ),
              
              
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickVideo,
                child: Text('Subir video desde la galeria'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _toggleCamera,
                child: Text(camara ? 'Deshabilitar cámara' : 'Habilitar cámara'),
              ),
              SizedBox(height: 20),
              camara == true && _cameraController != null && _cameraController!.value.isInitialized
                  ? CameraPreview(_cameraController!)
                  : Container(height: 1,),
                  SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  
                  ElevatedButton(
                    onPressed: _recordVideo,
                    child: Text(_isRecording ? 'Parar video' : 'Grabar Video'),
                  ),
                   ElevatedButton(
                onPressed: _onSwitchCamera,
                child: const Icon(Icons.cameraswitch_outlined ),
              ),
                ],
              ),
              const SizedBox(height: 10),
              _videoFile == null
                  ? Container()
                  : Text('Video Guardado: ${path.basename(_videoFile!.path)}',
                  
                  style: TextStyle(fontSize: 12) ,),
              const SizedBox(height: 50),
              
              ElevatedButton(
                onPressed: _uploadVideo,
                style: ElevatedButton.styleFrom
                (
                  backgroundColor: Color(0xffDE1C7D)
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 90),
                  
                  child: Text('Subir Video',style: TextStyle(color: Colors.white),),
                ),
              ),
              const SizedBox(height: 20),
             
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
