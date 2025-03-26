import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/read%20data/read_menutransaction.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetMoreDetailTransaction extends StatelessWidget {
  final String docId;

  GetMoreDetailTransaction({required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Transaksi",
            style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<String>>(
              future: getDocIds(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily)));
                } else {
                  List<String> docIds = snapshot.data ?? [];
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: docIds.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2.0,
                        child: ListTile(
                          title: GetMenuTransactions(
                            docId: docId,
                            docIds: docIds[index],
                          ), // Pass category information
                        ),
                      );
                    },
                  );
                }
              },
            ),
            Divider(
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            FutureBuilder<DocumentSnapshot>(
              future: getTransactionDetail(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily)));
                } else {
                  var data = snapshot.data?.data() as Map<String, dynamic>;
                  return Card(
                    child: ListTile(
                      title: Text("Total Harga",
                          style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily)),
                      trailing: Text("${data['total']}",
                          style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily)),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> getDocIds() async {
    CollectionReference menu = FirebaseFirestore.instance
        .collection('DetailTransaksi')
        .doc(docId)
        .collection('menu');
    QuerySnapshot snapshot = await menu.get();
    List<String> docIds = [];
    snapshot.docs.forEach((doc) {
      docIds.add(doc.id);
    });
    return docIds;
  }

  Future<DocumentSnapshot> getTransactionDetail() async {
    return await FirebaseFirestore.instance
        .collection('DetailTransaksi')
        .doc(docId)
        .get();
  }
}
