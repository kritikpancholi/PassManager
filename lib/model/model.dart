class User {
  final int userId;

  User({
    this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'],
    );
  }
}

class Password {
  final int userid;
  final String email;
  final String password;
  final String title;

  Password({
    this.userid,
    this.email,
    this.password,
    this.title,
  });

  factory Password.fromJson(Map<String, dynamic> json) {
    return Password(
      userid: json['user_id'] as int,
      email: json['email'] as String,
      password: json['password'] as String,
      title: json['title'] as String,
    );
  }
}
