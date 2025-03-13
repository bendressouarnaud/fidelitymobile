import 'package:fidelite/polices.dart';
import 'package:fidelite/repositories/points_repository.dart';
import 'package:fidelite/repositories/user_repository.dart';
import 'package:fidelite/services/processfirebasemessage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'beans/transactionsDTO.dart';
import 'getxcontroller/getpointscontroller.dart';
import 'models/user.dart';
import 'objets/constants.dart';

class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key, required this.title});
  final String title;

  @override
  State<PageAccueil> createState() => _PageAccueil();
}

class _PageAccueil extends State<PageAccueil> {
  int _counter = 0;
  List<Transactionsdto> lesTransactions = [];
  final _pointsRepository = PointsRepository();
  final _repository = UserRepository();
  final PointsGetController _pointsController = Get.put(PointsGetController());

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void displayFloat(String message, { int choix = 0}){

    switch(choix){
      case 0:
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0
        );
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: const Duration(seconds: 3),
              content: Text(message)
          ),
        );
        break;
    }
  }

  // Check if user has logged in and check if NOTIFICATIONs PERMISSIONs has been given :
  void chechNotificationPermission() async{
    User? usr = await _repository.getConnectedUser();
    // We can request :
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if(apnsToken != null){
        initFire();
      }
    }
    else{
      initFire();
    }
  }

  void initFire() async {
    // Set Flag :
    //outil.setFcmFlag(true);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        switch(int.parse(message.data['sujet'])) {
          case 1:
          // New POLICE :
            ProcessFirebaseMessage().processIncommingNewPolice(message);
            break;

          case 2:
          // Update POLICE :
            ProcessFirebaseMessage().processProduitStatut(message);
            break;

          default:

            break;
        }
      });
    }
  }

  @override
  void initState() {
    //
    chechNotificationPermission();

    Transactionsdto transactionsdto = const Transactionsdto(
        date: "05/03/2025", heure: "10:00", libelle: "Paiement prime", produit: "AUTO", point: 10);
    lesTransactions.add(transactionsdto);
    Transactionsdto transactionsdto1 = const Transactionsdto(
        date: "06/03/2025", heure: "12:00", libelle: "Paiement prime", produit: "HABITATION", point: 15);
    lesTransactions.add(transactionsdto1);
    Transactionsdto transactionsdto2 = const Transactionsdto(
        date: "06/03/2025", heure: "12:00", libelle: "Paiement prime", produit: "HABITATION", point: 15);
    lesTransactions.add(transactionsdto2);

    Transactionsdto transactionsdto3 = const Transactionsdto(
        date: "06/03/2025", heure: "12:00", libelle: "Paiement prime", produit: "HABITATION", point: 15);
    lesTransactions.add(transactionsdto3);
    Transactionsdto transactionsdto4 = const Transactionsdto(
        date: "06/03/2025", heure: "12:00", libelle: "Paiement prime", produit: "HABITATION", point: 15);
    lesTransactions.add(transactionsdto4);

    Transactionsdto transactionsdto5 = const Transactionsdto(
        date: "06/03/2025", heure: "12:00", libelle: "Paiement prime", produit: "HABITATION", point: 15);
    lesTransactions.add(transactionsdto5);

    Transactionsdto transactionsdto6 = const Transactionsdto(
        date: "06/03/2025", heure: "12:00", libelle: "Paiement prime", produit: "HABITATION", point: 15);
    lesTransactions.add(transactionsdto6);

    Transactionsdto transactionsdto7 = const Transactionsdto(
        date: "06/03/2025", heure: "12:00", libelle: "Paiement prime", produit: "HABITATION", point: 15);
    lesTransactions.add(transactionsdto7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,//Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10, left: 10, top: 15),
                height: 100,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        width: 1
                    ),
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(16.0)
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GetBuilder<PointsGetController>(
                          builder: (PointsGetController controller) {
                            // Sort :
                            //  && pub.active == 1))
                            return Text('${controller.data.isNotEmpty ? controller.data[0].total : 0}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60
                              ),);
                          }
                      ),
                      const Text('  pts',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15
                          ))
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(right: 10, left: 10, top: 30),
                child: Text('Actions principales'),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: const Divider(
                    height: 2,
                    color: Colors.black,
                  )
              ),
              Container(
                margin: const EdgeInsets.only(right: 10, left: 10, top: 15),
                height: 100,


                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const ScrollPhysics(),
                  child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  width: 1
                              ),
                              color: Colors.brown[200],
                              borderRadius: BorderRadius.circular(16.0)
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.menu_book,
                                  size: 70,
                                ),
                              ),
                              Text('Documents')
                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  width: 1
                              ),
                              color: Colors.brown[200],
                              borderRadius: BorderRadius.circular(16.0)
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.medical_services,
                                  size: 70,
                                ),
                              ),
                              Text('Sinistres')
                            ],
                          ),
                        ),

                        Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    width: 1
                                ),
                                color: Colors.brown[200],
                                borderRadius: BorderRadius.circular(16.0)
                            ),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return Polices();
                                    }));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    child: Icon(
                                      Icons.inventory,
                                      size: 70,
                                    ),
                                  ),
                                  Text('Polices')
                                ],
                              ),
                            )
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  width: 1
                              ),
                              color: Colors.brown[200],
                              borderRadius: BorderRadius.circular(16.0)
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.payments,
                                  size: 70,
                                ),
                              ),
                              Text('Récomp.')
                            ],
                          ),
                        )
                      ]
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(right: 10, left: 10, top: 40),
                child: Text('Historique des transactions'),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 3, left: 15, right: 15),
                  child: const Divider(
                    height: 2,
                    color: Colors.black,
                  )
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: lesTransactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        displayFloat('En cours ...', choix: 1);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: const EdgeInsets.only(right: 10, left: 10, top: 5),
                        height: 75,
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
                                  Text(lesTransactions[index].date),
                                  Text(lesTransactions[index].heure)
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(lesTransactions[index].libelle),
                                  Text(lesTransactions[index].produit,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                            Container(
                              height: 20,
                              alignment: Alignment.topRight,
                              child: Text('${lesTransactions[index].point} points'),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              )
            ],
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}