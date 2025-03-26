import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class EditMenu extends StatefulWidget {
  final String documentId;

  const EditMenu({required this.documentId, Key? key}) : super(key: key);

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  final _namamenuController = TextEditingController();
  final _hargaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('menu').doc(widget.documentId).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    _namamenuController.text = data['namamenu'] ?? '';
    _hargaController.text = data['harga'] ?? '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Warmindo Edit Menu", style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
      ),
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
                  controller: _namamenuController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Nama Menu', 
                    hintText: 'Masukkan Nama Menu',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
                  controller: _hargaController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Harga',
                    hintText: 'Masukkan Harga',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('menu').doc(widget.documentId).update({
                    'namamenu': _namamenuController.text,
                    'harga': _hargaController.text,
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