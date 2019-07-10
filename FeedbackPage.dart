import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_format/date_format.dart';
//PAGE2
class FirestoreCRUDPage extends StatefulWidget {
  const FirestoreCRUDPage({Key key}) : super(key: key);

  @override
  FirestoreCRUDPageState createState() {
    return FirestoreCRUDPageState();
  }
}

class FirestoreCRUDPageState extends State<FirestoreCRUDPage> {
  String id;
  String userEmail = "";
  String time="";
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textFieldController1 = TextEditingController();
  String feedback;

  _onClear() {
    setState(() {
      _textFieldController1.text = "";
    });
  }

  @override
  initState() {
    super.initState();
    doAsyncStuff();
  }

  doAsyncStuff() async {
    FirebaseUser name = await FirebaseAuth.instance.currentUser();
    userEmail = name.email;
    var firstName = userEmail.split('@');
    var now = new DateTime.now();
    final timeNow = formatDate(
        now, [dd, '/', mm, '/', yy, ' at ', HH, ':', nn]);
    //print(time);
    setState(() {
      userEmail = firstName[0];
      time =timeNow;
    });
  }


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
              Colors.teal,
              Colors.black,
              Colors.black,
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: new Container(
            //color: Colors.grey[800],
              padding: EdgeInsets.all(18.0),
              child: new Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: buildTextFormField() + buildPostButton() + bekarKaContainer(),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  List<Widget> bekarKaContainer(){
    return [new Container(
      height: 200,
    )];
  }


  List<Widget> buildTextFormField() {
    return [
      new Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Text(
            'Feedback',
            textScaleFactor: 2,
            textAlign: TextAlign.justify,
          ),
        ),
      ),
      new Container(
        height: 30.0,
      ),
      new TextFormField(
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          controller: _textFieldController1,
          decoration: InputDecoration(
              fillColor: Colors.black.withOpacity(0.5),
              filled: true,
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(8.0),
                ),
                borderSide: new BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
              ),
              labelText: '  Type your feedback',
              hintText: '  How do we improve?',
              labelStyle: new TextStyle(color: Colors.grey, fontSize: 16.0)),
          maxLines: 3,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
          },
          onSaved: (value) {
            feedback = value;
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Sent! 😄',
                      style: TextStyle(color: Colors.lightGreen)),
                  content: const Text(
                      'You have successfully submitted your feedback. Thank you for support! ♥️',
                      style: TextStyle(color: Colors.white70)),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new RaisedButton(
                        color: Colors.lightGreen,
                        elevation: 4.0,
                        splashColor: Colors.white70,
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                          Navigator.pop(context);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Done',
                            style: TextStyle(
                              color: Colors.black,
                              decorationStyle: TextDecorationStyle.wavy,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
            _onClear();
          })
    ];
  }
  List<Widget> buildPostButton() {
    return [
      new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new SizedBox(
          height: 50,
          width: 150,
          child: new RaisedButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20)),
            color: Colors.white,
            elevation: 4.0,
            splashColor: giveSplashColor(),
            onPressed: (){
              createData();
            },
            child: RichText(
              text: TextSpan(
                text: ' Send ',
                style: TextStyle(
                  color: Colors.black,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db
          .collection('FEEDBACK')
          .add({'name': '$feedback', 'user': '$userEmail', 'time': '$time'});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
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
