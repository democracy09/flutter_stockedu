import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class StoreUser extends ChangeNotifier {
  int balance = 0;
  List<dynamic> holdings = [];
  Set<String> tickers = {};
  Set<dynamic> sumList = {};

  defineUser() async {
    var result = {};
    List<String> list = [];
    List<dynamic> sum = [];
    // find user document from email
    await firestore.collection('users').doc(auth.currentUser!.email).get()
        .then((value) => result.addAll(value.data()!))
        .onError((error, stackTrace) => print(error));
    balance = result['balance'];
    holdings = result['holdings'];
    if(holdings.isEmpty){
      tickers.clear();
    }else{
      // get tickers from holdings
      for (var element in holdings) {
        list.add(element['ticker']);
      }
      tickers.addAll(list.toSet());
      // get holdings summary
      for (var element in holdings){
        var sumResult = {};
        await firestore.collection('stocks').doc(element['ticker']).collection('data')
            .orderBy('date', descending: true).limit(1).get()
            .then((value) => sumResult.addAll(value.docs.first.data()))
            .catchError((error) => print(error));
        await firestore.collection('stocks').doc(element['ticker']).get()
            .then((value) {
              sumResult.addAll(value.data()!);
        }).catchError((error) => print(error));
        sum.add(sumResult);
      }
      sumList.clear();
      sumList.addAll(sum);
    }
    notifyListeners();
  }

  updateBalance(int number) async {
    balance = number;
   await firestore.collection('users').doc(auth.currentUser!.email).update({
     'balance': number,
   }).then((value) => print('update balance'))
    .onError((error, stackTrace) => print('error occurs'));
   defineUser();
   print('updated Balance: $balance');
   notifyListeners();
  }

  updateCount(int count, int index, ticker)async{
    if(count <= 0){
      tickers.remove(ticker);
      holdings.removeAt(index);
    }else {
      holdings[index]['count'] = count;
    }
    await firestore.collection('users').doc(auth.currentUser!.email).update({
      'holdings': holdings,
    }).then((value) => print('update count'))
        .onError((error, stackTrace) => print(stackTrace));
    print('count updated holdings: ${holdings}');
    print('count updated tickers: ${tickers}');
    //defineUser();
    notifyListeners();
  }

  addHolding(int count, String ticker) async {
    Map<String, Object> addItem = {
      'ticker': ticker,
      'count': count,
    };
    holdings.add(addItem);
    await firestore.collection('users').doc(auth.currentUser!.email).update({
      'holdings': holdings,
    });
    //defineUser();
    notifyListeners();
  }


}