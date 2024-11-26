import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:helpt/config/color.dart';
import 'package:helpt/screen/home_screen.dart';
import 'package:helpt/service/api_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  Timer? _timer;
  int _pushupCount = 0;
  String? _errorMessage;
  DateTime? _startTime;
  DateTime? _endTime;
  bool _isRunning = false;

  final User? _currentUser = FirebaseAuth.instance.currentUser; // 현재 로그인된 사용자

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndInitializeCamera();
  }

  Future<void> _checkPermissionsAndInitializeCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      _initializeControllerFuture = _initializeCamera();
    } else {
      setState(() {
        _errorMessage = 'Camera permission not granted';
      });
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No cameras available on this device';
        });
        return;
      }

      final camera = cameras.first;
      _cameraController = CameraController(camera, ResolutionPreset.medium);
      await _cameraController!.initialize();

      // 서버에 초기화 요청
      await ApiService().resetCounter();

      setState(() {
        _startTime = DateTime.now();
        _isRunning = true;
      });

      _timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
        if (_cameraController?.value.isInitialized == true) {
          final image = await _cameraController!.takePicture();
          await _sendFrame(image);
        }
      });
    } catch (e) {
      print('Error initializing camera: $e');
      setState(() {
        _errorMessage = 'Error initializing camera: $e';
      });
    }
  }
  Future<void> _sendFrame(XFile image) async {
    try {
      final count = await ApiService().sendFrame(image);
      setState(() {
        _pushupCount = count;
      });
    } catch (e) {
      print('Error sending frame: $e');
    }
  }

  Future<void> _stopExercise() async {
    if (!_isRunning) return;

    setState(() {
      _isRunning = false;
      _endTime = DateTime.now();
    });

    if (_currentUser == null) {
      print('No user logged in. Cannot save exercise data.');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('exercise_sessions')
          .add({
        'start_time': _startTime?.toIso8601String(),
        'end_time': _endTime?.toIso8601String(),
        'pushup_count': _pushupCount,
      });

      print('Exercise session saved to Firebase.');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => HomeScreen()),
            (route) => false,
      );
    } catch (e) {
      print('Error saving to Firebase: $e');
    }

    _timer?.cancel();
    _cameraController?.dispose();
    _cameraController = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    _cameraController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HelPT.background,
      appBar: AppBar(
        title: Text("운동 측정", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: HelPT.background,
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (_errorMessage != null) {
            return Center(child: Text(_errorMessage!));
          } else if (snapshot.connectionState == ConnectionState.done &&
              _cameraController?.value.isInitialized == true) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1.5, color: HelPT.mainBlue),
                        color: HelPT.tapBackgroud,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),

                        ),
                        child: CameraPreview(_cameraController!),
                      )),
                  Column(
                    children: [
                      Text(
                        '푸쉬업 횟수: $_pushupCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          if (_isRunning) {
                            _stopExercise();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _isRunning
                                ? HelPT.mainBlue
                                : HelPT.grey1,
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                vertical: 17, horizontal: 20),
                            child: Center(
                              child: Text(
                                "운동 종료",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: HelPT.mainBlue,),
                    SizedBox(height: 10,),
                    Text("카메라 초기화 중...", style: TextStyle(color: HelPT.lightgrey3))
                  ],
                ));
          }
        },
      ),
    );
  }
}