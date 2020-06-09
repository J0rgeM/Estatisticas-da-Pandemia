import 'package:flutter/material.dart';
import 'package:novel_covid_19/controllers/covid_api.dart';
import 'package:novel_covid_19/custom_widgets/virus_loader.dart';
import 'package:novel_covid_19/global.dart';
import 'package:novel_covid_19/models/country_model.dart';
import 'country_detail.dart';
import 'package:novel_covid_19/custom_widgets/my_header.dart';

class CountryListPage extends StatefulWidget {
  @override
  _CountryListPageState createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  bool _isLoading = false;
  CovidApi api = CovidApi();
  var items = List<Country>();
  var _focusNode = FocusNode();
  List<Country> _countries = List<Country>();
  var _controller = TextEditingController();
  final controller = ScrollController();
  double offset = 0;

  HomeCountry _homeCountry;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
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

  void filterSearchResults(String query) {
    List<Country> dummySearchList = List<Country>();
    dummySearchList.addAll(_countries);
    if (query.isNotEmpty) {
      List<Country> dummyListData = List<Country>();
      dummySearchList.forEach((item) {
        if (item.country.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(_countries);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                MyHeader(
                  image: "assets/images/doctor.png",
                  textTop: "COVID-19",
                  textBottom: "#stayathome",
                  offset: offset,
                ),
              /*  Image.asset(
                  "assets/images/doctor.png",
                  width: 400,
                  height: 300,
                  scale: 2,
                ),*/
              ],
            ),
            _isLoading
                ? VirusLoader()
                : _countries == null
                    ? buildErrorMessage()
                    : ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Card(
                              child: TextFormField(
                                focusNode: _focusNode,
                                controller: _controller,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Theme.of(context).accentColor,
                                    ),
                                   /* border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor)),*/
                                    labelText: 'Pesquisar',
                                    labelStyle: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    hintText: 'Introduza o nome do país'),
                                onChanged: filterSearchResults,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  var country = items[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Card(
                                      elevation: 4.0,
                                      child: ListTile(
                                        onTap: () {
                                          _controller.clear();
                                          filterSearchResults('');
                                          _focusNode.unfocus();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CountryDetailPage(
                                                      countryName:
                                                          country.country),
                                            ),
                                          );
                                        },
                                        title: Row(
                                          children: <Widget>[
                                            Text(country.country),
                                            if (_homeCountry != null &&
                                                _homeCountry.name.compareTo(
                                                        country.country) == 0)
                                              Icon(
                                                Icons.home,
                                                size: 16.0,
                                              )
                                          ],
                                        ),
                                        subtitle: Text('Casos: ' +
                                            country.cases.toString()),
                                        trailing: Icon(Icons.arrow_right),
                                      ),
                                    ),
                                  );
                                }),
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
          ],

        ),

      ),
    );

    /* appBar: AppBar(
        title: Text(
          'Países',
          //style: TextStyle(color: Theme.of(context).accentColor),
            style: TextStyle(color: Colors.white)
        ),
        leading: Icon(
          Icons.public,
          //color: Theme.of(context).accentColor,
        ),
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

  void _fetchCountries() async {
    try {
      setState(() => _isLoading = true);
      var list = await mySharedPreferences.fetchHomeCountry();
      var countries = await api.getAllCountriesInfo();
      setState(() {
        _countries = countries;
        items.addAll(_countries);
        if (list != null)
          setState(() {
            _homeCountry = HomeCountry(
              name: list[0],
              cases: list[1],
              deaths: list[2],
            );
          });
      });
    } catch (ex) {
      setState(() => _countries = null);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
