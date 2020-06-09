import 'package:flutter/material.dart';


class PersonalInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sobre',
          //style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),


      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 93.0,
                      backgroundColor: Theme.of(context).accentColor,
                      child: CircleAvatar(
                        radius: 90.0,
                        backgroundImage: NetworkImage(
                            'assets/images/doctor.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Jorge',
                        style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).accentColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text('@gmail.com',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center),
                  ],
                ),
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
                    // Text('Informações retiradas de https://www.worldometers.info/')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Text('Informações de https://www.worldometers.info'),
                 ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
