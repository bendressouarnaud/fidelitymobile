import 'dart:async';
import 'package:fidelite/echeancepaiement.dart';
import 'package:fidelite/services/amountseparator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_formatter/money_formatter.dart';

import 'objets/constants.dart';

class ReglerPolice extends StatefulWidget {
  // Attribute :
  ReglerPolice({Key? key}) : super(key: key);

  @override
  State<ReglerPolice> createState() => _HReglerPolice();
}

class _HReglerPolice extends State<ReglerPolice> {
  // A t t r i b u t e s  :
  TextEditingController numeroController = TextEditingController();
  TextEditingController montantController = TextEditingController();
  late BuildContext dialogContext;
  bool flagSendData = false;
  bool closeAlertDialog = false;


  // M E T H O D S :
  @override
  void initState() {
    //
    super.initState();
  }

  String formatPrice(double price){
    MoneyFormatter fmf = MoneyFormatter(
        amount: price
    );
    return fmf.output.withoutFractionDigits;
  }

  // Process :
  bool checkField(){
    if(numeroController.text.isEmpty || montantController.text.isEmpty){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text('Régler Police',
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
                  child: const Text('Renseigner la police et le montant'),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 3, left: 15, right: 15),
                    child: const Divider(
                      height: 2,
                      color: Colors.black,
                    )
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: numeroController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Numéro...',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: montantController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      ThousandsSeparatorInputFormatter(),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Montant...',
                    ),
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                        fontSize: 20
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateColor.resolveWith((states) => Colors.blueGrey)
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
                      ),
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
                            //generateTokenSuscription();

                            // Run TIMER :
                            Timer.periodic(
                              const Duration(seconds: 1),
                                  (timer) {
                                // Update user about remaining time
                                if(!flagSendData){
                                  Navigator.pop(dialogContext);
                                  timer.cancel();

                                  if(!closeAlertDialog) {
                                    // Kill ACTIVITY :
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
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
            )
        )
    );
  }
}