import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:instagramclone/entities/post.dart';
import 'package:instagramclone/entities/user.dart';

class ServiceConsoomer {
  static final ServiceConsoomer _consoomer = ServiceConsoomer._internal();
  static final String apiRoute = 'http://www.miguelestevez.xyz:8000/api';
  static final String authRoute = 'http://www.miguelestevez.xyz:8000/api-auth';
  static String authToken;
  static User loggedUser;
  factory ServiceConsoomer() {
    return _consoomer;
  }

  ServiceConsoomer._internal();

  Future<bool> RegisterUser(User user) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiRoute + '/profiles'));

    request.files.add(http.MultipartFile('profile_picture', user.profile_picture.readAsBytes().asStream(), user.profile_picture.lengthSync(), filename: user.profile_picture.path.split("/").last));

    request.fields['bio'] = user.bio;
    request.fields['user.username'] = user.user.username;
    request.fields['user.first_name'] = user.user.first_name;
    request.fields['user.last_name'] = user.user.last_name;
    request.fields['user.email'] = user.user.email;
    request.fields['user.password'] = user.user.password;

    request.headers.addAll(<String, String>{
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding': 'gzip, deflate, br',
    });

    var res = await request.send().timeout(Duration(seconds: 5));

    return res.statusCode >= 200;
  }

  Future<List<Post>> getPosts() async {
    List<Post> posts;
    http.Response getPostsResponse = await http.get(Uri.parse(apiRoute + '/posts'), headers: {
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding': 'gzip, deflate, br',
    });

    if (getPostsResponse.statusCode != 200) {
      return posts;
    }

    posts = (jsonDecode(getPostsResponse.body)['results'] as List).map((postJson) => Post.fromMap(postJson)).toList();

    await Future.forEach(posts, (post) async {
      post.user = await getUser(post.user);
    });

    return posts;
  }

  Future<User> getUser(int id) async {
    http.Response getUserResponse = await http.get(Uri.parse(apiRoute + '/profiles/' + id.toString()), headers: {
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding': 'gzip, deflate, br',
    });

    if (getUserResponse.statusCode != 200) {
      return null;
    }
    print("buen req");

    print(jsonDecode(getUserResponse.body).toString());
    User user = User.fromMap(jsonDecode(getUserResponse.body));
    List<Post> posts;
    posts = (jsonDecode(getUserResponse.body)['posts'] as List).map((postJson) => Post.fromMap(postJson)).toList();
    user.posts = posts;
    return user;
  }

  Future<User> getUserByUsername(String username) async {
    http.Response getUserResponse = await http.get(Uri.parse(apiRoute + '/profiles?username=' + username), headers: {
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding': 'gzip, deflate, br',
    });

    if (getUserResponse.statusCode != 200) {
      return null;
    }
    print("buen req");

    print(jsonDecode(getUserResponse.body).toString());
    User user = User.fromMap(jsonDecode(getUserResponse.body)['results'][0]);
    return user;
  }

  Future<bool> PostPicture(File pic, int userId, String caption) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiRoute + '/posts'));

    request.files.add(http.MultipartFile('photo', pic.readAsBytes().asStream(), pic.lengthSync(), filename: pic.path.split("/").last));

    request.fields['caption'] = caption;
    request.fields['user'] = userId.toString();

    request.headers.addAll(<String, String>{
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding': 'gzip, deflate, br',
      'Authorization': 'Token ' + authToken
    });

    var res = await request.send().timeout(Duration(seconds: 5));

    return res.statusCode >= 200;
  }

  Future<bool> LoginUser(String username, String password) async {
    Map credentials = <String, String>{
      'username': username,
      'password': password
    };
    http.Response loggedIn = await http.post(Uri.parse(apiRoute + '/auth/token/login'),
        headers: {
          'Content-Type': 'application/json',
          'connection': 'keep-alive'
        },
        body: jsonEncode(credentials));
    if (loggedIn.statusCode != 200) {
      return false;
    }
    authToken = jsonDecode(loggedIn.body)['auth_token'];
    loggedUser = await getUserByUsername(username);
    return true;
    //TODO: get user info
  }

  void LogoutUser() {
    authToken = null;
    loggedUser = null;
  }
}
