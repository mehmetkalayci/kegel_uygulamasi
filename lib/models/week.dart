class Week {
  List<Day> days;
  String name;

  Week({this.days, this.name});

  Week.fromJson(Map<String, dynamic> json) {
    if (json['days'] != null) {
      days = new List<Day>();
      json['days'].forEach((v) {
        days.add(new Day.fromJson(v));
      });
    }
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.days != null) {
      data['days'] = this.days.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    return data;
  }
}

class Day {
  String name;
  List<Exercise> exercises;

  Day({this.name, this.exercises});

  Day.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['items'] != null) {
      exercises = new List<Exercise>();
      json['items'].forEach((v) {
        exercises.add(new Exercise.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.exercises != null) {
      data['items'] = this.exercises.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Exercise {
  int totalDuration;
  List<Set> sets;
  String title;
  String description;
  String coverImage;
  List<String> images;

  Exercise(
      {this.totalDuration,
        this.sets,
        this.title,
        this.description,
        this.coverImage,
        this.images});

  Exercise.fromJson(Map<String, dynamic> json) {
    totalDuration = json['totalDuration'];
    if (json['sets'] != null) {
      sets = new List<Set>();
      json['sets'].forEach((v) {
        sets.add(new Set.fromJson(v));
      });
    }
    title = json['title'];
    description = json['description'];
    coverImage = json['coverImage'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalDuration'] = this.totalDuration;
    if (this.sets != null) {
      data['sets'] = this.sets.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['coverImage'] = this.coverImage;
    data['images'] = this.images;
    return data;
  }
}

class Set {
  int repetition;
  String setTitle;
  List<StepItem> steps;

  Set({this.repetition, this.setTitle, this.steps});

  Set.fromJson(Map<String, dynamic> json) {
    repetition = json['repetition'];
    setTitle = json['setTitle'];
    if (json['steps'] != null) {
      steps = new List<StepItem>();
      json['steps'].forEach((v) {
        steps.add(new StepItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['repetition'] = this.repetition;
    data['setTitle'] = this.setTitle;
    if (this.steps != null) {
      data['steps'] = this.steps.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StepItem {
  int stepDuration;
  String color;
  String stepTitle;

  StepItem({this.stepDuration, this.color, this.stepTitle});

  StepItem.fromJson(Map<String, dynamic> json) {
    stepDuration = json['stepDuration'];
    color = json['color'];
    stepTitle = json['stepTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stepDuration'] = this.stepDuration;
    data['color'] = this.color;
    data['stepTitle'] = this.stepTitle;
    return data;
  }
}