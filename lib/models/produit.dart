class Produit {

  // A t t r i b u t e s  :
  final int id;
  final String libelle;
  final int prime;

  // M e t h o d s  :
  Produit({required this.id, required this.libelle, required this.prime});
  factory Produit.fromDatabaseJson(Map<String, dynamic> data) => Produit(
    //This will be used to convert JSON objects that
      id: data['id'],
      libelle: data['libelle'],
      prime: data['prime']
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": id,
    "libelle": libelle,
    "prime": prime
  };
}