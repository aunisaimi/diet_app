import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Uint8List? _image;
  final imagePicker = ImagePicker();
  String dropdownvalue = "Male";
  bool obscureText = true;
  String? _selectHeight;
  String? _selectWeight;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _genderController = TextEditingController();

  String profilePicture = '';

  Future<void> uploadImageAndSave() async {
    try {
      final user =_auth.currentUser;
      if(user == null){
        return;
      }
      final profile = 'profile_pictures/${user.uid}.png';

      // upload image to cloud storage
      final UploadTask task = _storage.ref().child(profile).putData(_image!);

      // get the download url of the uploaded image
      final TaskSnapshot snapshot = await task;
      final imageUrl = await snapshot.ref.getDownloadURL();

      // update user's firestore doc with the image url
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profilePicture': imageUrl});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture uploaded and updated.'),
        ),
      );
    }
    catch (e){
      print('Error uploading image: $e');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await imagePicker.pickImage(source: source);
    if(pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _image = Uint8List.fromList(imageBytes);
      });
    }
    else {
      print('Image source not found');
    }
  }

  List<String> generateWeightRange(int start, int end, int step){
    List<String> range =[];
    for(int i = start; i<=end; i+=step){
      range.add("$i kg");
    }
    return range;
  }

  List<String> generateHeightRange(int start, int end, int step){
    List<String> range =[];
    for(int i = start; i<=end; i+=step){
      range.add("$i cm");
    }
    return range;
  }

  @override
  void initState(){
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try{
      //get current user id
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // fetch users document from firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if(userDoc.exists){
        // Extract and set user data to the respective TextEditingController
        setState(() {
          _emailController.text = userDoc['email'];
          profilePicture = userDoc['profilePicture'];
          dropdownvalue = userDoc['gender'] ?? "Male";
          _selectHeight = userDoc['height'];
          _selectWeight = userDoc['weight'];

        });
        print("this is current email: ${userDoc['email']}");
        print("this is current profile picture: ${userDoc['profilePicture']}");
      }
    } catch (e){
      print(e);
    }
  }

  Future<void> updateUserData() async {
    try{
      // get current user id
      final userId = FirebaseAuth.instance.currentUser!.uid;
      print("This is image picture: ${_image}");

      //update user doc in firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'email': _emailController.text,
        'profilePicture': profilePicture,
        'gender': dropdownvalue,
        'height': _selectHeight ?? 'Not specified',
        'weight': _selectWeight ?? 'Not specified',
      });
    } catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> weightRange = generateWeightRange(45, 250, 1);
    List<String> heightRange = generateHeightRange(145, 200, 1);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
              color: TColor.white,
              fontSize: 23,
              fontWeight: FontWeight.w700),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  _image != null ? CircleAvatar(
                    radius: 60,
                    backgroundImage: MemoryImage(_image!),
                  )
                      : (profilePicture != null && profilePicture.isNotEmpty
                      ? CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(profilePicture!),
                  )
                      : const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/logo.png"),
                  )),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: (){
                        pickImage(ImageSource.gallery);
                      },
                      icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.teal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),

              TextField(
                controller: _emailController,
                style: TextStyle(
                    color: TColor.primaryColor1,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.teal)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.cyan.shade700),
                  ),
                  labelText: "Email",
                  labelStyle: TextStyle(
                      color: TColor.primaryColor1,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),

              const SizedBox(height: 20,),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 1.0), // Add border styling
                  borderRadius: BorderRadius.circular(8.0),
                  // Add border radius for rounded corners
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        dropdownvalue,
                        style: TextStyle(
                            color: TColor.primaryColor1,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 20,),

                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.teal,
                      ),
                      offset: const Offset(0, 50),
                      itemBuilder: (BuildContext context){
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'Male',
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Male',
                                style: TextStyle(
                                    color: TColor.primaryColor1,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Female',
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Female',
                                style: TextStyle(
                                    color: TColor.primaryColor1,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ];
                      },
                      onSelected: (String value){
                        setState(() {
                          dropdownvalue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectHeight,
                      onChanged: (newValue){
                        setState(() {
                          _selectHeight = newValue;
                        });
                      },
                      items: heightRange.map((String value){
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Height',
                        hintStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TColor.primaryColor1
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fillColor: Colors.white70,
                        filled: true,
                      ),
                    ),

                    const SizedBox(height: 20,),

                    DropdownButtonFormField<String>(
                      value: _selectWeight,
                      onChanged: (newValue){
                        setState(() {
                          _selectWeight = newValue;
                        });
                      },
                      items: weightRange.map((String value){
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Weight',
                        hintStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TColor.primaryColor1
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.white70,
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primaryColor1,
                    elevation: 10,
                    shape: const StadiumBorder()
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if(_emailController.text.isNotEmpty){
                    updateUserData();
                    await uploadImageAndSave();
                    Navigator.pop(context,true);
                  }
                  else {
                    Navigator.pop(context, false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}
