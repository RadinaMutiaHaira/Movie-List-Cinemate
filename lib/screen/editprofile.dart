import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  // final String initialDisplayName;
  final String initialEmail;

  EditProfilePage({
    Key? key,
    // required this.initialDisplayName,
    required this.initialEmail,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values from the user's data passed from ProfilePage
    // _displayNameController.text = widget.initialDisplayName;
    _emailController.text = widget.initialEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _displayNameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk menyimpan perubahan data diri ke database atau penyimpanan data
                // Misalnya, Anda bisa menggunakan Firebase Firestore atau REST API.
                // Setelah itu, mungkin ingin kembali ke halaman profil atau halaman sebelumnya.
                Navigator.pop(context);
              },
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
