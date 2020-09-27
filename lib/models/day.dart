class Day {
  List<Exercise> exercises;
  String name;

  Day({this.exercises, this.name});

  Day.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      exercises = new List<Exercise>();
      json['items'].forEach((v) {
        exercises.add(new Exercise.fromJson(v));
      });
    }
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.exercises != null) {
      data['items'] = this.exercises.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    return data;
  }
}

class Exercise {
  List<String> images;
  String coverImage;
  List<Set> sets;
  String definition;
  String description;
  String title;
  int totalDuration;
  bool done;

  Exercise(
      {this.images,
        this.coverImage,
        this.sets,
        this.definition,
        this.description,
        this.title,
        this.totalDuration,
        this.done});

  Exercise.fromJson(Map<String, dynamic> json) {
    images = json['images'].cast<String>();
    coverImage = json['coverImage'];
    if (json['sets'] != null) {
      sets = new List<Set>();
      json['sets'].forEach((v) {
        sets.add(new Set.fromJson(v));
      });
    }
    definition = json['definition'];
    description = json['description'];
    title = json['title'];
    totalDuration = json['totalDuration'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;
    data['coverImage'] = this.coverImage;
    if (this.sets != null) {
      data['sets'] = this.sets.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['definition'] = this.definition;
    data['title'] = this.title;
    data['totalDuration'] = this.totalDuration;
    data['done'] = this.done;
    return data;
  }
}

class Set {
  List<StepItem> steps;
  int repetition;
  String setTitle;

  Set({this.steps, this.repetition, this.setTitle});

  Set.fromJson(Map<String, dynamic> json) {
    if (json['steps'] != null) {
      steps = new List<StepItem>();
      json['steps'].forEach((v) {
        steps.add(new StepItem.fromJson(v));
      });
    }
    repetition = json['repetition'];
    setTitle = json['setTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.steps != null) {
      data['steps'] = this.steps.map((v) => v.toJson()).toList();
    }
    data['repetition'] = this.repetition;
    data['setTitle'] = this.setTitle;
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