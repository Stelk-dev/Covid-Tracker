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
  String dateSaved =
      ''; // Data precedente per non stampare lo stesso giorno più volte
  Widget statesWG(String title, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            statesSelect = index;
            switch (index) {
              case 1:
                url = 'https://api.covidtracking.com/v1/us/daily.json';
                break;
              case 2:
                url =
                    'https://api.apify.com/v2/datasets/K1mXdufnpvr53AFk6/items?format=json&clean=1';
                break;
              case 3:
                url =
                    'https://api.apify.com/v2/datasets/CUdKmb25Z3HjkoDiN/items?format=json&clean=1';
                break;
              case 4:
                url =
                    'https://api.apify.com/v2/datasets/LQHrXhGe0EhnCFeei/items?format=json&clean=1';
                break;
              case 5:
                url =
                    'https://api.apify.com/v2/datasets/ugfJOQkPhQ0fvLYzN/items?format=json&clean=1';
                break;
            }
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

  Widget getDataDay(AsyncSnapshot<dynamic> snapshot, int index) {
    if (statesSelect == 1)
      return covidWG(
          ['Positive', 'Negative', 'Death'],
          index,
          'US',
          snapshot.data[index]['dateChecked'].substring(0, 10),
          MoneyMaskedTextController(
                  initialValue: snapshot.data[index]['positive'].toDouble(),
                  decimalSeparator: '',
                  thousandSeparator: '.',
                  precision: 0)
              .text,
          MoneyMaskedTextController(
                  initialValue: snapshot.data[index]['negative'].toDouble(),
                  decimalSeparator: '',
                  thousandSeparator: '.',
                  precision: 0)
              .text,
          MoneyMaskedTextController(
                  initialValue: snapshot.data[index]['death'].toDouble(),
                  decimalSeparator: '',
                  thousandSeparator: '.',
                  precision: 0)
              .text,
          snapshot.data[index]['date'].toString(),
          [],
          context);
    else if (statesSelect == 2) {
      index = snapshot.data.length - index - 1;
      // There are a couple of junk data
      if (snapshot.data[index]['lastUpdatedAtApify'] == null ||
          !(snapshot.data[index]['deceased'] is int) ||
          index == 547 ||
          index < 45) {
        return Container();
      }
      dateSaved =
          snapshot.data[index - 1]['lastUpdatedAtApify'].substring(0, 10);
      return snapshot.data[index]['lastUpdatedAtApify'].substring(0, 10) !=
              dateSaved
          ? snapshot.data[index]['infected'] != null
              ? covidWG(
                  ['Positive', 'Daily Confirmed', 'Death'],
                  index,
                  'UK',
                  snapshot.data[index]['lastUpdatedAtApify'].substring(0, 10),
                  MoneyMaskedTextController(
                          initialValue:
                              snapshot.data[index]['infected'].toDouble(),
                          decimalSeparator: '',
                          thousandSeparator: '.',
                          precision: 0)
                      .text,
                  MoneyMaskedTextController(
                          initialValue:
                              snapshot.data[index]['dailyConfirmed'].toDouble(),
                          decimalSeparator: '',
                          thousandSeparator: '.',
                          precision: 0)
                      .text,
                  MoneyMaskedTextController(
                          initialValue:
                              snapshot.data[index]['deceased'].toDouble(),
                          decimalSeparator: '',
                          thousandSeparator: '.',
                          precision: 0)
                      .text,
                  'K1mXdufnpvr53AFk6',
                  [
                    [
                      'Daily\nTested',
                      snapshot.data[index]['dailytested'],
                      Colors.grey
                    ],
                    [
                      'Daily\nConfirmed',
                      snapshot.data[index]['dailyConfirmed'],
                      Colors.redAccent
                    ],
                    [
                      'England\nConfirmed',
                      snapshot.data[index]['englandConfirmed'],
                      Colors.green
                    ],
                    [
                      'England\nDeceased',
                      snapshot.data[index]['englandDeceased'],
                      Colors.tealAccent
                    ],
                    [
                      'Scotland\nConfirmed',
                      snapshot.data[index]['scotlandConfirmed'],
                      Colors.teal
                    ],
                    [
                      'Scotland\nDeceased',
                      snapshot.data[index]['scotlandDeceased'],
                      Colors.teal
                    ],
                    [
                      'Wales\nConfirmed',
                      snapshot.data[index]['walesConfirmed'],
                      Colors.green
                    ],
                    [
                      'Wales\nDeceased',
                      snapshot.data[index]['walesDeceased'],
                      Colors.greenAccent[400]
                    ],
                    [
                      'Nothen Ireland\nConfirmed',
                      snapshot.data[index]['northenIrelandConfirmed'],
                      Colors.deepOrangeAccent
                    ],
                    [
                      'Nothen Ireland\nDeceased',
                      snapshot.data[index]['northenIrelandDeceased'],
                      Colors.orangeAccent
                    ],
                    [
                      'Tested',
                      snapshot.data[index]['tested'],
                      Colors.deepOrangeAccent
                    ],
                    [
                      'Positive',
                      snapshot.data[index]['infected'],
                      Colors.green
                    ],
                    ['Death', snapshot.data[index]['deceased'], Colors.purple],
                  ],
                  context)
              : Container()
          : Container();
    } else if (statesSelect == 3) {
      index = snapshot.data.length - index - 1;
      dateSaved = index >= 1
          ? snapshot.data[index - 1]['lastUpdatedAtApify'].substring(0, 10)
          : '';
      if (!(snapshot.data[index]['totalPositive'] is int) ||
          !(snapshot.data[index]['totalCases'] is int)) return Container();
      return snapshot.data[index]['lastUpdatedAtApify'].substring(0, 10) !=
              dateSaved
          ? covidWG(
              ['Tamponi', 'Positive', 'Death'],
              index,
              'IT',
              snapshot.data[index]['lastUpdatedAtApify'].substring(0, 10),
              MoneyMaskedTextController(
                      initialValue: snapshot.data[index]['tamponi'].toDouble(),
                      decimalSeparator: '',
                      thousandSeparator: '.',
                      precision: 0)
                  .text,
              MoneyMaskedTextController(
                      initialValue:
                          snapshot.data[index]['totalPositive'].toDouble(),
                      decimalSeparator: '',
                      thousandSeparator: '.',
                      precision: 0)
                  .text,
              MoneyMaskedTextController(
                      initialValue: snapshot.data[index]['deceased'].toDouble(),
                      decimalSeparator: '',
                      thousandSeparator: '.',
                      precision: 0)
                  .text,
              'CUdKmb25Z3HjkoDiN',
              [
                ['Tamponi', snapshot.data[index]['tamponi'], Colors.green],
                [
                  'Total\nCases',
                  snapshot.data[index]['totalCases'],
                  Colors.lightBlueAccent
                ],
                [
                  'Positive',
                  snapshot.data[index]['totalPositive'],
                  Colors.redAccent
                ],
                [
                  'New\nPositive',
                  snapshot.data[index]['newPositive'],
                  Colors.lightGreenAccent
                ],
                ['Death', snapshot.data[index]['deceased'], Colors.purple],
                [
                  'Total\nHospitalized',
                  snapshot.data[index]['totalHospitalized'],
                  Colors.blueGrey
                ],
                [
                  'Insulation\nHome',
                  snapshot.data[index]['homeInsulation'],
                  Colors.brown
                ],
                [
                  'Recovered',
                  snapshot.data[index]['dischargedHealed'],
                  Colors.deepOrangeAccent
                ],
              ],
              context)
          : Container();
    } else if (statesSelect == 4) {
      index = snapshot.data.length - index - 1;
      if (index < 58 || index < 0 || (index >= 239 && index <= 251))
        return Container();
      dateSaved =
          snapshot.data[index - 1]['lastUpdatedAtApify'].substring(0, 10);
      //Data corrupt
      return snapshot.data[index]['lastUpdatedAtApify'].substring(0, 10) !=
              dateSaved
          ? covidWG(
              ['Positive', 'Recovered', 'Death'],
              index,
              'CH',
              snapshot.data[index]['lastUpdatedAtApify'].substring(0, 10),
              MoneyMaskedTextController(
                      initialValue: double.parse(
                          snapshot.data[index]['infected'].toString()),
                      decimalSeparator: '',
                      thousandSeparator: '.',
                      precision: 0)
                  .text,
              MoneyMaskedTextController(
                      initialValue: double.parse(
                          snapshot.data[index]['recovered'].toString()),
                      decimalSeparator: '',
                      thousandSeparator: '.',
                      precision: 0)
                  .text,
              MoneyMaskedTextController(
                      initialValue: double.parse(
                          snapshot.data[index]['deceased'].toString()),
                      decimalSeparator: '',
                      thousandSeparator: '.',
                      precision: 0)
                  .text,
              'LQHrXhGe0EhnCFeei',
              [
                [
                  'Positive',
                  int.parse(snapshot.data[index]['infected'].toString()),
                  Colors.greenAccent
                ],
                [
                  'Recovered',
                  int.parse(snapshot.data[index]['recovered'].toString()),
                  Colors.lightBlueAccent
                ],
                [
                  'Death',
                  int.parse(snapshot.data[index]['deceased'].toString()),
                  Colors.redAccent
                ],
                [
                  'New\nConfirmed',
                  snapshot.data[index]['currentConfirmedCount'] != null
                      ? int.parse(snapshot.data[index]['currentConfirmedCount']
                          .toString())
                      : snapshot.data[index]['activeCases'],
                  Colors.lightGreenAccent
                ]
              ],
              context)
          : Container();
    } else if (statesSelect == 5) {
      index = snapshot.data.length - index - 1;
      if (index < 19) return Container();
      dateSaved =
          snapshot.data[index - 1]['lastUpdatedAtApify'].substring(0, 10);
      //Data corrupt
      return snapshot.data[index]['lastUpdatedAtApify'].substring(0, 10) !=
              dateSaved
          ? covidWG(
              [
                'Positive',
                snapshot.data[index]['recovered'] != null ? 'Recovered' : '',
                'Death'
              ],
              index,
              'JP',
              snapshot.data[index]['lastUpdatedAtApify'].substring(0, 10),
              MoneyMaskedTextController(
                      initialValue: snapshot.data[index]['infected'].toDouble(),
                      decimalSeparator: '',
                      thousandSeparator: '.',
                      precision: 0)
                  .text,
              snapshot.data[index]['recovered'] != null
                  ? MoneyMaskedTextController(
                          initialValue:
                              snapshot.data[index]['recovered'].toDouble(),
                          decimalSeparator: '',
                          thousandSeparator: '.',
                          precision: 0)
                      .text
                  : '',
              MoneyMaskedTextController(
                      initialValue: snapshot.data[index]['deceased'].toDouble(),
                      decimalSeparator: '',
                      thousandSeparator: '.',
                      precision: 0)
                  .text,
              'ugfJOQkPhQ0fvLYzN',
              [
                snapshot.data[index]['infectedByRegion'],
                [
                  ['Positive', snapshot.data[index]['infected'], Colors.green],
                  [
                    'Recovered',
                    snapshot.data[index]['recovered'],
                    Colors.redAccent
                  ],
                  ['Death', snapshot.data[index]['deceased'], Colors.purple],
                  [
                    'Tested',
                    snapshot.data[index]['tested'],
                    Colors.lightGreenAccent
                  ]
                ]
              ],
              context)
          : Container();
    }
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
          if (snapshot.connectionState == ConnectionState.done)
            return Scrollbar(
                radius: Radius.circular(10),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              statesWG('US', 1, context),
                              statesWG('UK', 2, context),
                              statesWG('IT', 3, context),
                              statesWG('CH', 4, context),
                              statesWG('JP', 5, context),
                            ],
                          ),
                          getDataDay(snapshot, index)
                        ],
                      );
                    return getDataDay(snapshot, index);
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
                            statesWG('JP', 5, context),
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
Widget covidWG(
    List<String> keys,
    int index,
    String state,
    String day,
    String pos,
    String neg,
    String death,
    String pathURL,
    List data,
    BuildContext context) {
  return GestureDetector(
    onTap: () => state == 'US'
        ? Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailsCovidWG(
              path: 'https://api.covidtracking.com/v1/us/' + pathURL + '.json',
              date: day,
              state: state,
            ),
          ))
        : Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailsCovidWG(
              path: 'https://api.apify.com/v2/datasets/' +
                  pathURL +
                  '/items?format=json&clean=1',
              date: day,
              index: index,
              state: state,
              data: data,
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
                              text: '${keys[0]}\n',
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
                              text: '${keys[1]}\n',
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
                              text: '${keys[2]}\n',
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
