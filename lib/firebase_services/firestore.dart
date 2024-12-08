// ignore_for_file: avoid_print, unused_import, non_constant_identifier_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_app/firebase_services/storage.dart';
import 'package:instagram_app/models/post.dart';
import 'package:instagram_app/screens/add_post.dart';
import 'package:instagram_app/shared/snackbar.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  uploadPost(
      {required imgName,
      required imgPath,
      required description,
      required profileImg,
      required username,
      required context}) async {
    String message = "ERROR => Not starting the code";

    try {
// ______________________________________________________________________

      String urlll = await getImgURL(
          imgName: imgName,
          imgPath: imgPath,
          folderName: 'imgPosts/${FirebaseAuth.instance.currentUser!.uid}');

// _______________________________________________________________________
// firebase firestore (Database)
      CollectionReference posts =
          FirebaseFirestore.instance.collection('postSSS');

      String newId = const Uuid().v1();

      PostData postt = PostData(
          datePublished: DateTime.now(),
          description: description,
          imgPost: urlll,
          likes: [],
          profileImg: profileImg,
          postId: newId,
          uid: FirebaseAuth.instance.currentUser!.uid,
          username: username);

      message = "ERROR => erroe hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee";
      posts
          .doc(newId)
          .set(postt.convert2Map())
          .then((value) => print("done................"))
          .catchError((error) => print("Failed to post: $error"));

      message = " Posted successfully ♥ ♥";
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    } catch (e) {
      print(e);
    }

    showSnackBar(context, message);
  }

  Addcomment(
      {required commenttext,
      required postId,
      required profileImg,
      required username,
      required uid,
      required context}) async {
    if (commenttext.isNotEmpty) {
      String commentID = const Uuid().v1();
      await FirebaseFirestore.instance
          .collection("postSSS")
          .doc(postId)
          .collection("commentSSS")
          .doc(commentID)
          .set({
        "profilepic": profileImg,
        "username": username,
        "textcomment": commenttext,
        "datepulished": DateTime.now(),
        "uid": uid,
        "commentID": commentID,
      });
    } else {
      showSnackBar(context, "Please right your comment ☻•");
    }
  }

addLike({required Map  postData})async{
            
                      if (postData["likes"].contains(FirebaseAuth.instance.currentUser!.uid)) {
                          await FirebaseFirestore.instance
                            .collection("postSSS")
                            .doc(postData["postId"])
                            .update({
                          "likes": FieldValue.arrayRemove(
                              [FirebaseAuth.instance.currentUser!.uid])
                        });
                      } else {
                          await FirebaseFirestore.instance
                            .collection("postSSS")
                            .doc(postData["postId"])
                            .update({
                          "likes": FieldValue.arrayUnion(
                              [FirebaseAuth.instance.currentUser!.uid])
                        });
                      }
                      
                      

}

}
