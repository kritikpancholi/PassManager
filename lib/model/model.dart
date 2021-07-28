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
  final int id;

  Password({
    this.userid,
    this.email,
    this.password,
    this.title,
    this.id,
  });

  factory Password.fromJson(Map<String, dynamic> json) {
    return Password(
      userid: json['user_id'] as int,
      email: json['email'] as String,
      password: json['user_password'] as String,
      title: json['title'] as String,
      id: json['id'] as int,
    );
  }
}

class Note {
  final int userid;
  final String title;
  final int id;
  final String description;
  Note({
    this.userid,
    this.title,
    this.id,
    this.description,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      userid: json['user_id'] as int,
      title: json['title'] as String,
      id: json['id'] as int,
      description: json['description'] as String,
    );
  }
}
