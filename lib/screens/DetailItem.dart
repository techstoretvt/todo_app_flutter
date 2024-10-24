import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';
import 'package:todo_app/models/music_model.dart';

class DetailItem extends StatelessWidget {
  const DetailItem({super.key, required this.music});
  final Music music;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Details"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: GlossyContainer(
            height: 220,
            width: double.infinity,
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                // image
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 10),
                    child: CachedNetworkImage(
                      imageUrl: music.song_image,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                          padding: const EdgeInsets.all(30),
                          child: const CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    music.song_name,
                    style: TextStyle(
                      color: AdaptiveTheme.of(context).mode.isDark
                          ? Colors.black
                          : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    music.author_name,
                    style: TextStyle(
                      color: AdaptiveTheme.of(context).mode.isDark
                          ? Colors.black
                          : Colors.white,
                      fontSize: 15,
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
