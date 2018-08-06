import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

@immutable
class CurrencyDetail {
  final time;
  final String asset_id_base;
  final String asset_id_quote;
  final double rate;

  CurrencyDetail(this.time, this.asset_id_base, this.asset_id_quote, this.rate);
}

class coinDetails extends StatelessWidget {
  String coinName;
  String coinId;
  coinDetails({this.coinName, this.coinId});

  @override
  Widget build(BuildContext context) {
    return Details(coinName: this.coinName, coinId: this.coinId);
  }

}

class Details extends StatefulWidget {
  String coinName;
  String coinId;
  Details({this.coinName, this.coinId});

  @override
  createState() => DetailsState();
}

class DetailsState extends State<Details> {

  Future<CurrencyDetail> currencyDetail;



  @override
  Widget build(BuildContext context) {
    _getCurrencyDetails();

    return new FutureBuilder(
        future: currencyDetail,
        builder: (context, AsyncSnapshot<CurrencyDetail> snapshot) {
            return Scaffold (
                appBar: AppBar(
                    title: Text(widget.coinName),
                    leading: new BackButton(),
                    ),
                body: snapshot.hasData ?
                    _bodyDetails(snapshot)
                :   new Center(
                    child: new CircularProgressIndicator(backgroundColor: Colors.red,)
                    ),
                );
          }
        );
  }

  _getCurrencyDetails() {
    String apiUrl = 'https://rest.coinapi.io/v1/exchangerate/'+ widget.coinId +'/USD';
    this.currencyDetail = http.get(apiUrl, headers: {'X-CoinAPI-Key' : '5486F2E5-D72F-4F83-AE13-ED41BDFB3971'}).then( (response) {
      var result = json.decode(response.body);
      return new CurrencyDetail(result['time'], result['asset_id_base'], result['asset_id_quote'], result['rate']);
    });
  }

  _bodyDetails(AsyncSnapshot<CurrencyDetail> snapshot) {
    return new Text(snapshot.data.rate.toString());
  }

}