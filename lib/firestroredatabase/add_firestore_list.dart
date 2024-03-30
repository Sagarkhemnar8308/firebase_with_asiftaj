import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tech/firestroredatabase/firestore_list.dart';
import 'package:firebase_tech/realtimedatabase/utils/utils.dart';
import 'package:firebase_tech/realtimedatabase/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class AddFirestoreScreen extends StatefulWidget {
  const AddFirestoreScreen({super.key});

  @override
  State<AddFirestoreScreen> createState() => _AddFirestoreScreenState();
}

class _AddFirestoreScreenState extends State<AddFirestoreScreen> {
  bool loading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();

  final firestore = FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post in FireStore database"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Enter your name ?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                hintText: "Enter your age ?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _educationController,
              decoration: const InputDecoration(
                hintText: "education ex.BCA",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            RoundedElevatedButton(
              text: "Add ",
              loading: loading,
              ontap: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().microsecondsSinceEpoch.toString();
                firestore.doc(id).set({
                  "id": DateTime.now().microsecondsSinceEpoch,
                  "Name": _nameController.text.toString(),
                  "Education": _educationController.text.toString(),
                  "Age": _ageController.text.toString()
                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(
                      "Data added successfully", Colors.red, Colors.white);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FireStoreScreen(),
                      ));
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils()
                      .toastMessage(error.toString(), Colors.red, Colors.white);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
