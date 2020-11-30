import 'package:Covid_Tracking/covidPageDetails.dart';
import 'package:flutter/material.dart';
import 'trackingCovid.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    darkTheme: ThemeData.dark(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Covid Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: getCovidData(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return ListView.builder(
                itemCount: snapshot.data.length,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                itemExtent: 120,
                itemBuilder: (context, index) => covidWG(
                    snapshot.data[index]['dateChecked'].substring(0, 10),
                    MoneyMaskedTextController(
                            initialValue:
                                snapshot.data[index]['positive'].toDouble(),
                            decimalSeparator: '',
                            thousandSeparator: '.',
                            precision: 0)
                        .text,
                    MoneyMaskedTextController(
                            initialValue:
                                snapshot.data[index]['negative'].toDouble(),
                            decimalSeparator: '',
                            thousandSeparator: '.',
                            precision: 0)
                        .text,
                    MoneyMaskedTextController(
                            initialValue:
                                snapshot.data[index]['death'].toDouble(),
                            decimalSeparator: '',
                            thousandSeparator: '.',
                            precision: 0)
                        .text,
                    snapshot.data[index]['date'].toString(),
                    context));
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

// Widget case
Widget covidWG(String day, String pos, String neg, String death, String pathURL,
    BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DetailsCovidWG(
        path: pathURL,
        date: day,
      ),
    )),
    child: Card(
      color: Color.fromRGBO(25, 25, 25, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              day,
              style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w700,
                  fontSize: 17),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: 'Positive\n',
                            style: TextStyle(color: Colors.white70)),
                        TextSpan(
                            text: pos, style: TextStyle(color: Colors.green))
                      ])),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: 'Negative\n',
                            style: TextStyle(
                              color: Colors.white70,
                            )),
                        TextSpan(
                            text: neg,
                            style: TextStyle(
                              color: Colors.red,
                            ))
                      ])),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: 'Death\n',
                            style: TextStyle(color: Colors.white70)),
                        TextSpan(
                            text: death, style: TextStyle(color: Colors.purple))
                      ])),
            ],
          )
        ],
      ),
    ),
  );
}
