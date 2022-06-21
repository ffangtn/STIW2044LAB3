class Subjects {
  String? id;
  String? name;
  String? description;
  String? price;
  String? tutorid;
  String? sessions;
  String? rating;
  String? tutorname;

  Subjects({this.id, this.name, this.description, this.price, String? this.tutorid, String? this.sessions, this.rating, this.tutorname});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    tutorid = json['tutorid'];
    sessions = json['sessions'];
    rating = json['rating'];
    tutorname = json['tutorname'];
  }

  get subjectID => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['tutorid'] = tutorid;
    data['sessions'] = sessions;
    data['rating'] = rating;
    data['tutorname'] = tutorname;
    return data;
  }
}