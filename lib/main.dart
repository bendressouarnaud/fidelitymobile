import 'package:fidelite/pageaccueil.dart';
import 'package:fidelite/repositories/user_repository.dart';
import 'package:fidelite/services/processfirebasemessage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'authentification.dart';
import 'firebase_options.dart';
import 'models/user.dart';


// Attributes :
final _repository = UserRepository();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  //showFlutterNotification(message, 'Num. : ${message.data['identifiant']}', 'Réserve initiale : ${message.data['reserve']} Kg');
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
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
      home: const PageAccueil(title: 'Fidelity'),
    );
  }
}

