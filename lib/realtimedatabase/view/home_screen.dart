import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tech/realtimedatabase/utils/utils.dart';
import 'package:firebase_tech/realtimedatabase/view/auth/login_screen.dart';
import 'package:firebase_tech/realtimedatabase/view/post/addpost.dart';
import 'package:firebase_tech/realtimedatabase/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  final ref = FirebaseDatabase.instance.ref('Post');
  final __searchController = TextEditingController();
  final _editnamecontroller = TextEditingController();
  final _editEducationcontroller = TextEditingController();
  bool loading = false;
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
                  builder: (context) => const AddPostScreen(),
                ));
          },
          child: const Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('HomeScreen real-time-databse'),
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
            TextFormField(
              onChanged: (value) {
                setState(() {});
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Search ...",
              ),
              controller: __searchController,
            ),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: const Center(
                  child: Text('Loading..........'),
                ),
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  String title = snapshot.child('Name').value.toString();
                  String subtitle =
                      snapshot.child('Education').value.toString();
                  String id = snapshot.child('Id').value.toString();
                  if (__searchController.text.isEmpty) {
                    return ListTile(
                      title: Text(
                        snapshot.child('Name').value.toString(),
                      ),
                      subtitle: Text(
                        snapshot.child('Education').value.toString(),
                      ),
                      trailing: PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  child: ListTile(
                                onTap: () {
                                  showEditDailog(title, subtitle, id);
                                },
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                              )),
                              PopupMenuItem(
                                  child: ListTile(
                                onTap: () {
                                  showDeleteDailog(id);
                                },
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete'),
                              )),
                            ];
                          },
                          icon: const Icon(Icons.more_vert_sharp)),
                    );
                  } else if (title
                          .toLowerCase()
                          .toString()
                          .contains(__searchController.text.toLowerCase()) ||
                      subtitle.toLowerCase().toString().contains(
                          __searchController.text.toLowerCase().toString())) {
                    return ListTile(
                      title: Text(
                        snapshot.child('Name').value.toString(),
                      ),
                      subtitle: Text(
                        snapshot.child('Education').value.toString(),
                      ),
                      trailing: PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  child: ListTile(
                                onTap: () {
                                  showEditDailog(title, subtitle, id);
                                },
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                              )),
                               PopupMenuItem(
                                  child: ListTile(
                                    onTap: () {
                                      showDeleteDailog(id);
                                    },
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                              )),
                            ];
                          },
                          icon: const Icon(Icons.more_vert_sharp)),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            // Expanded(
            //     child: StreamBuilder(
            //   stream: ref.onValue,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return const CircularProgressIndicator();
            //     } else {
            //       return ListView.builder(
            //         itemCount: snapshot.data!.snapshot.children.length,
            //         itemBuilder: (context, index) {
            //           Map<dynamic, dynamic> map =
            //               snapshot.data!.snapshot.value as dynamic;
            //           List<dynamic> list = [];
            //           list.clear();
            //           list = map.values.toList();
            //           return Text(list[index]['Education']);
            //         },
            //       );
            //     }
            //   },
            // ))
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
                    ref.child(id).update({
                      "Id": id,
                      "Name": _editnamecontroller.text.toString(),
                      "Education": _editEducationcontroller.text.toString(),
                    }).then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage("Update successfully", Colors.red, Colors.white);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));
                    }).onError((error, stackTrace){
                       Utils().toastMessage(error.toString(), Colors.red, Colors.white); 
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
          title: const Text('Do you want to delete ?',style: TextStyle(fontSize: 20),),
          actions: [
            RoundedElevatedButton(
              text: 'yes',
              ontap: () {
                ref.child(id).remove().then((value){
                  Utils().toastMessage("Delete Successfully", Colors.red, Colors.white);
                  Navigator.push(context,MaterialPageRoute(builder: (context) => const HomeScreen(),));
                });
              },
            ),
            const SizedBox(height: 10,),
            const RoundedElevatedButton(
              text: 'no',
            ),
          ],
        );
      },
    );
  }
}
