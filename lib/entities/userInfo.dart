class UserInfo {
  final String first_name;
  final String last_name;
  final String username;
  final String email;
  final String password;
  UserInfo(this.first_name, this.last_name, this.username, this.email, this.password);
  factory UserInfo.fromMap(Map<String, dynamic> json) {
    return UserInfo(
      json['first_name'],
      json['last_name'],
      json['username'],
      json['email'],
      json['password'],
    );
  }

  Map toMap() {
    var map = new Map();
    map['first_name'] = first_name;
    map['last_name'] = last_name;
    map['username'] = username;
    map['email'] = email;
    map['password'] = password;
    return map;
  }
}
