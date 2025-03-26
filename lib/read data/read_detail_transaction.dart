import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'read_moredetail_transaction.dart';
import 'package:google_fonts/google_fonts.dart';

class GetDetailTransaction extends StatelessWidget {
  final String documentId;

  GetDetailTransaction({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference detail =
        FirebaseFirestore.instance.collection('DetailTransaksi');

    String capitalizeFirstOfEach(String input) {
      if (input.isEmpty) {
        return input;
      }

      return input
          .toLowerCase()
          .split(' ')
          .map((word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1)
              : '')
          .join(' ');
    }

    return FutureBuilder(
      future: detail.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> detailData =
              snapshot.data!.data() as Map<String, dynamic>;

          return InkWell(
            child: Card(
              elevation: 2.0,
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            DateFormat('dd MMMM yyyy')
                                .format(detailData['tanggal'].toDate()),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.poppins().fontFamily),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF3F5584).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "Status:${detailData['status']}",
                            style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    // Add line
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    // Tambah di bawah
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${detailData['warung']}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, fontFamily: GoogleFonts.poppins().fontFamily),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Shift: ${detailData['shift']} Total: ${detailData['total']} Kode Meja: ${detailData['kodemeja']}",
                            style: TextStyle(fontSize: 10, color: Colors.black, fontFamily: GoogleFonts.poppins().fontFamily),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${capitalizeFirstOfEach(detailData['metodepembayaran'])}",
                            style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: GoogleFonts.poppins().fontFamily),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GetMoreDetailTransaction(
                                            docId: documentId)));
                          },
                          child: Text(
                            'Detail Transaksi',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                      ],
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
}
