// ignore_for_file: avoid_print, unused_import, use_build_context_synchronously

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import "package:avatar_glow/avatar_glow.dart";
import 'package:todo_app/models/music_model.dart';
import 'package:todo_app/repositories/music_repository.dart';
import 'package:todo_app/utils/global.dart';
import 'package:todo_app/widgets/Custom_Snackbar.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListeningName = false;
  bool _isListeningAuthor = false;
  late MusicRepository musicRepository;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    musicRepository = MusicRepository();
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

  void _addMusic(BuildContext context) async {
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

    // Add music
    Music newMusic = Music.fromMap({
      "song_name": name,
      "author_name": author,
      "song_image": image,
      "favourite_rating": 0
    });
    try {
      await musicRepository.addMusic(newMusic);
      isChangedListMusic = true;
      customSnackbar(
          context: context,
          message: "Thêm thành công",
          title: "Success!",
          duration: const Duration(seconds: 3),
          contentType: ContentType.success);

      setState(() {
        _nameController.text = "";
        _authorController.text = "";
        _imageController.text = "";
      });
    } catch (e) {
      customSnackbar(
          context: context,
          message: e.toString(),
          title: "Thêm thất bại!",
          duration: const Duration(seconds: 3),
          contentType: ContentType.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = AdaptiveTheme.of(context).mode.isDark;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        print("vao $didPop $result");
        result = "hello";
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Music"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 140,
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: GlossyContainer(
                height: double.infinity,
                width: double.infinity,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              "Thêm Music",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.deepPurple,
                              ),
                            ),
                          )),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white)),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter music name",
                                  prefixIcon: const Icon(
                                    Icons.music_note,
                                    size: 20,
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    maxHeight: 20,
                                    minWidth: 40,
                                  ),
                                  suffixIcon: AvatarGlow(
                                    animate: _isListeningName,
                                    repeat: true,
                                    glowColor: Colors.transparent,
                                    child: IconButton(
                                      onPressed: onListenName,
                                      icon: Icon(
                                          _isListeningName
                                              ? Icons.mic
                                              : Icons.mic_off,
                                          size: 20),
                                    ),
                                  ),
                                  suffixIconConstraints: const BoxConstraints(
                                    maxHeight: 40,
                                    minWidth: 20,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white)),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _authorController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter author name",
                                  prefixIcon: const Icon(
                                    Icons.people,
                                    size: 20,
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    maxHeight: 20,
                                    minWidth: 40,
                                  ),
                                  suffixIcon: AvatarGlow(
                                    animate: _isListeningAuthor,
                                    repeat: true,
                                    glowColor: Colors.transparent,
                                    child: IconButton(
                                      onPressed: onListenAuthor,
                                      icon: Icon(
                                          _isListeningAuthor
                                              ? Icons.mic
                                              : Icons.mic_off,
                                          size: 20),
                                    ),
                                  ),
                                  suffixIconConstraints: const BoxConstraints(
                                    maxHeight: 40,
                                    minWidth: 20,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white)),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _imageController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter image link",
                                  prefixIcon: Icon(
                                    Icons.image,
                                    size: 20,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    maxHeight: 20,
                                    minWidth: 40,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary),
            onPressed: () => _addMusic(context),
            child: const Text("Add Music"),
          ),
        ),
      ),
    );
  }
}
