import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({super.key});

  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final _namamenuController = TextEditingController();
  final _hargamenuController = TextEditingController();
  String _selectedCategory = 'Pilih';
  File? _selectedImage;
  String? _imageName;

  @override
  void dispose() {
    _namamenuController.dispose();
    _hargamenuController.dispose();
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

  Future<void> _addMenu() async {
    final namamenu = _namamenuController.text.trim();
    final hargamenu = _hargamenuController.text.trim();
    if (namamenu.isEmpty || hargamenu.isEmpty) {
      return;
    }
    try {
      if (_selectedImage != null && _imageName != null) {
        await _saveImageToLocalAssets(_selectedImage!, _imageName!);
      }

      final CollectionReference menu =
          FirebaseFirestore.instance.collection('menu');
      await menu.add({
        'namamenu': namamenu,
        'harga': hargamenu,
        'kategori': _selectedCategory,
        'gambar': _imageName,
      });

      _namamenuController.clear();
      _hargamenuController.clear();
      setState(() {
        _selectedImage = null;
        _imageName = null;
      });

      _showSuccessPopup();
    } catch (e) {
      print('Error adding menu: $e');
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
    const MethodChannel('plugins.flutter.io/path_provider')
        .invokeMethod('refreshAssets');
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success',
              style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
          content: Text('Data menu Berhasil Ditambah',
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
        title: Text("Tambah Menu",
            style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            ),
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
              child: TextField(
                controller: _namamenuController,
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
                  hintText: ('Nama Menu'),
                  hintStyle: TextStyle(
                    color: Color(0xFF707070),
                  ),
                ),
              ),
            ),
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
              child: TextField(
                controller: _hargamenuController,
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
                  hintText: ('Harga'),
                  hintStyle: TextStyle(
                    color: Color(0xFF707070),
                  ),
                ),
              ),
            ),
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
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Kategori',
                        style: TextStyle(
                            color: Color(0xFF707070),
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily)),
                    const SizedBox(width: 190),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCategory = value!;
                          //Handle filtering based on the selected category
                          print('Selected Category: $_selectedCategory');
                        });
                      },
                      items: ['Pilih', 'Makanan', 'Minuman']
                          .map((String kategori) {
                        return DropdownMenuItem<String>(
                          value: kategori,
                          child: Text(kategori,
                              style: TextStyle(
                                  fontFamily:GoogleFonts.poppins().fontFamily)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
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
                    const SizedBox(width: 220),
                    ElevatedButton(
                      onPressed: _pickImageFromGallery,
                      child: Text(
                        'Pilih',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: GoogleFonts.poppins().fontFamily),
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
            const SizedBox(height: 70),
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
                onPressed: _addMenu,
                child: Text('Tambah Menu',
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
