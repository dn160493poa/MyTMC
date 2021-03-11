class User{
  int id;
  int userId;
  String authRef;

  User(id, userId, authRef){
    this.id = id;
    this.userId = userId;
    this.authRef = authRef;
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['userId'] = userId;
    map['authRef'] = authRef;
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    userId = map['userId'];
    authRef = map['authRef'];
  }

}