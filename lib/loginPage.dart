import 'package:flutter/material.dart';
import 'package:instagramclone/main.dart';

import './registerPage.dart';
import 'dataFunctions.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool loginTrigger = false;
  bool badLogin = false;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
            child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage('assets/LogoCISCGris.png'),
                    fit: BoxFit.fitHeight),
              ),
            ),
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
                controller: _pass,
                validator: (password) {
                  if (password.isEmpty) {
                    return 'Digite una contraseña';
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
                  setState(() {
                    loginTrigger = true;
                    badLogin = false;
                  });
                  ServiceConsoomer()
                      .LoginUser(_username.text, _pass.text)
                      .then((value) {
                    if (value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    } else {
                      setState(() {
                        loginTrigger = false;
                        badLogin = true;
                      });
                    }
                  });
                }
              },
              child: Text('Login',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            loginTrigger ? CircularProgressIndicator() : SizedBox(),
            badLogin
                ? AlertDialog(
                    title: Text("Error al entrar"),
                    content:
                        Text("Revise sus credenciales e intentelo de nuevo"),
                  )
                : SizedBox(),
          ],
        )),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('¿No tienes una cuenta?'),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Registrate',
                  style: TextStyle(fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}
