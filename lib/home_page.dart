import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'add_contact_page.dart';
import 'contact.dart';
import 'contact_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final data = await DatabaseHelper().getContacts();
    setState(() {
      contacts = data.map((item) => Contact.fromMap(item)).toList();
    });
  }

  void _addContact(Contact contact) async {
    await DatabaseHelper().insertContact(contact.toMap());
    _loadContacts();
  }

  void _editContact(Contact contact) async {
    await DatabaseHelper().updateContact(contact.toMap());
    _loadContacts();
  }

  void _deleteContact(int id) async {
    await DatabaseHelper().deleteContact(id);
    _loadContacts();
  }

  Future<void> _confirmDelete(int contactId, String name) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Yakin mau menghapus kontak $name?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Pilih 'Tidak'
              },
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Pilih 'Ya'
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );

    // Jika pengguna memilih 'Ya', hapus kontak
    if (shouldDelete == true) {
      _deleteContact(contactId);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kontak $name berhasil dihapus')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: contacts.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final newContact = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AddContactPage()),
                );
                if (newContact != null) {
                  _addContact(newContact);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Kontak ${newContact.name} berhasil disimpan')));
                }
              },
              child: Icon(Icons.add),
              tooltip: 'Tambahkan kontak',
            ),
      appBar: AppBar(
        title: Text('List Kontak'),
      ),
      body: contacts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.contact_page, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Belum ada kontak, silahkan tambahkan kontak',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final newContact = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AddContactPage()),
                      );
                      if (newContact != null) {
                        _addContact(newContact);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Kontak ${newContact.name} berhasil disimpan')));
                      }
                    },
                    icon: Icon(Icons.add),
                    label: Text('Tambah Kontak'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ContactDetailPage(contact: contact),
                      ),
                    );
                  },
                  title: Text(contact.name),
                  subtitle: Text(contact.phone),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final editedContact =
                              await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddContactPage(contact: contact),
                            ),
                          );
                          if (editedContact != null) {
                            _editContact(editedContact);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Kontak ${editedContact.name} Berhasil diperbarui')));
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _confirmDelete(contact.id!, contact.name);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
