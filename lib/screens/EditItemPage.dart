import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/music_model.dart';
import 'package:todo_app/scoped_models/music_scoped_model.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:todo_app/widgets/Custom_Snackbar.dart';

class EditItemPage extends StatefulWidget {
  final MusicScopedModel model;

  EditItemPage({super.key, required this.model});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListeningName = false;
  bool _isListeningAuthor = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _nameController.text = widget.model.music.song_name;
    _authorController.text = widget.model.music.author_name;
    _imageController.text = widget.model.music.song_image;
  }

  void onListenName() async {
    if (!_isListeningName && !_isListeningAuthor) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListeningName = true);
        _speech.listen(
          onResult: (val) =>
              setState(() => _nameController.text = val.recognizedWords),
        );
      }
    } else {
      setState(() {
        _isListeningName = false;
        _isListeningAuthor = false;
      });
      _speech.stop();
    }
  }

  void onListenAuthor() async {
    if (!_isListeningAuthor && !_isListeningName) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListeningAuthor = true);
        _speech.listen(
          onResult: (val) =>
              setState(() => _authorController.text = val.recognizedWords),
        );
      }
    } else {
      setState(() {
        _isListeningName = false;
        _isListeningAuthor = false;
      });
      _speech.stop();
    }
  }

  void _editMusic(BuildContext context) async {
    String name = _nameController.text;
    String author = _authorController.text;
    String image = _imageController.text;

    if (name.isEmpty || author.isEmpty || image.isEmpty) {
      customSnackbar(
          context: context,
          message: "Chưa điền đủ thông tin!",
          title: "Khoang!",
          duration: const Duration(seconds: 3),
          contentType: ContentType.warning);

      return;
    }

    Music editMusic = Music.fromMap({
      "id": widget.model.music.id,
      "song_name": name,
      "author_name": author,
      "song_image": image,
      "favourite_rating": 0
    });

    try {
      widget.model.changeMusic(editMusic);
      customSnackbar(
          context: context,
          message: "Sửa thành công",
          title: "Success!",
          duration: const Duration(seconds: 3),
          contentType: ContentType.success);
    } catch (e) {
      customSnackbar(
          context: context,
          message: e.toString(),
          title: "Sửa thất bại!",
          duration: const Duration(seconds: 3),
          contentType: ContentType.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Item Page"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // image
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: CachedNetworkImage(
                imageUrl: widget.model.music.song_image,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            // input name
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                            left: 15, bottom: 6, top: 11, right: 15),
                        hintText: "Name",
                        prefixIcon: const Icon(
                          Icons.music_note,
                          size: 20,
                        ),
                        suffixIcon: AvatarGlow(
                          animate: _isListeningName,
                          repeat: true,
                          glowColor: Colors.transparent,
                          child: IconButton(
                            onPressed: onListenName,
                            icon: Icon(
                                _isListeningName ? Icons.mic : Icons.mic_off,
                                size: 20),
                          ),
                        )),
                  )),
                ],
              ),
            ),
            // input author
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _authorController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                            left: 15, bottom: 6, top: 11, right: 15),
                        hintText: "Author",
                        prefixIcon: const Icon(
                          Icons.person,
                          size: 20,
                        ),
                        suffixIcon: AvatarGlow(
                          animate: _isListeningAuthor,
                          repeat: true,
                          glowColor: Colors.transparent,
                          child: IconButton(
                            onPressed: onListenAuthor,
                            icon: Icon(
                                _isListeningAuthor ? Icons.mic : Icons.mic_off,
                                size: 20),
                          ),
                        )),
                  )),
                ],
              ),
            ),
            // input image
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _imageController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 0, top: 5, right: 15),
                      hintText: "Image",
                      prefixIcon: Icon(
                        Icons.image,
                        size: 20,
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: ElevatedButton(
          onPressed: () => _editMusic(context),
          child: const Text("OK"),
        ),
      ),
    );
  }
}
