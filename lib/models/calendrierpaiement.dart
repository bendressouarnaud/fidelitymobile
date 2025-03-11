class CalendrierPaiement {

  // A t t r i b u t e s  :
  final int id;
  final int produitId;
  final int montant;
  final int mois;
  final int annee;
  final int paiementEffectue;

  // M e t h o d s  :
  CalendrierPaiement({required this.id, required this.produitId, required this.montant, required this.mois
    , required this.annee , required this.paiementEffectue});
  factory CalendrierPaiement.fromDatabaseJson(Map<String, dynamic> data) => CalendrierPaiement(
    //This will be used to convert JSON objects that
      id: data['id'],
      produitId: data['produitId'],
      montant: data['montant'],
      mois: data['mois'],
      annee: data['annee'],
    paiementEffectue: data['paiementEffectue'],
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": id,
    "produitId": produitId,
    "montant": montant,
    "mois": mois,
    "annee": annee,
    "paiementEffectue": paiementEffectue,
  };
}