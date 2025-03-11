import 'package:fidelite/polices.dart';
import 'package:fidelite/repositories/points_repository.dart';
import 'package:fidelite/repositories/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'authentification.dart';
import 'beans/transactionsDTO.dart';
import 'firebase_options.dart';
import 'getxcontroller/getpointscontroller.dart';
import 'models/user.dart';
import 'objets/constants.dart';


// Attributes :
final _repository = UserRepository();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  //showFlutterNotification(message, 'Num. : ${message.data['identifiant']}', 'Réserve initiale : ${message.data['reserve']} Kg');
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  User? localUser = await _repository.getConnectedUser();
  String tampon = message.data['type'];
}

late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;
var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'fcm_default_channel', // id
    'Information', // title
    description:
    'Statut de la commande', // description
    importance: Importance.high,
  );

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void main() async{

  // Load environment DATA :
  await dotenv.load(fileName: "variable.env");

  // Wait for :
  WidgetsFlutterBinding.ensureInitialized();

  //if(defaultTargetPlatform == TargetPlatform.android) {
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  User? localUser = await _repository.getConnectedUser();
  if(localUser == null) {
    runApp(MaterialApp( home: AuthentificationEcran()));
  }
  else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Fidelity'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Transactionsdto> lesTransactions = [];
  final _pointsRepository = PointsRepository();
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

  @override
  void initState() {
    //
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