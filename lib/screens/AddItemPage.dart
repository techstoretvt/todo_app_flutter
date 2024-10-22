// ignore_for_file: avoid_print, unused_import

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import "package:avatar_glow/avatar_glow.dart";

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

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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

    // Navigator.pop(context, true);

    if (name.isEmpty || author.isEmpty || image.isEmpty) {
      return;
    }

    // Add music
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
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
                              color:
                                  isDarkMode ? Colors.white : Colors.deepPurple,
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
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            onPressed: () => _addMusic(context),
            child: const Text("Add Music"),
          ),
        ),
      ),
    );
  }
}
