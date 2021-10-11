import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: use_key_in_widget_constructors
class Register extends StatefulWidget {
  //  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();
  void collectData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    final String username = userNameController.text;
    final String email = userEmailController.text;
    final String password = userPasswordController.text;
    try {
      final UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await db.collection("client").doc(user.user?.uid).set({
        "username": username,
        "email": email,
      });
      print("signup Button pressed and username value is " + username);
      print("Congratulations " + username + "has been added to database");
      // it will clear inputfields
      userNameController.clear();
      userEmailController.clear();
      userPasswordController.clear();
    }
    //on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     print('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     print('The account already exists for that email.');
    //   }
    // }
    catch (e) {
      print(e);
    }
    // ignore: avoid_print
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('images/flutter.jpg'),
                    radius: 50,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                        labelText: "User Name",
                        border: OutlineInputBorder(),
                        hintText: 'Enter User Name'),
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
                  ),
                  ElevatedButton(
                      onPressed: collectData, child: const Text("SIGN UP")),
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed("/login"),
                      child: const Text("Already have an account? SIGN IN")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
