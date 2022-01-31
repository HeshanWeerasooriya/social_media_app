import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:social_media_app/pages/home.dart';
import '../model/user.dart';
import '../widgets/progress.dart';

class Upload extends StatefulWidget {
  final User? currentUser;
  const Upload({Key? key, required this.currentUser}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  XFile? file;
  final ImagePicker _picker = ImagePicker();
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool isUploading = false;
  String postId = const Uuid().v4();

  handleTakePhoto() async {
    Navigator.pop(context);
    XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file!;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file = file!;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create Post"),
            children: <Widget>[
              SimpleDialogOption(
                  child: const Text("Photo with Camera"),
                  onPressed: handleTakePhoto),
              SimpleDialogOption(
                  child: const Text("Image from Gallery"),
                  onPressed: handleChooseFromGallery),
              SimpleDialogOption(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // SvgPicture.asset('assets/images/upload.svg', height: 260.0),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text(
                  "Upload Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
                color: Colors.deepOrange,
                onPressed: () => selectImage(context)),
          ),
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  // compressImage() async {
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;
  //   Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
  //   final compressedImageFile = File('$path/img_$postId.jpg')
  //     ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
  //   setState(() {
  //     file = compressedImageFile;
  //   });
  // }

  Future<String> uploadImage(imageFile) async {
    final ref = FirebaseStorage.instance.ref('post_$postId.jpg');
    await ref.putFile(File(imageFile!.path));
    final url = await ref.getDownloadURL();
    return url;
  }

  createPostInFirestore({
    String? mediaUrl,
    String? location,
    String? description,
  }) {
    postsRef
        .doc(widget.currentUser!.id)
        .collection("userPosts")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": widget.currentUser!.id,
      "username": widget.currentUser!.username,
      "mediaUrl": mediaUrl,
      "description": description,
      "location": location,
      "timestamp": timestamp,
      "likes": {},
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    //await compressImage();
    String mediaUrl = await uploadImage(file);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: captionController.text,
    );
    captionController.clear();
    locationController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = const Uuid().v4();
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage),
        title: const Text(
          "Caption Post",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : const Text(""),
          SizedBox(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: Image.file(
                File(file!.path),
                fit: BoxFit.cover,
                width: 220,
                height: 220,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.currentUser!.photoUrl),
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: const InputDecoration(
                  hintText: "Write a caption...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.pin_drop,
              color: Colors.orange,
              size: 35.0,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  hintText: "Where was this photo taken?",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 200.0,
            height: 100.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              label: const Text(
                "Use Current Location",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.blue,
              onPressed: getUserLocation,
              icon: const Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    print('OOOOOOO');
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}
