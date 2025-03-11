import 'dart:convert';

import 'package:fidelite/models/calendrierpaiement.dart';
import 'package:fidelite/models/produit.dart';

class AuthenticateResponse {

  // https://vaygeth.medium.com/reactive-flutter-todo-app-using-bloc-design-pattern-b71e2434f692
  // https://pythonforge.com/dart-classes-heritage/

  // A t t r i b u t e s  :
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String numero;
  final String adresse;
  final String fcmtoken;
  final String pwd;
  final List<Produit> produits;
  final List<CalendrierPaiement> calendriers;

  // M e t h o d s  :
  AuthenticateResponse({required this.id, required this.nom, required this.prenom, required this.email, required this.numero,
    required this.adresse, required this.fcmtoken, required this.pwd, required this.produits, required this.calendriers});
  factory AuthenticateResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticateResponse(
      //
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      numero: json['numero'],
      adresse: json['adresse'],
      fcmtoken: json['fcmtoken'],
      pwd: json['pwd'],
      produits: List<dynamic>.from(json['produits']).map((i) => Produit.fromDatabaseJson(i)).toList(),
      calendriers: List<dynamic>.from(json['calendriers']).map((i) => CalendrierPaiement.fromDatabaseJson(i)).toList()
    );
  }
}