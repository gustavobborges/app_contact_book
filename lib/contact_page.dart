import 'package:contacts/utils/contact.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import "package:image_picker/image_picker.dart";
//01h04min

class ContactPage extends StatefulWidget {
  final Contact contact;
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _edited = false;
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _editedContact = widget.contact;
      _nameController.text = _editedContact.name;
      _phoneController.text = _editedContact.phone;
      _emailController.text = _editedContact.email;
    } else {
      _editedContact = Contact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            _editedContact.name != null && _editedContact.name.isNotEmpty
                ? _editedContact.name
                : "Novo Contato",
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.save),
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.camera)
                    .then((file) {
                      if (file == null) return;
                      setState(() {
                        _editedContact.img = file.path;
                      });
                      _edited = true;
                    });
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedContact.img != null
                          ? FileImage(File(_editedContact.img))
                          : AssetImage("images/default.png"),
                    ),
                  ),
                ),
              ),
              TextField(
                focusNode: _nameFocus,
                keyboardType: TextInputType.name,
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                ),
                onChanged: (text) {
                  _edited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone",
                ),
                onChanged: (text) {
                  _edited = true;
                  setState(() {
                    _editedContact.phone = text;
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                onChanged: (text) {
                  _edited = true;
                  setState(() {
                    _editedContact.email = text;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_edited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.green,
              buttonPadding: EdgeInsets.all(10),
              title: Text(
                "Descartar Alterações",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Text(
                "Se sair, as alterações serão perdidas",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: [
                FlatButton(
                  minWidth: 100,
                  child: Icon(
                    Icons.check_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  minWidth: 100,
                  child: Icon(
                    Icons.cancel_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
          return Future.value(true);
    }
    Navigator.pop(context);
    return Future.value(true);
  }
}
