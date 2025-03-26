import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class AddWarungPage extends StatefulWidget {
  const AddWarungPage({Key? key}) : super(key: key);
  @override
  State<AddWarungPage> createState() => _AddWarungPageState();
}

class _AddWarungPageState extends State<AddWarungPage> {
  final _namawarungController = TextEditingController();
  final _alamatwarungController = TextEditingController();
  final _kontakController = TextEditingController();
  File? _selectedImage;
  String? _imageName;

  @override
  void dispose() {
    _namawarungController.dispose();
    _alamatwarungController.dispose();
    _kontakController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;
    setState(() {
      _selectedImage = File(pickedImage.path);
      _imageName = _selectedImage!.path.split('/').last;
    });
  }

  Future<void> _saveImageToFirebaseStorage(
      File imageFile, String imageName) async {
    final storage = FirebaseStorage.instance;
    final Reference storageReference =
        storage.ref().child('warung_images/$imageName');

    try {
      await storageReference.putFile(imageFile);
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  Future<void> _addWarung() async {
    final namawarung = _namawarungController.text.trim();
    final alamatwarung = _alamatwarungController.text.trim();
    final kontak = _kontakController.text.trim();

    if (namawarung.isEmpty || alamatwarung.isEmpty || kontak.isEmpty) {
      return;
    }

    try {
      if (_selectedImage != null && _imageName != null) {
        await _saveImageToFirebaseStorage(_selectedImage!, _imageName!);
      }

      final CollectionReference warungCollection =
          FirebaseFirestore.instance.collection('warung');

      // Extracting the part after the dot and converting to lowercase
      final formattedAlamat = alamatwarung.split('.').last.toLowerCase();

      final DocumentReference warungDocRef = await warungCollection.add({
        'namawarung': namawarung,
        'alamatwarung': alamatwarung,
        'kontak': kontak,
        'gambar': _imageName,
      });

      // Add a subcollection called "meja" under the created "warung" document
      final CollectionReference mejaCollection =
          warungDocRef.collection('meja');

      // Add documents with IDs ranging from A1 to A12
      for (int i = 1; i <= 12; i++) {
        await mejaCollection.add({
          'idmeja': '${formattedAlamat}A$i',
          'kodemeja': 'A$i',
          'tipe': 'Meja Kursi',
          // Add other meja-related fields as needed
        });
      }

      for (int i = 13; i <= 20; i++) {
        await mejaCollection.add({
          'idmeja': '${formattedAlamat}A$i',
          'kodemeja': 'A$i',
          'tipe': 'Lesehan',
        });
      }

      // Add documents with IDs ranging from B1 to B25
      for (int i = 1; i <= 25; i++) {
        await mejaCollection.add({
          'idmeja': '${formattedAlamat}B$i',
          'kodemeja': 'B$i',
        });
      }

      _namawarungController.clear();
      _alamatwarungController.clear();
      _kontakController.clear();
      setState(() {
        _selectedImage = null;
        _imageName = null;
      });

      _showSuccessPopup();
    } catch (e) {
      print('Error adding warung: $e');
    }
  }

  Future<void> _saveImageToLocalAssets(File imageFile, String imageName) async {
    final appDir = await getApplicationDocumentsDirectory();
    final localPath = '${appDir.path}/$imageName';
    final localFile = File(localPath);

    await localFile.writeAsBytes(await imageFile.readAsBytes());
    await _updateAssets();
  }

  Future<void> _updateAssets() async {
    const MethodChannel('plugins.flutter.io/path_provider').invokeMethod(
        'refreshAssets'); //invoke method untuk manggil method nah disini tu asset nya (gambar)
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success',
              style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
          content: Text('Data Warung Berhasil Ditambah',
              style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK',
                  style:
                      TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Warung",
            style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 30),
            Container(
              decoration: ShapeDecoration(
                color: Color(0xFFC4C8D5),
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
            const SizedBox(height: 30),
            Container(
              decoration: ShapeDecoration(
                color: Color(0xFFC4C8D5),
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
            const SizedBox(height: 30),
            Container(
              decoration: ShapeDecoration(
                color: Color(0xFFC4C8D5),
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
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Gambar',
                        style: TextStyle(
                            color: Color(0xFF707070),
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily)),
                    SizedBox(width: 220),
                    ElevatedButton(
                      onPressed: _pickImageFromGallery,
                      child: Text('Pilih',
                          style: TextStyle(
                              color: Color(0xFF707070),
                              fontFamily: GoogleFonts.poppins().fontFamily)),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFC4C8D5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _selectedImage != null
                ? Image.file(_selectedImage!)
                : SizedBox.shrink(),
            const SizedBox(height: 30),
            Container(
              width: 386,
              height: 49,
              decoration: ShapeDecoration(
                color: Color(0xFFC4C8D5),
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
              child: ElevatedButton(
                onPressed: _addWarung,
                child: Text('Tambah Warung',
                    style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily)),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFC4C8D5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
