
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novel_covid_19/controllers/covid_api.dart';
import 'package:novel_covid_19/custom_widgets/constant.dart';
import 'package:novel_covid_19/custom_widgets/my_header.dart';
import 'package:novel_covid_19/custom_widgets/statistic_card.dart';
import 'package:novel_covid_19/custom_widgets/virus_loader.dart';
import 'package:novel_covid_19/global.dart';
import 'package:novel_covid_19/models/country_model.dart';
import 'package:novel_covid_19/models/global_info_model.dart';
import 'package:novel_covid_19/views/country_detail.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GlobalInfoPage extends StatefulWidget {
  @override
  _GlobalInfoPageState createState() => _GlobalInfoPageState();
}



class _GlobalInfoPageState extends State<GlobalInfoPage> {
  GlobalInfo _stats;
  double deathPercentage;
  double activePercentage;
  bool _isLoading = false;
  CovidApi api = CovidApi();
  double recoveryPercentage;
final controller = ScrollController();
double offset = 0;

  HomeCountry _homeCountry;


  @override
  void initState() {
    super.initState();
    _fetchHomeCountry();
    _fetchGlobalStats();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
      controller: controller,
      child: Column(
        children: <Widget>[
          Stack(

           children: <Widget>[

             MyHeader(
               image: "assets/images/doctor.png",
               textTop: "COVID-19 ",
               textBottom: "Estatísticas",
               offset: offset,
             ),
           ],
          ),
           SafeArea(
            child: _isLoading
                ? VirusLoader()
                : _stats == null
                ? buildErrorMessage()
                : ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: <Widget>[
                if (_homeCountry != null)
                  ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.home,
                       // color: Theme.of(context).accentColor,
                      ),
                    ),
                    title: Text(_homeCountry.name),
                    subtitle: Text(
                      _homeCountry.cases + '--' + _homeCountry.deaths,
                    ),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CountryDetailPage(
                          countryName: _homeCountry.name,
                        ),
                      ),
                    ),
                  ),
                StatisticCard(
                  color: Colors.orange,
                  text: 'Total de casos',
                  icon: Icons.timeline,
                  stats: _stats.cases,
                ),
                StatisticCard(
                  color: Colors.green,
                  text: 'Total de recuperados',
                  icon: Icons.whatshot,
                  stats: _stats.recovered,
                ),
                StatisticCard(
                  color: Colors.red,
                  text: 'Total de mortes',
                  icon: Icons.airline_seat_individual_suite,
                  stats: _stats.deaths,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 4.0,
                    child: ListTile(
                      leading: Icon(Icons.sentiment_very_dissatisfied),
                      title: Text('Percentagem de morte'),
                      trailing: Text(
                        deathPercentage.toStringAsFixed(2) + ' %',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 4.0,
                    child: ListTile(
                      leading: Icon(Icons.sentiment_very_satisfied),
                      title: Text('Percentagem de recuperação'),
                      trailing: Text(
                        recoveryPercentage.toStringAsFixed(2) + ' %',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Credits by Jorge Silva & Waleed Arshad '),
                  Icon(
                    Icons.copyright,
                   // color: Colors.blue,
                  ),
                 // Text(' in Flutter')
                ],
              ),
            ],
          ),
        ],
      ),
      ),
      );

    /* appBar: AppBar(
        title: Text(
          'COVID-19',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        leading: Icon(
          Icons.public,
          color: Theme.of(context).accentColor,
        ),
        actions: <Widget>[
          ThemeSwitch(),
        ],
      ),*/

  }

  Center buildErrorMessage() {
    return Center(
      child: Text(
        'Não foi possível buscar dados',
        style: Theme.of(context).textTheme.title.copyWith(color: Colors.grey),
      ),
    );
  }

  void _fetchGlobalStats() async {
    setState(() => _isLoading = true);
    try {
      var stats = await api.getGlobalInfo();
      deathPercentage = (stats.deaths / stats.cases) * 100;
      recoveryPercentage = (stats.recovered / stats.cases) * 100;
      activePercentage = 100 - (deathPercentage + recoveryPercentage);

      print(deathPercentage);
      print(recoveryPercentage);
      print(activePercentage);
      setState(() => _stats = stats);
    } catch (ex) {
      setState(() => _stats = null);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _fetchHomeCountry() async {
    var list = await mySharedPreferences.fetchHomeCountry();
    if (list != null) {
      setState(() {
        _homeCountry = HomeCountry(
          name: list[0],
          cases: list[1],
          deaths: list[2],
        );
      });
    }
  }
}
