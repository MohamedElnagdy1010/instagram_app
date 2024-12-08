// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/firebase_services/firestore.dart';
import 'package:instagram_app/provider/user_provider.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:instagram_app/shared/contants.dart';
import 'package:instagram_app/shared/snackbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CommentsScreen extends StatefulWidget {
  final Map data;
  bool showTextField = true;
   CommentsScreen({super.key, required this.data,required this.showTextField});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Comments"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('postSSS')
                  .doc(widget.data["postId"])
                  .collection("commentSSS")
                  .orderBy("datepulished")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(
                    color: Colors.white,
                  );
                }

                return Expanded(
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(125, 78, 91, 110),
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        data["profilepic"]
                                        //  "https://firebasestorage.googleapis.com/v0/b/instagram-app-1c120.appspot.com/o/profileIMG%2F46603321000064320.jpg?alt=media&token=98160212-1fe1-4693-93b1-d1eb6e74bac5"

                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(data["username"]),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(data["textcomment"]),
                                      ],
                                    ),
                                    Text(
                                      DateFormat('MMM d, ' 'y').format(
                                          data["datepulished"].toDate()),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.favorite))
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

          widget.  showTextField?
            Container(
              margin: EdgeInsets.symmetric( horizontal: 5,vertical: 10),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(125, 78, 91, 110),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(userData!.profileImg),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                        controller: commentController,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "commnt as ${userData.username} ",
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  await FirestoreMethods().Addcomment(
                                      commenttext: commentController.text,
                                      postId: widget.data["postId"],
                                      profileImg: userData.profileImg,
                                      username: userData.username,
                                      uid: userData.uid,
                                      context: context);
                                  commentController.clear();
                                },
                                icon: Icon(Icons.send)))),
                  ),
                ],
              ),
            ):Text("")
          ],
        ),
      ),
    );
  }
}
