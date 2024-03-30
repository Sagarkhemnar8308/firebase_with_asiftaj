import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tech/firestroredatabase/add_firestore_list.dart';
import 'package:firebase_tech/mixin.dart';
import 'package:firebase_tech/realtimedatabase/utils/utils.dart';
import 'package:firebase_tech/realtimedatabase/view/auth/login_screen.dart';
import 'package:flutter/material.dart';
import '../realtimedatabase/widgets/rounded_button.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> with Animal {
  final auth = FirebaseAuth.instance;

  final _editnamecontroller = TextEditingController();
  final _editEducationcontroller = TextEditingController();
  bool loading = false;
  final firestore = FirebaseFirestore.instance.collection('Users').snapshots();
  final ref = FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddFirestoreScreen(),
                ));
          },
          child: const Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('HomeScreen Firestore'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Utils().toastMessage(
                    "Sign Out Succeessfully", Colors.red, Colors.white);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
              }).onError((error, stackTrace) {
                Utils()
                    .toastMessage(error.toString(), Colors.red, Colors.white);
              });
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
       

       sizedBoxTen( height: 40),


            StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {

                if(snapshot.connectionState==ConnectionState.waiting){
                   return const Center(child: CircularProgressIndicator());
                }else if(snapshot.hasError){
                   return const Text('getting error to fetch a data');
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 2,
                    itemBuilder: (context, index) {
                      var data= snapshot.data?.docs[index];
                      return  ListTile(
                      title: Text(
                                data?['Name'].toString() ?? "",
                      ),
                      subtitle: Text(    data?['Education'].toString() ?? "",
                      ),
                      trailing: PopupMenuButton(
                        padding: const EdgeInsets.all(0),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  child: ListTile(
                                onTap: () {
                                 showEditDailog(data?['Name'].toString() ?? "",  data?['Education'].toString() ?? "", snapshot.data?.docs[index].id.toString() ?? "");
                                },
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                              )),
                               PopupMenuItem(
                                  child: ListTile(
                                    onTap: () {
                                      showDeleteDailog(snapshot.data?.docs[index].id.toString() ?? "");
                                    },
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete'),
                              )),
                            ];
                          },
                          icon: const Icon(Icons.more_vert_sharp)),
                    );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> showEditDailog(String name, String education, String id) async {
    _editEducationcontroller.text = education;
    _editnamecontroller.text = name;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: SizedBox(
            height: 260,
            child: Column(
              children: [
                TextFormField(
                  controller: _editnamecontroller,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _editEducationcontroller,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 10,
                ),
                RoundedElevatedButton(
                  text: "Update",
                  loading: loading,
                  ontap: () {
                    setState(() {
                      loading = true;
                    });
                    ref.doc(id).update({
                      "Id": id,
                      "Name": _editnamecontroller.text.toString(),
                      "Education": _editEducationcontroller.text.toString(),
                    }).then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(
                          "Update successfully", Colors.red, Colors.white);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FireStoreScreen(),
                          ));
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(
                          error.toString(), Colors.red, Colors.white);
                    });
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showDeleteDailog(String id) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Do you want to delete ?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            RoundedElevatedButton(
              text: 'yes',
              ontap: () {
                ref.doc(id).delete().then((value) {
                  Utils().toastMessage(
                      "Delete Successfully", Colors.red, Colors.white);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FireStoreScreen(),
                      ));
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const RoundedElevatedButton(
              text: 'no',
            ),
          ],
        );
      },
    );
  }
}
