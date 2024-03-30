import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tech/realtimedatabase/utils/utils.dart';
import 'package:firebase_tech/realtimedatabase/view/home_screen.dart';
import 'package:firebase_tech/realtimedatabase/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final databaseref = FirebaseDatabase.instance.ref('Post');
  bool loading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
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

                databaseref
                    .child(id)
                    .set({
                  "Id": id,
                  "Name": _nameController.text.toString(),
                  "Age": _ageController.text.toString(),
                  "Education": _educationController.text.toString()
                }).then((value) {
                  setState(() {
                    loading = false;
                  });

                  Utils().toastMessage(
                      "Add Successfully", Colors.red, Colors.white);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
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
