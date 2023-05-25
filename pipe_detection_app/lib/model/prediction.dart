class Prediction {
  String id;
  String inputUrl;
  String outputUrl;
  DateTime date;
  String count;
  String? remark;

  Prediction(
      // this.remark,
      {this.remark,
      required this.id,
      required this.inputUrl,
      required this.outputUrl,
      required this.date,
      required this.count});
}
