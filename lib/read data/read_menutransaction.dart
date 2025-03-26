import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class GetMenuTransactions extends StatelessWidget {
  final String docId;
  final String docIds;

  GetMenuTransactions({required this.docId, required this.docIds});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMenuTransaction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily)));
          } else {
            Map<String, dynamic>? menuTransaction =
                snapshot.data as Map<String, dynamic>?;

            if (menuTransaction != null) {
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      FutureBuilder(
                        future: _getImageUrl(menuTransaction['gambar']),
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
                            width: 75,
                            height: 75,
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(menuTransaction['namamenu'] ?? '',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text("${menuTransaction['jumlah']}X ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily)),
                                Text(menuTransaction['harga'] ?? '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Text('No Data',
                  style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily));
            }
          }
        });
  }

  Future<Map<String, dynamic>> getMenuTransaction() async {
    Map<String, dynamic> menuTransaction = {};

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('DetailTransaksi')
          .doc(docId)
          .collection('menu')
          .doc(docIds)
          .get();

      if (documentSnapshot.exists) {
        menuTransaction = documentSnapshot.data() as Map<String, dynamic>;
      }
    } catch (error) {
      print('Error fetching menu transaction: $error');
    }

    return menuTransaction;
  }

  Future<String> _getImageUrl(String imageName) async {
    var storageRef =
        FirebaseStorage.instance.ref().child('menu_images/$imageName');
    return await storageRef.getDownloadURL();
  }
}
