class AppUser {
  //final: property that won't change as user goes between diff screens
  final String uid;

  //set property in constructor; named parameters
  AppUser({this.uid});
}

class UserData {
  final String uid;
  final String name;

  UserData({this.uid, this.name});
}
