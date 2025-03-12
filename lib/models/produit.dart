class Produit {

  // A t t r i b u t e s  :
  final int id;
  final String libelle;
  final String numPolice;
  final int prime;
  final int dateSouscription;
  final int echeance;
  final int paye;

  // M e t h o d s  :
  Produit({required this.id, required this.libelle, required this.prime, required this.numPolice, required this.echeance
  , required this.dateSouscription , required this.paye});
  factory Produit.fromDatabaseJson(Map<String, dynamic> data) => Produit(
    //This will be used to convert JSON objects that
    id: data['id'],
    libelle: data['libelle'],
    prime: data['prime'],
    numPolice: data['numPolice'],
    dateSouscription: data['dateSouscription'],
    echeance: data['echeance'],
    paye: data['paye'],
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": id,
    "libelle": libelle,
    "prime": prime,
    "numPolice": numPolice,
    "dateSouscription": dateSouscription,
    "echeance": echeance,
    "paye": paye
  };
}