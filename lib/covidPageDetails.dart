import 'package:Covid_Tracking/trackingCovid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class DetailsCovidWG extends StatefulWidget {
  String path;
  String date;

  DetailsCovidWG({this.path, this.date});

  @override
  _DetailsCovidWGState createState() => _DetailsCovidWGState();
}

class _DetailsCovidWGState extends State<DetailsCovidWG> {
  String url;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      url = 'https://api.covidtracking.com/v1/us/' + widget.path + '.json';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.date),
      ),
      body: FutureBuilder(
        future: getCovidDataDay(url),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return GridView.count(
              padding: EdgeInsets.all(5),
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              crossAxisCount: 2,
              children: [
                cardInGridView(
                    'Positive', snapshot.data['positive'], Colors.greenAccent),
                cardInGridView(
                    'Negative', snapshot.data['negative'], Colors.redAccent),
                cardInGridView(
                    'Death', snapshot.data['death'], Colors.purpleAccent),
                cardInGridView(
                    'Pending', snapshot.data['pending'], Colors.amberAccent),
                cardInGridView('Hospitalize', snapshot.data['hospitalized'],
                    Colors.lightBlueAccent),
                cardInGridView('Recovered', snapshot.data['recovered'],
                    Colors.lightGreenAccent),
                cardInGridView('Increased deaths',
                    snapshot.data['deathIncrease'], Colors.pinkAccent),
                cardInGridView('Increased negative',
                    snapshot.data['negativeIncrease'], Colors.red),
                cardInGridView('Increased positive',
                    snapshot.data['positiveIncrease'], Colors.green),
              ],
            );
          else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}

Widget cardInGridView(String title, int number, Color color) {
  return Card(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          MoneyMaskedTextController(
                  initialValue: number.toDouble(),
                  decimalSeparator: '',
                  thousandSeparator: '.',
                  precision: 0)
              .text,
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: color),
        )
      ],
    ),
  );
}
