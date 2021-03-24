import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dataFunctions.dart';

class NewPostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewPostPage();
}

class _NewPostPage extends State<NewPostPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _caption = TextEditingController();

  File _postImage;
  String _imagePath;
  bool sendPostTrigger = false;
  ImagePicker _picker = ImagePicker();
  bool postTrigger = false;
  bool badPost = false;
  bool selectPicture = false;
  @override
  void initState() {
    super.initState();
    downloadImage();
  }

  Future getImage(bool camera) async {
    PickedFile _image = await _picker.getImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000);
    setState(() {
      _imagePath = _image.path.toString();
      _postImage = File(_image.path);
      print('Select image path' + _image.path.toString());
    });
  }

  Future downloadImage() async {
    if (_imagePath != null) {
      var image = new File(_imagePath);
      setState(() {
        _postImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("New post")),
        body: ListView(
          children: [
            Form(
                child: Center(
                    child: Column(children: [
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: _postImage != null
                      ? Image.file(
                          _postImage,
                          fit: BoxFit.contain,
                        )
                      : Image.asset('assets/PostPlaceholder.png'),
                ),
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
                        style: TextStyle(color: Colors.white, fontSize: 20)),
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
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  )
                ],
              )),
              Row(
                children: [
                  Center(
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: _caption,
                        decoration: InputDecoration(
                          labelText: 'Caption',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              badPost
                  ? AlertDialog(
                      title: Text("Error al subir post"),
                      content: Text("Intentelo de nuevo más tarde"),
                    )
                  : SizedBox(),
              selectPicture
                  ? AlertDialog(
                      title: Text("Error al subir post"),
                      content: Text("Debe incluir una foto"),
                    )
                  : SizedBox(),
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
                  if (_postImage != null) {
                    setState(() {
                      selectPicture = false;
                      postTrigger = true;
                      badPost = false;
                    });
                    ServiceConsoomer()
                        .PostPicture(_postImage, ServiceConsoomer.loggedUser.id,
                            _caption.text)
                        .then((value) {
                      if (value) {
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          postTrigger = false;
                          badPost = true;
                        });
                      }
                    });
                  } else {
                    setState(() {
                      selectPicture = true;
                    });
                  }
                },
                child: Text('Upload Post',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              postTrigger ? CircularProgressIndicator() : SizedBox(),
            ])))
          ],
        ));
  }
}
