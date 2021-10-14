// ignore_for_file: unused_local_variable, await_only_futures

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/localdb.dart';
import 'constant.dart';
import 'profile.dart';

// ignore: use_key_in_widget_constructors
class Login extends StatefulWidget {
  //  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPasswordController =
      TextEditingController(); //we can use default values in Controller if want like text: "12345678".

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  void login() async {
    final String email = userEmailController.text;
    final String password = userPasswordController.text;

    try {
      final UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      final DocumentSnapshot snapshot =
          await db.collection("client").doc(user.user?.uid).get();

      //here we have to tell the compiler about our data type is "Map"
      // final data = snapshot.data();

      print("User is Logged in");
      // print(data["username"]);
      Navigator.of(context).pushNamed("/home");
    } catch (e) {
      print(e);
    }
  }
  //for google SignIN

  void withGoogle() async {
    final swg = await signInWithGoogle();
    print(swg);
    if (swg != null) {
      // await print(swg);
      // Navigator.pushReplacement(context, newRoute)

      Navigator.of(context).pushNamed("/home");
    } else {
      print("Sorry user can't sign in please try later");
    }
  }

  // ignore: missing_return
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow and signin with google for obtaining user details
      // Obtain the auth details from the request with google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential for firebase which will use on firebase auth
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // signing in with obove credential on firebase

      final userCredential = await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // check for null value or anonymous signin
      assert(!user!.isAnonymous, "anonymous sign in not allowed");
      assert(await user?.getIdToken() != null,
          "userValue cannot be equal to null");
      final User? currentUser = await auth.currentUser;
      assert(currentUser?.uid == user?.uid,
          "userid didn't match with current user");
      print(user);
      LocalDataSaver.saveLoginData(true);
      LocalDataSaver.saveName(user!.displayName.toString());
      LocalDataSaver.saveEmail(user.email.toString());
      LocalDataSaver.saveImage(user.photoURL.toString());

      return user;

      // Once signed in, return the UserCredential

      // return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkUserLog() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final user = await auth.currentUser;
    if (user != null) {
      constant.name = (await LocalDataSaver.getName())!;
      constant.email = (await LocalDataSaver.getEmail())!;
      constant.img = (await LocalDataSaver.getImage())!;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  Future<String> signOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
    LocalDataSaver.saveLoginData(false);
    return "SUCCESS";
  }

  signInMethod(context) async {
    await signInWithGoogle();
    constant.name = (await LocalDataSaver.getName())!;
    constant.email = (await LocalDataSaver.getEmail())!;
    constant.img = (await LocalDataSaver.getImage())!;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserLog();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.brown[200],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('images/flutter-logo.png'),
                        radius: 50,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: userEmailController,
                        decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                            hintText: 'Enter Your Email Address'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email Field cannot be empty";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: userPasswordController,
                        decoration: const InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(),
                            hintText: 'Enter Password'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password cannot be empty";
                          } else if (value.length < 6) {
                            return "Password length should be atleast 6";
                          }

                          return null;
                        },
                      ),
                      TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed("/register"),
                          child: const Text("Don't have an account? SIGN UP")),
                      ElevatedButton(
                          onPressed: login, child: const Text("SIGN IN")),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: withGoogle,
                        icon: const FaIcon(FontAwesomeIcons.google,
                            color: Colors.red),
                        label: const Text("sign in with Google"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
