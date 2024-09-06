import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Studentlist extends StatefulWidget {
  const Studentlist({super.key});

  @override
  State<Studentlist> createState() => _StudentlistState();
}

class _StudentlistState extends State<Studentlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exam score report"),
        backgroundColor: Colors.green.shade100,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("student").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              // Extract the fields from the document here
              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: FittedBox(
                    child: Text(document["score"]),
                  ),
                ),
                title: Text(document["name"] + document["surname"]),
                subtitle: Text(document["email"]),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
