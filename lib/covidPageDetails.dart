import 'package:Covid_Tracking/trackingCovid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class DetailsCovidWG extends StatefulWidget {
  String path;
  String date;
  int index;
  String state;
  List data;

  DetailsCovidWG({this.path, this.date, this.index, this.state, this.data});

  @override
  _DetailsCovidWGState createState() => _DetailsCovidWGState();
}

class _DetailsCovidWGState extends State<DetailsCovidWG> {
  List<Widget> japanRegion(List data) {
    if (data[0].length < 1) {
      return [
        for (var i in data[1])
          cardInGridView(i[0], i[1] != null ? i[1] : 0, i[2])
      ];
    } else {
      return [
        for (int i = 0; i < 2; i++)
          cardInGridView(data[1][i][0],
              data[1][i][1] != null ? data[1][i][1] : 0, data[1][i][2]),
        for (var i in data[0])
          cardInGridView(
              i['region'],
              i['infectedCount'] != null ? i['infectedCount'] : 0,
              Colors.lightBlueAccent)
      ];
    }
  }

  Widget getDayDetails(List data) {
    if (widget.state == 'UK')
      return GridView.count(
        padding: EdgeInsets.all(5),
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        crossAxisCount: 2,
        children: [
          for (var i in data)
            if (i[1] is int)
              cardInGridView(
                i[0],
                i[1],
                i[2],
              ),
        ],
      );
    else if (widget.state == 'IT')
      return GridView.count(
        padding: EdgeInsets.all(5),
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        crossAxisCount: 2,
        children: [
          for (var i in data)
            cardInGridView(
              i[0],
              i[1],
              i[2],
            )
        ],
      );
    else if (widget.state == 'CH')
      return GridView.count(
        padding: EdgeInsets.all(5),
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        crossAxisCount: 2,
        children: [
          for (var i in data)
            cardInGridView(
              i[0],
              i[1],
              i[2],
            )
        ],
      );
    else if (widget.state == 'JP')
      return GridView.count(
          padding: EdgeInsets.all(5),
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          crossAxisCount: 2,
          children: japanRegion(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.date),
      ),
      body: widget.state == 'US' //API US (different way of function)
          ? FutureBuilder(
              future: getCovidDataDay(widget.path),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return GridView.count(
                    padding: EdgeInsets.all(5),
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    crossAxisCount: 2,
                    children: [
                      cardInGridView('Positive', snapshot.data['positive'],
                          Colors.greenAccent),
                      cardInGridView('Negative', snapshot.data['negative'],
                          Colors.redAccent),
                      cardInGridView(
                          'Death', snapshot.data['death'], Colors.purpleAccent),
                      cardInGridView('Pending', snapshot.data['pending'],
                          Colors.amberAccent),
                      cardInGridView(
                          'Hospitalize',
                          snapshot.data['hospitalized'],
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
            )
          : getDayDetails(widget.data),
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
