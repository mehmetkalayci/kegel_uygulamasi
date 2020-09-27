class User {
  int age;
  String gender;
  int height;
  int hydrationGoal;
  int weight;

  User({this.age, this.gender, this.height, this.hydrationGoal, this.weight});

  User.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    gender = json['gender'];
    height = json['height'];
    hydrationGoal = json['hydrationGoal'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['height'] = this.height;
    data['hydrationGoal'] = this.hydrationGoal;
    data['weight'] = this.weight;
    return data;
  }
}