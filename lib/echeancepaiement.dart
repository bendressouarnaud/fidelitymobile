import 'package:fidelite/repositories/calendrierpaiement_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'models/calendrierpaiement.dart';
import 'objets/constants.dart';

class Echeancepaiement extends StatefulWidget {
  // Attribute :
  final int iDProduit;
  final String libProduit;
  const Echeancepaiement({Key? key, required this.iDProduit, required this.libProduit}) : super(key: key);

  @override
  State<Echeancepaiement> createState() => _HEcheancepaiement();
}

class _HEcheancepaiement extends State<Echeancepaiement> {
  // ATTRIBUTES :
  List<CalendrierPaiement> lesEcheances = [];
  late String libelleProduit;
  final _repository = CalendrierPaiementRepository();



  @override
  void initState() {
    //
    libelleProduit = widget.libProduit;
    super.initState();
  }

  String returnMonyhName(int mois) {
    if(mois == 1){
      return "Janvier";
    }
    else if(mois == 2){
      return "Février";
    }
    else if(mois == 3){
      return "Mars";
    }
    else if(mois == 4){
      return "Avril";
    }
    else if(mois == 5){
      return "Mai";
    }
    else if(mois == 6){
      return "Juin";
    }
    else if(mois == 7){
      return "Juillet";
    }
    else if(mois == 8){
      return "Août";
    }
    else if(mois == 9){
      return "Septembre";
    }
    else if(mois == 10){
      return "Octobre";
    }
    else if(mois == 11){
      return "Novembre";
    }
    else{
      return "Décembre";
    }
  }

  // Init Objects :
  Future<List<CalendrierPaiement>> initObjects() async {
    return await _repository.findByProduitId(widget.iDProduit);
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
            title: Text('Echéance $libelleProduit',
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
            child: FutureBuilder(
            future: Future.wait([initObjects()]),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  lesEcheances = snapshot.data[0];
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: lesEcheances.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {
                              // Pay :
                            },
                            child: Container(
                                padding: EdgeInsets.all(5),
                                margin: const EdgeInsets.only(right: 10, left: 10, top: 5),
                                height: 65,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1
                                    ),
                                    color: cardviewsousproduit,
                                    borderRadius: BorderRadius.circular(16.0)
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(returnMonyhName(lesEcheances[index].mois),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold
                                            ),),
                                          Text('${formatPrice(lesEcheances[index].montant.toDouble())} CFA')
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(lesEcheances[index].paiementEffectue == 1 ? '10/03/20025' : '---'),
                                          Icon(lesEcheances[index].paiementEffectue == 1 ? Icons.check_circle : Icons.dangerous,
                                            color: lesEcheances[index].paiementEffectue == 1 ? Colors.green : Colors.red,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
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
        )
    );
  }
}