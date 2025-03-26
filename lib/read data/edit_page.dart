import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPage extends StatefulWidget {
  final String documentId;

  const EditPage({required this.documentId, Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _namawarungController = TextEditingController();
  final _alamatwarungController = TextEditingController();
  final _kontakController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('warung').doc(widget.documentId).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    _namawarungController.text = data['namawarung'] ?? '';
    _alamatwarungController.text = data['alamatwarung'] ?? '';
    _kontakController.text = data['kontak'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Warmindo Edit Menu", style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: const Color(0xFFC4C8D5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: TextField(
                  controller: _namawarungController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0xFFC4C8D5),
                    hintText: 'Nama Warung',
                    hintStyle: TextStyle(
                      color: Color(0xFF707070),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                decoration: ShapeDecoration(
                  color: const Color(0xFFC4C8D5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: TextField(
                  controller: _alamatwarungController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0xFFC4C8D5),
                    hintText: 'Alamat Warung',
                    hintStyle: TextStyle(
                      color: Color(0xFF707070),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                decoration: ShapeDecoration(
                  color: const Color(0xFFC4C8D5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: TextField(
                  controller: _kontakController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0xFFC4C8D5),
                    hintText: 'Kontak',
                    hintStyle: TextStyle(
                      color: Color(0xFF707070),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('warung').doc(widget.documentId).update({
                    'namawarung': _namawarungController.text,
                    'alamatwarung': _alamatwarungController.text,
                    'kontak': _kontakController.text,
                  });

                  // Navigate back to the previous screen
                  Navigator.pop(context);

                  // Show a SnackBar for success
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Edit Berhasil', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text('Update', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
