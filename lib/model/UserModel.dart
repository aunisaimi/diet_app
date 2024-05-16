
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String fname;
  String lname;
  String height;
  String weight;
  String profilePicture;
  String email;
  //String bio;
  //String coverImage;

  UserModel({
    required this.uid,
    required this.fname,
    required this.lname,
    required this.height,
    required this.weight,
    required this.profilePicture,
    required this.email,
    //required this.bio,
    //required this.coverImage,
});

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
      uid:doc.id,
      fname:doc.get('fname'),
      lname:doc.get('lname'),
      email:doc.get('email'),
      height:doc.get('height'),
      weight: doc.get('weight'),
      profilePicture:doc.get('profilePicture'),
      //bio:doc.get('bio'),
      //coverImage:doc.get('coverImage'),
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'uid': uid,
      'fname': fname,
      'lname': lname,
      'email': email,
      'height': height,
      'weight': weight,
      'profilePicture': profilePicture,
    };
  }
}