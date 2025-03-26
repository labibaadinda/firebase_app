import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'edit_page.dart'; // Import the edit page if not already imported
import 'package:google_fonts/google_fonts.dart';

class GetWarung extends StatelessWidget {
  //karna gaada yang dimasukin data gt, cuman di baca aja jadinya pake nya stateless
  final String documentId;

  GetWarung({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference warung =
        FirebaseFirestore.instance.collection('warung');
    return FutureBuilder(
      future: warung.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return InkWell(
            child: Card(
              elevation: 2.0,
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: _getImageUrl(data['gambar']),
                      builder: (context, imageSnapshot) {
                        if (imageSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (imageSnapshot.hasError) {
                          return Text('Error: ${imageSnapshot.error}',
                              style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.poppins().fontFamily));
                        }
                        return Image.network(
                          imageSnapshot.data.toString(),
                          width: 150,
                          height: 150,
                        );
                      },
                    ),
                    SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${data['namawarung']}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.poppins().fontFamily),
                          ),
                          Text(
                            "${data['alamatwarung']}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.poppins().fontFamily),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => _editDetails(context),
                                child: Text('Edit',
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily)),
                              ),
                              ElevatedButton(
                                onPressed: () => _deleteWarung(context),
                                child: Text('Delete',
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }

  Future<String> _getImageUrl(String imageName) async {
    var storageRef =
        FirebaseStorage.instance.ref().child('warung_images/$imageName');
    return await storageRef.getDownloadURL();
  }

  void _editDetails(BuildContext context) {
    // Navigate to the edit page, you should replace EditPage with your actual edit page.
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditPage(documentId: documentId)));
  }

  void _deleteWarung(BuildContext context) async {
    // Show a confirmation dialog before deleting
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus Warung',
              style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
          content: Text('Yakin Menghapus Warung?',
              style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No
              },
              child: Text('Tidak',
                  style:
                      TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes
              },
              child: Text('Ya',
                  style:
                      TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // Delete the warung and its subcollection 'meja'
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Delete documents in 'meja' subcollection
      QuerySnapshot mejaSnapshot = await FirebaseFirestore.instance
          .collection('warung')
          .doc(documentId)
          .collection('meja')
          .get();

      mejaSnapshot.docs.forEach((mejaDoc) {
        batch.delete(mejaDoc.reference);
      });

      // Delete the 'warung' document
      batch.delete(
          FirebaseFirestore.instance.collection('warung').doc(documentId));

      // Commit the batch
      await batch.commit();

      // Show a delete successful popup
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Warung berhasil dihapus',
              style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
