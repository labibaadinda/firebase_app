import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hi ${data['first name']} !!", style: TextStyle(fontSize: 20, fontFamily: GoogleFonts.poppins().fontFamily)),
                        Text(data['asal'], style: TextStyle(fontSize: 20, fontFamily: GoogleFonts.poppins().fontFamily)),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: _getImageUrl(data['profile picture']),
                    builder: (context, imageSnapshot) {
                      if (imageSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (imageSnapshot.hasError) {
                        return Text('Error: ${imageSnapshot.error}', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily));
                      }
              
                      return ClipOval(
                        child: Image.network(
                          imageSnapshot.data.toString(),
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover, // Ensure the image covers the oval shape
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          }
          return Text("loading", style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily));
        }));
  }

  Future<String> _getImageUrl(String imageName) async {
    var storageRef = FirebaseStorage.instance.ref().child('user/$imageName');
    return await storageRef.getDownloadURL();
  }
}
