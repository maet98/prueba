import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/entities/user.dart';
import 'package:instagramclone/entities/userInfo.dart';

import 'dataFunctions.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  File _profileImage;
  String _imagePath;
  bool registerTrigger = false;
  ImagePicker _picker = ImagePicker();
  User newUser;

  @override
  void initState() {
    super.initState();
    downloadImage();
  }

  Future getImage(bool camera) async {
    PickedFile _image = await _picker.getImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500);
    setState(() {
      _imagePath = _image.path.toString();
      _profileImage = File(_image.path);
      print('Select image path' + _image.path.toString());
    });
  }

  Future downloadImage() async {
    if (_imagePath != null) {
      var image = new File(_imagePath);
      setState(() {
        _profileImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Form(
          key: _formKey,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: _profileImage == null
                                  ? NetworkImage(
                                      "https://smartprofile.io/wp-content/uploads/2017/04/Placeholder.png")
                                  : FileImage(_profileImage),
                              fit: BoxFit.fill)),
                    ),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              primary: Colors.lightBlue),
                          onPressed: () {
                            getImage(false);
                          },
                          child: Text('Subir imagen',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              primary: Colors.lightBlue),
                          onPressed: () {
                            getImage(true);
                          },
                          child: Text('Tomar una foto',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        )
                      ],
                    ))
                  ],
                ),
                Row(),
                Column(children: [
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _username,
                      validator: (username) {
                        if (username.isEmpty) {
                          return 'Digite un usuario';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _email,
                      validator: (username) {
                        if (username.isEmpty) {
                          return 'Digite un email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _firstName,
                      validator: (firstName) {
                        if (firstName.isEmpty) {
                          return 'Digite un nombre';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'First name',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _lastName,
                      validator: (lastName) {
                        if (lastName.isEmpty) {
                          return 'Digite un apellido';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Last name',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _bio,
                      decoration: InputDecoration(
                        labelText: 'Bio (optional)',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _pass,
                      validator: (password) {
                        if (password.isEmpty) {
                          return 'Digite una contraseña';
                        }
                        if (password.length < 8) {
                          return 'La contraseña debe tener 8 o más caracteres';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _confirmPass,
                      validator: (confirmPass) {
                        if (confirmPass.isEmpty || confirmPass != _pass.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm password',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ]),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.8, 40),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      primary: Colors.lightBlue),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      UserInfo userInfo = new UserInfo(
                          _firstName.text,
                          _lastName.text,
                          _username.text,
                          _email.text,
                          _pass.text);
                      setState(() {
                        newUser = new User(null, _bio.text, _profileImage, userInfo, null);
                        registerTrigger = true;
                      });
                    }
                  },
                  child: Text('Register',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                registerTrigger ? registerConfirmation() : SizedBox(),
              ])),
        ),
      ],
    ));
  }

  FutureBuilder registerConfirmation() {
    return FutureBuilder(
        future: ServiceConsoomer().RegisterUser(newUser),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AlertDialog(
              title:
                  Text(snapshot.data ? "Usuario registrado" : "Error de red"),
              content: Text(snapshot.data
                  ? "Puede iniciar sesión con este usuario"
                  : "Intentelo de nuevo más tarde"),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
