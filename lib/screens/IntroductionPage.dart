import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:todo_app/screens/HomePage.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MyHomePage(title: 'ToDoApp')),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/images/anh5.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
          image: DecorationImage(
            image: AssetImage('assets/images/$assetName'),
            fit: BoxFit.cover,
          )),
      // child: FittedBox(
      //     fit: BoxFit.cover,
      //     child: Image.asset('assets/images/$assetName', width: width)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return SafeArea(
      child: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,
        allowImplicitScrolling: true,
        autoScrollDuration: 5000,
        infiniteAutoScroll: false,
        // globalHeader: Align(
        //   alignment: Alignment.topRight,
        //   child: SafeArea(
        //     child: Padding(
        //       padding: const EdgeInsets.only(top: 16, right: 16),
        //       child: _buildImage('anh2.jpg', 100),
        //     ),
        //   ),
        // ),
        globalFooter: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            child: const Text(
              'Let\'s go right away!',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            onPressed: () => _onIntroEnd(context),
          ),
        ),
        pages: [
          PageViewModel(
            title: "Fractional shares",
            body:
                "Instead of having to buy an entire share, invest any amount you want.",
            image: _buildImage('anh2.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Learn as you go",
            body:
                "Download the Stockpile app and master the market with our mini-lesson.",
            image: _buildImage('anh8.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Kids and teens",
            body:
                "Kids and teens can track their stocks 24/7 and place trades that you approve.",
            image: _buildImage('anh3.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Full Screen Page",
            body:
                "Pages can be full screen as well.\nLorem ipsum dolor sit amet, consectetur adipiscing elit.",
            image: _buildFullscreenImage(),
            decoration: pageDecoration.copyWith(
              contentMargin: const EdgeInsets.symmetric(horizontal: 16),
              fullScreen: true,
              bodyFlex: 2,
              imageFlex: 3,
              safeArea: 100,
            ),
          ),
          PageViewModel(
            title: "Another title page",
            body: "Another beautiful body text for this example onboarding",
            image: _buildImage('anh4.jpg'),
            footer: ElevatedButton(
              onPressed: () {
                introKey.currentState?.animateScroll(0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'FooButton',
                style: TextStyle(color: Colors.white),
              ),
            ),
            decoration: pageDecoration.copyWith(
              bodyFlex: 6,
              imageFlex: 6,
              safeArea: 80,
            ),
          ),
          PageViewModel(
            title: "Title of last page - reversed",
            bodyWidget: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Click on ", style: bodyStyle),
                Icon(Icons.edit),
                Text(" to edit a post", style: bodyStyle),
              ],
            ),
            decoration: pageDecoration.copyWith(
              bodyFlex: 2,
              imageFlex: 4,
              bodyAlignment: Alignment.bottomCenter,
              imageAlignment: Alignment.topCenter,
            ),
            image: _buildImage('anh6.jpg'),
            reverse: true,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context),
        showSkipButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: false,
        //rtl: true, // Display as right-to-left
        back: const Icon(Icons.arrow_back),
        skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          color: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}
