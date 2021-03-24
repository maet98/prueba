import 'package:flutter/material.dart';

import 'dataFunctions.dart';
import 'entities/user.dart';

class ProfilePage extends StatefulWidget {
  final int profileId;

  const ProfilePage({Key key, this.profileId}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProfilePage(profileId);
}

class _ProfilePage extends State<ProfilePage> {
  final int profileId;

  _ProfilePage(this.profileId);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: ServiceConsoomer().getUser(profileId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  snapshot.data.user.username,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: ListView(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                  snapshot.data.profile_picture,
                                ),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Container(),
                        Container(),
                        Container(),
                        Container(),
                        Container(),
                        Container(),
                        Container(),
                        Container(),
                        Container(),
                        Container(),
                        Container(
                            child: Column(
                          children: [
                            Text(snapshot.data.posts.length.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            Text("posts",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18))
                          ],
                        )),
                        Container(),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                snapshot.data.user.username,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(snapshot.data.bio),
                              )
                            ],
                          )
                        ],
                      ),
                    ),

                    //TODO: Post Grid

                    Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Container(
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.posts.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              print("enprofile");

                              print(snapshot.data.posts[index]);
                              return GestureDetector(
                                onTap: () {
                                  print("Se Envio");
                                },
                                child: Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          snapshot.data.posts[index].photo,
                                        ),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              );
                            },
                          ),
                        ))
                  ],
                ),
              ]),
            );
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        });
  }
}
