import 'dart:async';
import 'dart:convert';

import 'package:fidelite/main.dart';
import 'package:fidelite/models/produit.dart';
import 'package:fidelite/repositories/calendrierpaiement_repository.dart';
import 'package:fidelite/repositories/points_repository.dart';
import 'package:fidelite/repositories/produit_repository.dart';
import 'package:fidelite/repositories/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'beans/authenticateresponse.dart';
import 'models/calendrierpaiement.dart';
import 'models/points.dart';
import 'models/user.dart';
import 'package:http/http.dart' as https;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'objets/constants.dart';


class AuthentificationEcran extends StatefulWidget {
  const AuthentificationEcran({Key? key}) : super(key: key);
  //final https.Client client;

  @override
  State<AuthentificationEcran> createState() => _NewAuth();
}

class _NewAuth extends State<AuthentificationEcran> {

  // LINK :
  // https://api.flutter.dev/flutter/material/AlertDialog-class.html

  // A t t r i b u t e s  :
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  late bool _isLoading;
  // Initial value :
  var dropdownvalue = "Koumassi";
  String defaultGenre = "M";
  final lesGenres = ["M", "F"];
  final _userRepository = UserRepository();
  final _produitRepository = ProduitRepository();
  final _calendrierRepository = CalendrierPaiementRepository();
  final _pointsRepository = PointsRepository();
  late BuildContext dialogContext;
  bool flagSendData = false;
  bool closeAlertDialog = false;
  //late https.Client client;
  //
  String? getToken = "";
  bool user_Company = false;
  bool passwordVisible=false;



  // M E T H O D S
  @override
  void initState() {
    super.initState();

    //client = widget.client!;
    passwordVisible=true;
  }


  // Process :
  bool checkField(){
    if(emailController.text.isEmpty || pwdController.text.isEmpty){
      return true;
    }
    return false;
  }

  //
  void generateTokenSuscription() async {
    await FirebaseMessaging.instance.subscribeToTopic("fidelitycross");
    getToken = await FirebaseMessaging.instance.getToken();
    authenicatemobilecustomer();
  }


  // Send Account DATA :
  Future<void> authenicatemobilecustomer() async {
    try {
      final url = Uri.parse('${dotenv.env['URL']}authenticate');
      var response = await post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "mail": emailController.text.trim(),
            "pwd": pwdController.text.trim(),
            "fcmtoken": getToken,
            "smartphonetype": defaultTargetPlatform == TargetPlatform.android
                ? 1
                : 0
          })
      ).timeout(const Duration(seconds: timeOutValue));

      // Checks :
      if(response.statusCode == 200){
        //List<dynamic> body = jsonDecode(response.body);
        AuthenticateResponse bn = AuthenticateResponse.fromJson(jsonDecode(const Utf8Decoder().convert(response.bodyBytes)));
        // Persist user :
        User user = User(
            id: bn.id,
            nom: bn.nom,
            prenom: bn.prenom,
            email: bn.email,
            numero: bn.numero,
            adresse: bn.adresse,
            fcmtoken: getToken!,
            pwd: "");
        // Save :
        await _userRepository.insertUser(user);

        // From there, Hit NEW PRODUIT :
        for(Produit pt in bn.produits){
          try {
            Produit produit = Produit(id: pt.id,
                libelle: pt.libelle,
                prime: pt.prime);
            await _produitRepository.insert(produit);
          }
          catch (e) {
            print('Erreur : ${e.toString()}');
          }
        }
        // Persist PUBLICATION
        for(CalendrierPaiement cr in bn.calendriers){
          // First SPLIT :
          CalendrierPaiement ct = CalendrierPaiement(
              id: cr.id,
              produitId: cr.produitId,
              annee: cr.annee,
              mois: cr.mois,
              montant: cr.montant,
              paiementEffectue: cr.paiementEffectue
          );
          await _calendrierRepository.insert(ct);
        }

        // Init the TABLE
        Points point = Points(id: 1, total: 0);
        await _pointsRepository.insert(point);

        // Set FLAG :
        closeAlertDialog = false;
      }
      else{
        Fluttertoast.showToast(
            msg: "Identifiants incorrects",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
    catch (e) {
      print('Erreur : ${e.toString()}');
    }
    finally{
      // Notify :
      flagSendData = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.brown,
                        size: 80.0,
                      ),
                    ) ,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 10),
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Authentification",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )
                      ),
                    ) ,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email...',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      obscureText: passwordVisible,
                      controller: pwdController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Mot de passe...',
                        labelText: 'Mot de passe...',
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                                  () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          },
                        ),
                        alignLabelWithHint: false,
                        filled: true,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(visible: false
                            , child: ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey)
                          ),
                          label: const Text("Retour",
                              style: TextStyle(
                                  color: Colors.white
                              )),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                            color: Colors.white,
                          ),
                        ))
                        ,
                        ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.brown)
                          ),
                          label: const Text("Soumettre",
                              style: TextStyle(
                                  color: Colors.white
                              )
                          ),
                          onPressed: () {
                            if(checkField()){
                              Fluttertoast.showToast(
                                  msg: "Veuillez renseigner les champs !",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                            else{
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    dialogContext = context;
                                    return WillPopScope(
                                        onWillPop: () async => false,
                                        child: const AlertDialog(
                                            title: Text('Information'),
                                            content: SizedBox(
                                                height: 100,
                                                child: Column(
                                                  children: [
                                                    Text("Veuillez patienter ..."),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    SizedBox(
                                                        height: 30.0,
                                                        width: 30.0,
                                                        child: CircularProgressIndicator(
                                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                                          strokeWidth: 3.0, // Width of the circular line
                                                        )
                                                    )
                                                  ],
                                                )
                                            )
                                        )
                                    );
                                  }
                              );

                              // Send DATA :
                              flagSendData = true;
                              closeAlertDialog = true;
                              generateTokenSuscription();

                              // Run TIMER :
                              Timer.periodic(
                                const Duration(seconds: 1),
                                    (timer) {
                                  // Update user about remaining time
                                  if(!flagSendData){
                                    Navigator.pop(dialogContext);
                                    timer.cancel();

                                    if(!closeAlertDialog) {
                                      Navigator
                                          .push(
                                          context,
                                          MaterialPageRoute(builder:
                                              (context) =>
                                          const MyApp()
                                          )
                                      );
                                    }
                                  }
                                },
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.save,
                            size: 20,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}