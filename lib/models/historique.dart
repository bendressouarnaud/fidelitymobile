class Historique {

  // A t t r i b u t e s  :
  final int id;
  final String contenu;
  final int temps;

  // M e t h o d s  :
  Historique({required this.id, required this.contenu, required this.temps});
  factory Historique.fromDatabaseJson(Map<String, dynamic> data) => Historique(
    //This will be used to convert JSON objects that
      id: data['id'],
      contenu: data['contenu'],
      temps: data['temps']
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": id,
    "contenu": contenu,
    "temps": temps
  };
}