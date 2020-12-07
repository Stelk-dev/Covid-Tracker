import 'package:Covid_Tracking/trackingCovid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class DetailsCovidWG extends StatefulWidget {
  String path;
  String date;
  int index;
  String state;

  DetailsCovidWG({this.path, this.date, this.index, this.state});

  @override
  _DetailsCovidWGState createState() => _DetailsCovidWGState();
}

class _DetailsCovidWGState extends State<DetailsCovidWG> {
  Widget getDayDetails(AsyncSnapshot<dynamic> snapshot) {
    if (widget.state == 'US')
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
          cardInGridView('Death', snapshot.data['death'], Colors.purpleAccent),
          cardInGridView(
              'Pending', snapshot.data['pending'], Colors.amberAccent),
          cardInGridView('Hospitalize', snapshot.data['hospitalized'],
              Colors.lightBlueAccent),
          cardInGridView(
              'Recovered', snapshot.data['recovered'], Colors.lightGreenAccent),
          cardInGridView('Increased deaths', snapshot.data['deathIncrease'],
              Colors.pinkAccent),
          cardInGridView('Increased negative',
              snapshot.data['negativeIncrease'], Colors.red),
          cardInGridView('Increased positive',
              snapshot.data['positiveIncrease'], Colors.green),
        ],
      );
    else if (widget.state == 'UK')
      return GridView.count(
        padding: EdgeInsets.all(5),
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        crossAxisCount: 2,
        children: [
          if (snapshot.data[widget.index]['dailyConfirmed'] is int)
            cardInGridView(
                'Daily\nConfirmed',
                snapshot.data[widget.index]['dailyConfirmed'],
                Colors.amberAccent),
          //
          if (snapshot.data[widget.index]['dailytested'] is int)
            cardInGridView('Daily\nTested',
                snapshot.data[widget.index]['dailytested'], Colors.grey),
          if (!(snapshot.data[widget.index]['dailytested'] is int)) Container(),
          //
          if (snapshot.data[widget.index]['englandConfirmed'] is int)
            cardInGridView(
                'England\nConfirmed',
                snapshot.data[widget.index]['englandConfirmed'],
                Colors.lightGreenAccent),
          //
          if (snapshot.data[widget.index]['englandDeceased'] is int)
            cardInGridView('England\nDeceased',
                snapshot.data[widget.index]['englandDeceased'], Colors.green),
          //
          if (snapshot.data[widget.index]['scotlandConfirmed'] is int)
            cardInGridView(
                'Scotland\nConfirmed',
                snapshot.data[widget.index]['scotlandConfirmed'],
                Colors.tealAccent),
          //
          if (snapshot.data[widget.index]['scotlandDeceased'] is int)
            cardInGridView('Scotland\nDeceased',
                snapshot.data[widget.index]['scotlandDeceased'], Colors.teal),
          //
          if (snapshot.data[widget.index]['walesConfirmed'] is int)
            cardInGridView('Wales\nConfirmed',
                snapshot.data[widget.index]['walesConfirmed'], Colors.green),
          //
          if (snapshot.data[widget.index]['walesDeceased'] is int)
            cardInGridView('Wales\nDeceased',
                snapshot.data[widget.index]['walesDeceased'], Colors.green),
          //
          if (snapshot.data[widget.index]['northenIrelandConfirmed'] is int)
            cardInGridView(
                'Nothen Ireland\nConfirmed',
                snapshot.data[widget.index]['northenIrelandConfirmed'],
                Colors.deepOrangeAccent),
          //
          if (snapshot.data[widget.index]['northenIrelandDeceased'] is int)
            cardInGridView(
                'Nothen Ireland\nDeceased',
                snapshot.data[widget.index]['northenIrelandDeceased'],
                Colors.orangeAccent),
          //
          if (snapshot.data[widget.index]['tested'] is int)
            cardInGridView('Tested', snapshot.data[widget.index]['tested'],
                Colors.purpleAccent),
          //
          if (snapshot.data[widget.index]['infected'] is int)
            cardInGridView('Positive', snapshot.data[widget.index]['infected'],
                Colors.greenAccent),
          //
          if (snapshot.data[widget.index]['deceased'] is int)
            cardInGridView('Deceased', snapshot.data[widget.index]['deceased'],
                Colors.redAccent),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.date),
      ),
      body: FutureBuilder(
        future: getCovidDataDay(widget.path),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return getDayDetails(snapshot);
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
    color: Color.fromRGBO(25, 25, 25, 1),
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
