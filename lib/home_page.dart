import 'package:contacts/contact_page.dart';
import 'package:contacts/utils/contact.dart';
import 'package:contacts/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Contact> _contacts = [];
  ContactUtils utils = ContactUtils();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          _showContact();
        },
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: _contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showContact(contact: _contacts[index]);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _contacts[index].img != null
                        ? FileImage(File(_contacts[index].img))
                        : AssetImage("images/default.png"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textDefault(_contacts[index].name, true),
                    textDefault(_contacts[index].email, false),
                    textDefault(_contacts[index].phone, false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getAllContacts() {
    utils.getAll().then((value) {
      setState(() {
        _contacts = value;
      });
    });
  }

  void _showContact({Contact contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(contact: contact),
      ),
    );

    if (recContact != null) {
      if (contact != null) {
        await utils.update(recContact);
      } else {
        await utils.save(recContact);
      }
    }

    _getAllContacts();
  }
}
