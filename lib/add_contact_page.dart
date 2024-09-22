import 'package:flutter/material.dart';
import 'contact.dart';

class AddContactPage extends StatefulWidget {
  final Contact? contact;

  AddContactPage({this.contact});

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      nameController.text = widget.contact!.name;
      phoneController.text = widget.contact!.phone;
      emailController.text = widget.contact!.email;
      addressController.text = widget.contact!.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.contact == null ? 'Tambahkan Kontak' : 'Perbarui Kontak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Nomor HP'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    addressController.text.isNotEmpty) {
                  final newContact = Contact(
                    id: widget.contact?.id,
                    name: nameController.text,
                    phone: phoneController.text,
                    email: emailController.text,
                    address: addressController.text,
                  );
                  Navigator.of(context).pop(newContact);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Semua field wajib diisi')));
                }
              },
              child: Text(widget.contact == null
                  ? 'Tambahkan Kontak'
                  : 'Perbarui Kontak'),
            ),
          ],
        ),
      ),
    );
  }
}
