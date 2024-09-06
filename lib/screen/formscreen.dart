import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/student.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Formscreen extends StatefulWidget {
  const Formscreen({super.key});

  @override
  State<Formscreen> createState() => _FormscreenState();
}

class _FormscreenState extends State<Formscreen> {
  final formKey = GlobalKey<FormState>();

  Student myStudent = Student();
  //Firebase setup
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final CollectionReference _studentCollection =
      FirebaseFirestore.instance.collection("student");
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Save score student form"),
                backgroundColor: Colors.green.shade100,
              ),
              body: Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: RequiredValidator(
                                  errorText: "Please fill student name")
                              .call,
                          onSaved: (String? name) {
                            myStudent.name = name;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Surname",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: RequiredValidator(
                                  errorText: "Please fill student surname")
                              .call,
                          onSaved: (String? surname) {
                            myStudent.surname = surname;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Email",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "Please fill student email"),
                            EmailValidator(
                                errorText: "The email format invalid")
                          ]).call,
                          onSaved: (String? email) {
                            myStudent.email = email;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Score",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: RequiredValidator(
                                  errorText: "Please fill student score")
                              .call,
                          onSaved: (String? score) {
                            myStudent.score = score;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: const Text(
                              "Save data",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState?.save();
                                await _studentCollection.add({
                                  "name": myStudent.name,
                                  "surname": myStudent.surname,
                                  "email": myStudent.email,
                                  "score": myStudent.score
                                });
                                formKey.currentState?.reset();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
