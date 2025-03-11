class Transactionsdto {
  final String date, heure, libelle, produit;
  final int point;

  const Transactionsdto({
    required this.date,
    required this.heure,
    required this.libelle,
    required this.produit,
    required this.point
  });

  factory Transactionsdto.fromJson(Map<String, dynamic> json) {
    return Transactionsdto(
        date: json['date'],
        heure: json['heure'],
        libelle: json['libelle'],
        produit: json['produit'],
        point: json['point']
    );
  }
}