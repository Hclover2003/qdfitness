class AppUser {
  //final: property that won't change as user goes between diff screens
  final String uid;
  int dailyCalorieTotal;

  //set property in constructor; named parameters
  AppUser({this.uid, this.dailyCalorieTotal});
}

class UserData {
  final String uid;
  final String name;

  UserData({this.uid, this.name});
}
