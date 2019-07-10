import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'FeedbackPage.dart';

//PAGE3
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key key,
  }) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final db = Firestore.instance;
  File sampleImage = File('');
  String userEmail = "";
  String url = "https://fallofthewall25.com/img/default-user.jpg";

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 400.0, maxHeight: 400.0);
    setState(() {
      sampleImage = tempImage;
    });
  }

  uploadImage() async{
      print(" CALLED ONPRESSED\n");
      final StorageReference firebaseStorageRef =
      FirebaseStorage.instance
          .ref()
          .child('$userEmail.jpg');
      final StorageUploadTask uploadTask =
      firebaseStorageRef.putFile(sampleImage);
      final StorageTaskSnapshot downloadUrl =
      (await uploadTask.onComplete);
      final String finalUrl = (await downloadUrl.ref.getDownloadURL());
    print('URL Is $finalUrl');
      setState(() {
        url = finalUrl;
      });

  }


  @override
  initState() {
    super.initState();
    doAsyncStuff();
   // displayImage();
  }

  doAsyncStuff() async {
    FirebaseUser name = await FirebaseAuth.instance.currentUser();
    userEmail = name.email;
    var firstName = userEmail.split('@');

    setState(() {
      userEmail = firstName[0];
    });
  }
 /* displayImage() async{
    print('INSIDE!!');
    StorageReference ref =
    FirebaseStorage.instance.ref().child('$userEmail');
    String urlNew = (await ref.getDownloadURL()).toString();
    print(urlNew);
    setState(() {
      url = urlNew;
    });
  }
  getDisplayPicture() async {
    print("INSIDE GETDISPLAY PICTURE\n");
    var ref = FirebaseStorage.instance.ref().child('$userEmail');
// no need of the file extension, the name will do fine.
    var url2 = await ref.getDownloadURL();
    print(url2);
    setState(() {
      url = url2;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0, 0.5, 0.7, 0.9], //fade, reach,
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Colors.red,
                Colors.black,
                Colors.black,
                Colors.black,
              ],
            ),
          ),
          child: new Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  new Container(
                      padding: const EdgeInsets.only(top: 100.0),
                      width: 190.0,
                      height: 190.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover, //image: NetworkImage(url)
                            image: AssetImage("assets/user.jpg"),
                          )
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        '$userEmail',
                        textScaleFactor: 2.5,
                        style: TextStyle(fontWeight: FontWeight.w400),
                        textAlign: TextAlign.justify,
                      )),
                    ),
                  ),
                  new Container(
                    height: 50.0,
                  ),
                  ButtonTheme(
                    minWidth: 150,
                    child: new FlatButton(
                      splashColor: giveSplashColor(),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20)),
                      onPressed: () {
                        //getImage();
                        //uploadImage();
                        //getDisplayPicture();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FirestoreCRUDPage()),
                        );
                      },
                      color: Colors.white24,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Icon(Icons.feedback),
                          Text('Feedback'),
                        ],
                      ),
                    ),),
                  new Container(
                    height: 180.0,
                  ),

                ],
              ),
            ),
          ),),
    );
  }

}

Color giveSplashColor() {
  var now = new DateTime.now();
  int r, g, b;
  var rng = new Random(now.millisecondsSinceEpoch);
  r = rng.nextInt(255);
  g = rng.nextInt(255);
  b = rng.nextInt(255);
  Color culor = new Color.fromRGBO(r, g, b, 1.0);
  return culor;
}
