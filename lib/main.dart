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
  int statesSelect = 1;
  String url = 'https://api.covidtracking.com/v1/us/daily.json';

  Widget statesWG(String title, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            statesSelect = index;
            if (index == 3)
              url =
                  'https://api.apify.com/v2/datasets/CUdKmb25Z3HjkoDiN/items?format=json&clean=1';
            else if (index == 2)
              url =
                  'https://api.apify.com/v2/datasets/K1mXdufnpvr53AFk6/items?format=json&clean=1';
            else if (index == 5)
              url =
                  'https://api.apify.com/v2/datasets/ugfJOQkPhQ0fvLYzN/items?format=json&clean=1';
            else if (index == 4)
              url =
                  'https://api.apify.com/v2/datasets/LQHrXhGe0EhnCFeei/items?format=json&clean=1';
            else if (index == 1)
              url = 'https://api.covidtracking.com/v1/us/daily.json';
          });
        },
        child: Container(
          height: 50,
          width: 50,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                    color: statesSelect == index
                        ? Colors.white70
                        : Colors.transparent)),
            elevation: 4,
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
        future: getCovidData(url),
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done)
            return Scrollbar(
                radius: Radius.circular(10),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          statesWG('US', 1, context),
                          statesWG('UK', 2, context),
                          statesWG('IT', 3, context),
                          statesWG('CH', 4, context),
                          statesWG('JK', 5, context),
                        ],
                      );

                    return covidWG(
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
                        context);
                  },
                ));
          else {
            return Stack(
              children: [
                snapshot.hasData
                    ? Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            statesWG('US', 1, context),
                            statesWG('UK', 2, context),
                            statesWG('IT', 3, context),
                            statesWG('CH', 4, context),
                            statesWG('JK', 5, context),
                          ],
                        ),
                      )
                    : Container(),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
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
      child: Container(
        height: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
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
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text: 'Death\n',
                              style: TextStyle(color: Colors.white70)),
                          TextSpan(
                              text: death,
                              style: TextStyle(color: Colors.purple))
                        ])),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
