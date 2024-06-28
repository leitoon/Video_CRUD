# Video Manager

## Description
Video Manager is a Flutter application designed to manage video recordings, upload them to Firebase Storage, and display the uploaded videos using a video player. It leverages several Flutter packages, including Firebase, Cloud Firestore, Firebase Storage, Image Picker, and Camera.

## Prerequisites

Before running this application, ensure you have the following:

1. Flutter SDK installed
2. Firebase project set up with Firestore and Storage enabled
3. Necessary Flutter packages installed (listed below)

## Project Structure
1. main.dart: Initializes the Firebase app and runs the MyApp widget.
2. home.dart: Contains the Home widget, which displays a list of uploaded videos and provides an interface to navigate to the CreateVideoScreen.
3. creare.dart: Contains the CreateVideoScreen widget, which allows users to record videos, pick videos from the gallery, and upload them to Firebase.
4. videoplayer.dart: Contains the VideoPlayerScreen widget, which plays the selected video.

## How to Run
Clone the repository:
1. git clone https://github.com/yourusername/videomanager.git
Navigate to the project directory:
2. cd videomanager
Install the dependencies:
3. flutter pub get
4. Set up Firebase for your Flutter project. Follow the Firebase setup guide for details.
5. Run the app:
flutter run

## Features
1. Record videos using the camera
2. Pick videos from the gallery
3. Upload videos to Firebase Storage
4. Display uploaded videos from Firestore
5. Delete videos from Firestore and Firebase Storage

## VIDEO
https://drive.google.com/file/d/1KKcRI-WPtzKvPRLaWODs4mndrLOLa4Mm/view?usp=sharing
