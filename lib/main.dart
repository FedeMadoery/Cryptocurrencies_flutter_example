import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:random_name/activitys/coinDetails.dart';
import 'package:random_name/utils/FloatingCustomButton.dart';

void main() async {
  // Bad practice alert :). You should ideally show the UI, and probably a progress view,
  // then when the requests completes, update the UI to show the data.
  List currencies = await getCurrencies();
  print(currencies);

  runApp(new MyApp(currencies));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final List _currencies;
  MyApp(this._currencies);

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new CryptoListWidget(_currencies),
    );
  }
}

Future<List> getCurrencies() async {
  String apiUrl = 'https://api.coinmarketcap.com/v1/ticker/';
  http.Response response = await http.get(apiUrl, headers: {});
  var result = json.decode(response.body);
  return result;
}

class CryptoListWidget extends StatelessWidget {
  final List<MaterialColor> _colors = [Colors.blueGrey, Colors.indigo, Colors.blue];
  List _currencies;

  CryptoListWidget(this._currencies);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: _getAppTitleWidget(),
        body: _buildBody(context),
        backgroundColor: Colors.lightBlueAccent,
        floatingActionButton: new FancyFab(
            iconFirst: Icons.update,
            tooltipFirst: 'Update Data',
            onPressedFirst: (){
              getCurrencies().then((response) => this._currencies = response);
            },
            iconSecond: Icons.account_balance_wallet,
            tooltipSecond: 'Wallet',
            onPressedSecond: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (BuildContext context) => coinDetails(coinName: "Wallet")));
            },
        )
        );
  }


  Widget _buildBody(BuildContext context) {
    return new Container(
        child:  _getListViewWidget(context)
        );
  }

  Widget _getAppTitleWidget() {
    return new AppBar(
          title: Center(child: Text('Cryptocurrencies')),
        );
  }

  Widget _getListViewWidget(BuildContext context) {
    // We want the ListView to have the flexibility to expand to fill the
    // available space in the vertical axis
    return  new ListView.builder(
        // The number of items to show
            itemCount: _currencies.length,
        // Callback that should return ListView children
        // The index parameter = 0...(itemCount-1)
            itemBuilder: (context, index) {
              // Get the currency at this position
              final Map currency = _currencies[index];

              // Get the icon color. Since x mod y, will always be less than y,
              // this will be within bounds
              final MaterialColor color = _colors[index % _colors.length];

              return _getListItemWidget(currency, color, context);
            });
  }

  CircleAvatar _getLeadingWidget(String currencyName, MaterialColor color) {
    return new CircleAvatar(
        backgroundColor: color,
        child: new Text(currencyName),
        );
  }

  Text _getTitleWidget(String currencyName) {
    return new Text(
        currencyName,
        style: new TextStyle(fontWeight: FontWeight.bold),
        );
  }

  RichText _getSubtitleText(String priceUsd, String percentChange1h) {
    TextSpan priceTextWidget = new TextSpan(text: "\$$priceUsd\n", style:
    new TextStyle(color: Colors.black),);
    String percentChangeText = "1 hour: $percentChange1h%";
    TextSpan percentChangeTextWidget;

    if(double.parse(percentChange1h) > 0) {
      // Currency price increased. Color percent change text green
      percentChangeTextWidget = new TextSpan(text: percentChangeText,
          style: new TextStyle(color: Colors.green),);
    }
    else {
      // Currency price decreased. Color percent change text red
      percentChangeTextWidget = new TextSpan(text: percentChangeText,
          style: new TextStyle(color: Colors.red),);
    }

    return new RichText(text: new TextSpan(
        children: [
          priceTextWidget,
          percentChangeTextWidget
        ]
    ),);
  }

  ListTile _getListTile(Map currency, MaterialColor color, BuildContext context) {
    return new ListTile(
        leading: _getLeadingWidget(currency['symbol'], color),
        title: _getTitleWidget(currency['name']),
        subtitle: _getSubtitleText(
            currency['price_usd'], currency['percent_change_1h']),
        isThreeLine: true,
        onTap: (){
          Navigator.push(
              context,
              new MaterialPageRoute(builder: (BuildContext context) => coinDetails(coinName: currency['name'], coinId: currency['symbol'])));
        },
        );
  }

  Container _getListItemWidget(Map currency, MaterialColor color, BuildContext context) {
    // Returns a container widget that has a card child and a top margin of 5.0
    return new Container(
        margin: const EdgeInsets.only(top: 5.0),
        child: new Card(
            child: _getListTile(currency, color, context),
            ),
        );
  }

}