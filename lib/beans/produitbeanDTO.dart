class ProduitbeanDTO {
  final String libelle, numPolice;
  final int id, prime, dateSouscription, echeance;

  const ProduitbeanDTO({
    required this.id,
    required this.prime,
    required this.libelle,
    required this.numPolice,
    required this.dateSouscription,
    required this.echeance
  });

  factory ProduitbeanDTO.fromJson(Map<String, dynamic> json) {
    return ProduitbeanDTO(
        id: json['id'],
        prime: json['prime'],
        libelle: json['libelle'],
        numPolice: json['numPolice'],
        dateSouscription: json['dateSouscription'],
      echeance: json['echeance']
    );
  }
}