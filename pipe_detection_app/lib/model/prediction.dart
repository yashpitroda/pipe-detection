class Prediction {
  String id;
  String inputImageUrl;
  String outputImageUrl;
  DateTime date;
  String count;

  Prediction(
      // this.remark,
      {
      required this.id,
      required this.inputImageUrl,
      required this.outputImageUrl,
      required this.date,
      required this.count});
}
