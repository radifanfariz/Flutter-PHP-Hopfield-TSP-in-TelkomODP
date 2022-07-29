import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopfield_tsp_app/screens/main_maps_screen.dart';
import 'package:hopfield_tsp_app/screens/maps_screen.dart';
import 'package:hopfield_tsp_app/screens/about_screen.dart';

class MyBottomBar extends StatefulWidget {
  MyBottomBar({Key key}) : super(key: key);

  @override
  _MyBottomBarState createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _currentTab = 0;
  final List<Widget> screens = [];
  final PageStorageBucket _bucket = PageStorageBucket();
  Widget currentScreen = MainMapsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: _bucket,
      ),
      floatingActionButton: Container(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          child: Icon(
            Icons.location_on_sharp,
            size: 45,
          ),
          backgroundColor: Colors.red,
          onPressed: () {
            setState(() {
              currentScreen = MapsScreen();
              _currentTab = 1;
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = MainMapsScreen();
                        _currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.map_sharp,
                          size: 40,
                          color: _currentTab == 0 ? Colors.red : Colors.grey,
                        ),
                        Text(
                          "Maps",
                          style: TextStyle(
                            fontSize: 15,
                            color: _currentTab == 0 ? Colors.red : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ///// Right Tab Bar

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = AboutScreen();
                        _currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_sharp,
                          size: 40,
                          color: _currentTab == 2 ? Colors.red : Colors.grey,
                        ),
                        Text(
                          "About",
                          style: TextStyle(
                              fontSize: 15,
                              color:
                                  _currentTab == 2 ? Colors.red : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
