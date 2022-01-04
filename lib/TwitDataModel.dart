class TwitDataModel {
  // data type
  String? name;
  String? twit;

  //constructor
  TwitDataModel(this.name, this.twit);

  TwitDataModel.fromJson(Map json) {
    name = json['name'];
    twit = json['twit'];
  }
}
