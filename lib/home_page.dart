import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'read data/read_warung.dart';
import 'addmenu.dart';
import 'addwarung.dart';
import 'read data/read_detail_transaction.dart';
import 'read data/read_user_name.dart';
import 'MenuPage.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  DateTime selectedDate = DateTime.now();
  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Warmindo Home Page",
            style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 2,
                            color: Colors.white.withOpacity(0.8),
                            child: FutureBuilder(
                              future: getUser(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}',
                                      style: TextStyle(
                                          fontFamily: GoogleFonts.poppins()
                                              .fontFamily));
                                } else {
                                  String user = snapshot.data as String;
                                  return GetUserName(documentId: user);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white.withOpacity(0.8),
                                  onPrimary: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddWarungPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Tambah Warung',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white.withOpacity(0.8),
                                  onPrimary: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddMenuPage(),
                                    ),
                                  );
                                },
                                child: Text('Tambah Menu',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily)),
                              ),
                              SizedBox(width: 8.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white.withOpacity(0.8),
                                  onPrimary: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const GetMenuPage(),
                                    ),
                                  );
                                },
                                child: Text('List Menu',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Text('List Warung',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily),
                  textAlign: TextAlign.left),
            ),
            FutureBuilder<List<String>>(
              future: getDocIds(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                      style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily));
                } else {
                  List<String> docIds = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: docIds.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: GetWarung(documentId: docIds[index]),
                      );
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.only(left: 28.0),
              child: Text('Detail Transaksi',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2025),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text('Pilih Tanggal'),
                  ),
                  Text(
                    'Tanggal: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                ],
              ),
            ),
            FutureBuilder<List<String>>(
              future: getDetailTransaksi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                      style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily));
                } else {
                  if (isSameDay(selectedDate, currentDate)) {
                    List<String> detailTrans = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: detailTrans.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          child: ListTile(
                            title: GetDetailTransaction(
                              documentId: detailTrans[index],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return FutureBuilder<List<String>>(
                      future: getDetailTransaksiFiltered(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}',
                              style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.poppins().fontFamily));
                        } else {
                          List<String> detailTrans = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: detailTrans.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 2.0,
                                child: ListTile(
                                  title: GetDetailTransaction(
                                    documentId: detailTrans[index],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> getDocIds() async {
    List<String> docIds = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('warung').get();
    querySnapshot.docs.forEach((document) {
      docIds.add(document.reference.id);
    });
    return docIds;
  }

  Future<List<String>> getDetailTransaksi() async {
    List<String> detailTrans = [];

    // Fetch and sort the documents based on the "tanggal" field
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('DetailTransaksi')
        .orderBy('tanggal', descending: true)
        .get();

    querySnapshot.docs.forEach((document) {
      detailTrans.add(document.reference.id);
    });

    return detailTrans;
  }

  Future<List<String>> getDetailTransaksiFiltered() async {
    List<String> detailTrans = [];

    // Fetch and sort the documents based on the "tanggal" field
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('DetailTransaksi')
        .orderBy('tanggal', descending: true)
        .get();

    querySnapshot.docs.forEach((document) {
      // Retrieve the Firestore Timestamp
      Timestamp timestamp = document['tanggal'];

      // Convert the Firestore Timestamp to a DateTime
      DateTime timestampDate = timestamp.toDate();

      // Check if the date part of the timestamp matches the selectedDate
      if (isSameDay(timestampDate, selectedDate)) {
        detailTrans.add(document.reference.id);
      }
    });

    return detailTrans;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<String> getUser() async {
    String user = '';
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    querySnapshot.docs.forEach((document) {
      user = document.reference.id;
    });
    return user;
  }
}
