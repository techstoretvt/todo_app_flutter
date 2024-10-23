import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animations/animations.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo_app/models/music_model.dart';
import 'package:todo_app/repositories/music_repository.dart';
import 'package:todo_app/scoped_models/music_scoped_model.dart';
import 'package:todo_app/screens/AddItemPage.dart';
import 'package:todo_app/screens/EditItemPage.dart';
import 'package:todo_app/utils/global.dart';
import 'package:todo_app/widgets/Custom_Snackbar.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';

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
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  var _cartQuantityItems = 0;
//   final GlobalKey widgetKey = GlobalKey();

  List<Music> musics = [];
  MusicRepository musicRepository = MusicRepository();

  @override
  void initState() {
    super.initState();
    musicRepository = MusicRepository();
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

  void _onChangeFavouriteRating(MusicScopedModel model, double rating) async {
    Music music = model.music;
    music.updateRating(rating.toInt());

    model.changeMusic(music);
  }

  void _handeDelete(MusicScopedModel model) async {
    try {
      model.delete();
      _loadMusics();
      customSnackbar(
          context: context,
          message: "Xóa thành công",
          title: "Success!",
          duration: const Duration(seconds: 3),
          contentType: ContentType.success);
    } catch (e) {
      customSnackbar(
          context: context,
          message: e.toString(),
          title: "Xóa thất bại!",
          duration: const Duration(seconds: 3),
          contentType: ContentType.warning);
    }
  }

  void listClick(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);
    await cartKey.currentState!
        .runCartAnimation((++_cartQuantityItems).toString());
  }

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      cartKey: cartKey,
      height: 30,
      width: 30,
      opacity: 0.85,
      dragAnimation: const DragToCartAnimationOptions(
        rotation: true,
      ),
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (runAddToCartAnimation) {
        this.runAddToCartAnimation = runAddToCartAnimation;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget.title,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          actions: [
            AddToCartIcon(
              key: cartKey,
              icon: const Icon(Icons.favorite_sharp, color: Colors.redAccent),
              badgeOptions: const BadgeOptions(
                active: false,
              ),
            ),
            IconButton(
              onPressed: () {
                if (AdaptiveTheme.of(context).mode.isDark) {
                  AdaptiveTheme.of(context).setLight();
                } else {
                  AdaptiveTheme.of(context).setDark();
                }
              },
              icon: AdaptiveTheme.of(context).mode.isDark
                  ? const Icon(
                      Icons.dark_mode,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.light_mode,
                      color: Colors.white,
                    ),
            ),
            PopupMenuButton<Locale>(
              icon: Icon(Icons.language,
                  color: Theme.of(context).colorScheme.onPrimary),
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
        body: musics.isEmpty
            ? Center(child: Text(context.tr('nodata')))
            : ListView(
                children: List.generate(musics.length, (i) {
                  final GlobalKey widgetKey = GlobalKey();
                  return ScopedModel<MusicScopedModel>(
                    model: MusicScopedModel(musics[i]),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      height: 100,
                      child: ScopedModelDescendant<MusicScopedModel>(
                        builder: (context, child, model) => OpenContainer(
                          tappable: false,
                          closedColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          transitionType: ContainerTransitionType.fade,
                          transitionDuration:
                              const Duration(milliseconds: 1000),
                          openBuilder: (BuildContext context, VoidCallback _) {
                            return EditItemPage(model: model);
                          },
                          closedBuilder: (BuildContext context,
                              VoidCallback openContainer) {
                            return Slidable(
                              key: const ValueKey(0),
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) => openContainer(),
                                    backgroundColor: Colors.orangeAccent,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Sửa',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      _handeDelete(model);
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Xóa',
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            model.music.song_name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            ),
                                          ),
                                          subtitle: Text(
                                            model.music.author_name,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                          leading: Container(
                                            key: widgetKey,
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10))),
                                            child: CachedNetworkImage(
                                              imageUrl: model.music.song_image
                                                  .toString(),
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: RatingBar.builder(
                                            initialRating: model
                                                .music.favourite_rating
                                                .toDouble(),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star_border,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              _onChangeFavouriteRating(
                                                  model, rating);
                                            },
                                            itemSize: 20,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: IconButton(
                                      onPressed: () {
                                        listClick(widgetKey);
                                      },
                                      icon: const Icon(Icons.favorite),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ),
        floatingActionButton: OpenContainer(
          closedColor: Theme.of(context).colorScheme.inversePrimary,
          transitionType: ContainerTransitionType.fadeThrough,
          transitionDuration: const Duration(milliseconds: 1000),
          openBuilder: (BuildContext context, VoidCallback _) {
            return const AddItemPage();
          },
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
            return InkWell(
              onTap: openContainer,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: const Center(child: Icon(Icons.add)),
              ),
            );
          },
          onClosed: (data) {
            if (isChangedListMusic) {
              // load list
              _loadMusics();
              isChangedListMusic = false;
            }
          },
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
      ),
    );
  }
}
