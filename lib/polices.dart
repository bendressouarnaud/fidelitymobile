import 'package:fidelite/echeancepaiement.dart';
import 'package:fidelite/models/produit.dart';
import 'package:fidelite/reglerpolice.dart';
import 'package:fidelite/repositories/produit_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';

import 'objets/constants.dart';

class Polices extends StatefulWidget {
  // Attribute :
  Polices({Key? key}) : super(key: key);

  @override
  State<Polices> createState() => _HPolices();
}

class _HPolices extends State<Polices> {
  // ATTRIBUTES :
  final _repository = ProduitRepository();
  List<Produit> lesProduits = [];




  @override
  void initState() {
    //
    super.initState();
  }

  // Init Objects :
  Future<List<Produit>> initObjects() async {
    return await _repository.findAll();
  }

  IconData returnIcon(String produit) {
    if(produit == "AUTO"){
      return Icons.directions_car;
    }
    else if(produit == "MRH"){
      return Icons.home;
    }
    else if(produit == "VOYAGE"){
      return Icons.airplanemode_active;
    }
    else{
      return Icons.emergency_outlined;
    }
  }

  String returnEcheance(int limit, int datetime) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(datetime).add(Duration(days: (30 * limit)));
    List<String> tp = dateTime.toString().split(" ");
    return 'Echéance prévue le ${tp[0]}';
  }

  String formatPrice(double price){
    MoneyFormatter fmf = MoneyFormatter(
        amount: price
    );
    return fmf.output.withoutFractionDigits;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text('Polices',
              textAlign: TextAlign.start,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )
            )
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
                child: const Text('Payer pour autrui'),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 3, left: 15, right: 15),
                  child: const Divider(
                    height: 2,
                    color: Colors.black,
                  )
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return ReglerPolice();
                      }));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10, left: 10, top: 5),
                  height: 75,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.blue.shade100,
                          Colors.red.shade50,
                        ],
                      ),
                      border: Border.all(
                          color: Colors.black,
                          width: 1
                      ),
                      //color: cardviewsousproduit,
                      borderRadius: BorderRadius.circular(16.0)
                  ),
                  child:Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      child: const Icon(Icons.person_outline,
                        size: 70,
                      ),
                    ),
                    Expanded(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 7, left: 10),
                              alignment: Alignment.topLeft,
                              child: Text('Régler une police',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown
                                ),),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5, left: 10),
                              alignment: Alignment.topLeft,
                              child: Text('à la fois'),
                            )
                          ],
                        )
                    )
                  ],
                )
                )
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(right: 10, left: 10, top: 30),
                child: const Text('Vos polices'),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 3, left: 15, right: 15),
                  child: const Divider(
                    height: 2,
                    color: Colors.black,
                  )
              ),
              FutureBuilder(
                  future: Future.wait([initObjects()]),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      lesProduits = snapshot.data[0];
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: lesProduits.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return Echeancepaiement(iDProduit: lesProduits[index].id, libProduit: lesProduits[index].libelle);
                                      }));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10, left: 10, top: 5),
                                  height: 95,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 1
                                      ),
                                      color: cardviewsousproduit,
                                      borderRadius: BorderRadius.circular(16.0)
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 72,
                                        height: 72,
                                        child: Icon(
                                          returnIcon(lesProduits[index].libelle),
                                          size: 70,
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(top: 7, left: 10, right: 7),
                                                alignment: Alignment.topLeft,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(lesProduits[index].libelle,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),),
                                                    Text(lesProduits[index].numPolice,
                                                        style: const TextStyle(
                                                          color: Colors.brown,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 5, left: 10),
                                                alignment: Alignment.topLeft,
                                                child: Text('${ formatPrice((lesProduits[index].prime).toDouble()) } CFA',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                //
                                              ),
                                              Container(
                                                  margin: const EdgeInsets.only(top: 3, left: 10, right: 10),
                                                  child: const Divider(
                                                    height: 2,
                                                    color: Colors.black,
                                                  )
                                              ),
                                              Container(
                                                alignment: Alignment.topRight,
                                                  margin: const EdgeInsets.only(top: 3, left: 10, right: 10),
                                                  child: Text(
                                                      returnEcheance(
                                                          lesProduits[index].echeance,
                                                          lesProduits[index].dateSouscription),
                                                    style: const TextStyle(
                                                      fontSize: 11
                                                    ),
                                                  )
                                              )
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                )
                            );
                          }
                      );
                    }
                    else {
                      return const Center(
                        child: Text('Chargement ...'),
                      );
                    }
                  }
              )
            ],
          )
        )
    );
  }
}