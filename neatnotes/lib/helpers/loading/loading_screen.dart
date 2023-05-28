import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neatnotes/helpers/loading/loading_screen_controller.dart';


class LoadingScreen {
  //Singleton pattern
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();
  factory LoadingScreen() => _shared;

  LoadingScreenController? controller;

  //Show loading screen
  void show({required BuildContext context, required String text}) {
    if (controller?.update(text) ?? false) {
      //Nothing to do because update is successful since we have a controller
      return;
    } else {
      //Update not successful. Means we do not have a controller
      controller = showOverlay(context: context, text: text);
    }
  }

  //Hide loading screen
  void hide() {
    controller?.close();
    controller = null;
  }

  //Show overlay
  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text
  }) {
    //This stream controller listens to a stream of strings, where each snapshot
    //is the text to be displayed in the loading screen
    final _text = StreamController<String>();
    _text.add(text);

    final renderBox = context.findRenderObject() as RenderBox; //Allows us to extract the available size that the overlay can have on the screen
    final size = renderBox.size;

    //Create the overlay
    final overlay = OverlayEntry(builder: (context) {
      //Wrap overlay in a material widget to provide styling to it
      return Material(
        color: Colors.black.withAlpha(150), //Paint screen slightly black
        child: Center(child: Container(
          //Dialogue consumes at most 80% of available screen size, and at least 50%
          constraints: BoxConstraints(
            maxWidth: size.width * 0.8,
            maxHeight: size.height * 0.8,
            minWidth: size.width * 0.5),
          //Border around dialogues
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, //Prevents column from taking up full height
                mainAxisAlignment: MainAxisAlignment.center, //Vertically align content
                children: [
                 const SizedBox(height: 10), //Margin at the top
                 const CircularProgressIndicator(),
                 const SizedBox(height: 20),
                 StreamBuilder(
                  stream: _text.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data as String, textAlign: TextAlign.center);
                    } else {
                      return Container();
                    }
                  })
                ]
              )
            ), //Allows vertical scrolling to prevent content clip
          ),
        ),
        )
      );
    });
  
    //Use the overlay
    final state = Overlay.of(context); //Need the state to display the overlay
    state.insert(overlay);

    return LoadingScreenController(close: () {
      _text.close(); //Close stream controller
      overlay.remove(); //Remove overlay
      return true;
      }, update: (text) {
        _text.add(text); //Add event to stream
        return true;
      });
  
  }
}