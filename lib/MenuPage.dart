import 'package:flutter/material.dart';
import 'read data/read_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class GetMenuPage extends StatefulWidget {
  const GetMenuPage({Key? key}) : super(key: key);

  @override
  _GetMenuPageState createState() => _GetMenuPageState();
}

class _GetMenuPageState extends State<GetMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu", style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Makanan',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 20,
            thickness: 5,
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<List<String>>(
                future: getDocIdsMakanan(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)));
                  } else {
                    List<String> docIds = snapshot.data ?? [];
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: docIds.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          child: ListTile(
                            title: GetMenuDetail(
                              docId: docIds[index],
                              onDelete: () {
                                _reloadData();
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Minuman',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 20,
            thickness: 5,
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<List<String>>(
                future: getDocIdsMinuman(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)));
                  } else {
                    List<String> docIds = snapshot.data ?? [];
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: docIds.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          child: ListTile(
                            title: GetMenuDetail(
                              docId: docIds[index],
                              onDelete: () {
                                _reloadData();
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> getDocIdsMakanan() async {
    List<String> docIdsMakanan = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('menu')
        .where('kategori', isEqualTo: 'Makanan')
        .get();
    querySnapshot.docs.forEach((document) {
      docIdsMakanan.add(document.id);
    });
    return docIdsMakanan;
  }

  Future<List<String>> getDocIdsMinuman() async {
    List<String> docIdsMinuman = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('menu')
        .where('kategori', isEqualTo: 'Minuman')
        .get();
    querySnapshot.docs.forEach((document) {
      docIdsMinuman.add(document.id);
    });
    return docIdsMinuman;
  }

  void _reloadData() {
    setState(() {});
  }
}
