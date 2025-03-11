class Points {

  // A t t r i b u t e s  :
  final int id;
  final int total;

  // M e t h o d s  :
  Points({required this.id, required this.total});
  factory Points.fromDatabaseJson(Map<String, dynamic> data) => Points(
    //This will be used to convert JSON objects that
      id: data['id'],
      total: data['total']
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": id,
    "total": total
  };
}