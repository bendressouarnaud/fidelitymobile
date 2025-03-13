import 'package:fidelite/repositories/historique_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/historique.dart';
import '../models/points.dart';
import '../models/produit.dart';
import '../repositories/points_repository.dart';
import '../repositories/produit_repository.dart';

class ProcessFirebaseMessage {

  // A T T R I B U T E S :
  final _produitRepository = ProduitRepository();
  final _pointsRepository = PointsRepository();
  final _historiqueRepository = HistoriqueRepository();
  final newPoint = 100;



  // M E T H O D S :
  void processIncommingNewPolice(RemoteMessage message) async{
    try {
      Produit produit = Produit(
          id: int.parse(message.data['id']),
          libelle: message.data['produit'],
          prime: int.parse(message.data['prime']),
          dateSouscription: int.parse(message.data['dateSouscription']),
          echeance: int.parse(message.data['echeance']),
          numPolice: message.data['numPolice'],
          paye: 0);
      await _produitRepository.insert(produit);

      // Add new POINTS, make an update :
      Points point = await _pointsRepository.findById(1);
      Points pointToUpdate = Points(id: point.id, total: (point.total + newPoint));
      await _pointsRepository.update(pointToUpdate);

      // For historique :
      List<Historique> lesHistoriques = await _historiqueRepository.findAll();
      Historique historique = Historique(
          id: lesHistoriques.length + 1,
          contenu: 'Souscription au produit ${produit.libelle}',
          temps: int.parse(message.data['temps']));
      await _historiqueRepository.insert(historique);
    }
    catch (e) {
      print('Erreur INSERTING ProduitbeanDTO : ${e.toString()}');
    }
  }

  void processProduitStatut(RemoteMessage message) async {
    Produit produit = await _produitRepository.findByNumpolice(message.data['numPolice']);
    Produit produitToTupdate = Produit(
        id: produit.id,
        libelle: produit.libelle,
        prime: produit.prime,
        dateSouscription: produit.dateSouscription,
        echeance: produit.echeance,
        numPolice: produit.numPolice,
        paye: 1);
    await _produitRepository.update(produitToTupdate);

    // Display message :
    Fluttertoast.showToast(
        msg: "Paiement effectué pour la police ${produit.libelle}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}