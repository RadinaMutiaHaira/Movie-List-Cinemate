import 'package:flutflix/screen/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutflix/services/firebase_auth_services.dart';

class ProfilePage extends StatefulWidget {
  final User? user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mendapatkan data pengguna dari Firestore saat halaman diinisialisasi
    _getUserData();
  }

  Future<void> _getUserData() async {
    if (widget.user != null) {
      // Panggil fungsi untuk mendapatkan data dari Firestore menggunakan uid pengguna
      Map<String, dynamic>? data = await FirebaseAuthService()
          .getUserDataFromFirestore(widget.user!.uid);

      // Perbarui state dengan data yang diperoleh
      setState(() {
        userData = data;
      });
    }
  }

  Widget _buildProfileField(String label, String value) {
    Icon getIcon(String label) {
      switch (label.toLowerCase()) {
        case 'nama':
          return Icon(Icons.person);
        case 'email':
          return Icon(Icons.email);
        case 'nomor telepon':
          return Icon(Icons.phone);
        case 'negara':
          return Icon(Icons.location_on);
        default:
          return Icon(Icons.person);
      }
    }

    return Container(
      margin: EdgeInsets.all(8),
      child: TextField(
        controller: TextEditingController(text: value),
        enabled: false,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 18),
          contentPadding: EdgeInsets.all(16),
          prefixIcon: getIcon(label),
          hintText: value,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProfileField('Nama', userData?['name'] ?? 'Nama Anda'),
          SizedBox(height: 8),
          _buildProfileField('Email', widget.user?.email ?? 'Email Anda'),
          SizedBox(height: 8),
          _buildProfileField('Nomor Telepon',
              userData?['phoneNumber'] ?? 'Nomor Telepon Anda'),
          SizedBox(height: 8),
          _buildProfileField('Negara', userData?['country'] ?? 'Negara Anda'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            child: Text('Logout'),
          ),
        ],
      )),
    );
  }
}
