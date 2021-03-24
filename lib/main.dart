import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagramclone/dataFunctions.dart';
import 'package:instagramclone/loginPage.dart';
import 'package:instagramclone/profilePage.dart';

import 'entities/post.dart';
import 'entities/user.dart';
import 'newPostPage.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Post>> thePosts;

  @override
  void initState() {
    super.initState();
    setState(() {
      thePosts = ServiceConsoomer().getPosts();
    });
  }

  Future<void> _onItemTapped(int index) async {
    var context = this.context;
    switch (index) {
      case 0:
        {
          ServiceConsoomer().LogoutUser();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
        break;
      case 1:
         {
          var value = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => NewPostPage()));
          setState(() {
            thePosts = ServiceConsoomer().getPosts();
          });
        }
        break;
      case 2:
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage()));
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Instagram Clone",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      ),
      body: Center(child: showPosts()),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back_ios),
            label: 'Logout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_sharp),
            label: 'New Post',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(NetworkImage(
              ServiceConsoomer.loggedUser.profile_picture,
            )),
            label: 'Your profile',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  FutureBuilder showPosts() {
    return FutureBuilder(
      future: ServiceConsoomer().getPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            List<Post> _posts = snapshot.data;
            return ListView.separated(
              padding: EdgeInsets.all(10),
              separatorBuilder: (context, index) => SizedBox(
                height: 20,
              ),
              itemCount: _posts.length,
              itemBuilder: (BuildContext context, int index) {
                var _posts = snapshot.data;
                return Card(
                    child: Column(children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                              (_posts[index].user as User).profile_picture,
                            ),
                            fit: BoxFit.contain),
                      ),
                    ),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                    profileId:
                                        (_posts[index].user as User).id)));
                      },
                      child: Text(
                        (_posts[index].user as User).user.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network(
                      _posts[index].photo,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                          height: 50,
                          width: 50,
                          child: IconButton(
                            icon: Icon(Icons.favorite_outline),
                            padding: EdgeInsets.all(0),
                            onPressed: () => print("like"),
                          )),
                      SizedBox(
                          height: 50,
                          width: 50,
                          child: IconButton(
                            icon: Icon(Icons.chat_bubble_outline),
                            padding: EdgeInsets.all(0),
                            onPressed: () => print("like"),
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          (_posts[index].user as User).user.username,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(_posts[index].caption)
                      ],
                    ),
                  ),
                  // (this._comments.length - 2 <= 0)
                  //     ? Container()
                  //     : Text("View all ${this._comments.length - 2} comments"),
                  // ListView.builder(
                  //   itemCount: 2,
                  //   itemBuilder: (context, index) {
                  //     Comment current = this._comments[index];
                  //     return RichText(
                  //         text: TextSpan(
                  //             text: current.username,
                  //             style: TextStyle(fontWeight: FontWeight.bold),
                  //             children: [
                  //           TextSpan(
                  //               text: current.comment,
                  //               style: TextStyle(color: Colors.grey))
                  //         ]));
                  //   },
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Add a comment',
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            print("Se Envio");
                          },
                          child: Text("Post",
                              style: TextStyle(color: Colors.blue)))
                    ],
                  ),
                ]));
              },
            );
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}
