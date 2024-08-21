class HadithMapModel{
  List<HadithModel> ahadith = [];

  HadithMapModel.fromJson(List<dynamic> json){
    json.forEach((element) => ahadith.add(HadithModel.fromJson(element)),);
  }
}

class HadithModel {
  dynamic hadithnumber;
  String? text;
  List<dynamic>? grades;

  HadithModel({this.hadithnumber, this.text, this.grades});

  HadithModel.fromJson(Map<String, dynamic> json){
    hadithnumber = json['hadithnumber'];
    text = json['text'];
    grades = json['grades'];

  }

  Map<String, dynamic> toMap(){
    return{
      'hadithnumber' : hadithnumber,
      'text' : text,
      'grades' : grades,
    };
  }

}
