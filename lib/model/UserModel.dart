
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String profilePicture;
  String email;
  String bio;
  String coverImage;

  UserModel({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.email,
    required this.bio,
    required this.coverImage,
});

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
      id:doc.id,
      name:doc.get('name'),
      email:doc.get('email'),
      profilePicture:doc.get('profilePicture'),
      bio:doc.get('bio'),
      coverImage:doc.get('coverImage'),
    );
  }
}