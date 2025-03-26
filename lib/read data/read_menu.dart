import 'package:cloud_firestore/cloud_firestore.dart'; //simpan di
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'edit_menu.dart';
import 'package:google_fonts/google_fonts.dart';

class GetMenuDetail extends StatefulWidget {
  //
  final String docId;

  GetMenuDetail({required this.docId, required Null Function() onDelete});

  @override
  State<GetMenuDetail> createState() => _GetMenuDetailState();
}

class _GetMenuDetailState extends State<GetMenuDetail> {
  @override
  Widget build(BuildContext context) {
    CollectionReference menu = FirebaseFirestore.instance.collection('menu');
    return FutureBuilder(
      future: menu.doc(widget.docId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic>? menuData =
              snapshot.data!.data() as Map<String, dynamic>?;

          if (menuData != null) {
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(menuData['namamenu'] ?? '',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily)),
                          ),
                          Center(
                            child: FutureBuilder(
                              //komponen untuk mangggil data
                              future: _getImageUrl(menuData['gambar']),
                              builder: (context, imageSnapshot) {
                                if (imageSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (imageSnapshot.hasError) {
                                  return Text('Error: ${imageSnapshot.error}');
                                }
                                return Image.network(
                                  imageSnapshot.data.toString(),
                                  width: 75,
                                  height: 75,
                                );
                              },
                            ),
                          ),
                          Center(
                            child: Text(menuData['harga']?.toString() ?? '',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily)),
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _editMenu(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                child: Text('Edit',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily)),
                              ),
                              SizedBox(width: 1.0),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Konfirmasi',
                                            style: TextStyle(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily)),
                                        content: Text(
                                            'Apakah anda yakin ingin menghapus menu ini?'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Batal',
                                                style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily)),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await menu
                                                  .doc(widget.docId)
                                                  .delete();
                                              Navigator.pop(context,
                                                  true); // Signal deletion
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                            ),
                                            child: Text('Hapus',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.0),
                                ),
                                child: Text('Hapus',
                                    style: TextStyle(
                                        fontSize: 12,
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
            );
          } else {
            // Handle the case where menuData is null
            return Text('Menu data is null',
                style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily));
          }
        } else {
          // Handle other connection states
          return CircularProgressIndicator();
        }
      }),
    );
  }

  Future<dynamic> _getImageUrl(String image) async {
    final ref = FirebaseStorage.instance.ref().child('menu_images/$image');
    var url = await ref.getDownloadURL();
    return url;
  }

  void _editMenu(BuildContext context) {
    // Navigate to the edit page, you should replace EditPage with your actual edit page.
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditMenu(documentId: widget.docId)),
    );
  }
}
