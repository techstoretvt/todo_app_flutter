import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animations/animations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/music_model.dart';
import 'package:todo_app/repositories/music_repository.dart';
import 'package:todo_app/screens/AddItemPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Music> musics = [];
  MusicRepository musicRepository = MusicRepository();

  @override
  void initState() {
    super.initState();
    _loadMusics();
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      context.setLocale(locale);
    });
  }

  void _loadMusics() async {
    final data = await musicRepository.fetchAllMusic();

    setState(() {
      musics = data;
    });
  }

  void _clickBtn() async {
    // await musicRepository.addMusic(Music(
    //   song_name: "test",
    //   author_name: "test",
    //   favourite_rating: 0,
    //   song_image: "test",
    // ));
    // _loadMusics();
  }

  void _addItem(BuildContext context) async {
    Navigator.of(context).pushNamed('/addItem');
    // if (isAdd) {
    // } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_sharp, color: Colors.deepPurple),
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (Locale locale) {
              _changeLanguage(locale);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<Locale>(
                value: Locale('en'),
                child: Text('English'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('vi'),
                child: Text('Tiếng Việt'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(context.tr("hello")),
            Text(
              '$_counter',
            ),
            for (int i = 0; i < musics.length; i++)
              ListTile(
                title: Text(
                  '${musics[i].song_name} ${musics[i].id}',
                  style: TextStyle(
                      color: AdaptiveTheme.of(context).mode.isDark
                          ? Colors.white
                          : Colors.deepPurple),
                ),
                subtitle: Text(musics[i].author_name),
              )
          ],
        ),
      ),
      floatingActionButton: OpenContainer(
        closedColor: Colors.transparent,
        transitionType: ContainerTransitionType.fadeThrough,
        transitionDuration: const Duration(milliseconds: 1000),
        openBuilder: (BuildContext context, VoidCallback _) {
          return const AddItemPage();
        },
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return FloatingActionButton(
            onPressed: () {
              // _addItem(context);
              openContainer();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        },
        onClosed: (data) => print(data),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.favorite,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.settings,
            size: 30,
            color: Colors.white,
          ),
        ],
        color: Colors.deepPurple,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
