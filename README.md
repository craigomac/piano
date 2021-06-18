# Piano

A Flutter package that provides:

* logic for working with musical **notes**, **clefs** and **octaves**;
* a widget that can **render notes on a clef**;
* an **interactive piano** widget.

## Where is it used?

In "Learn The Notes", a simple sight reading trainer you can find on the [iOS App Store here](https://apps.apple.com/nl/app/learn-the-notes/id1567585072?l=en) and [macOS App Store here](https://apps.apple.com/nl/app/learn-the-notes-desktop/id1567799850?l=en&mt=12).

![Example showing musical clef and interactive piano](https://raw.githubusercontent.com/craigomac/piano/main/example.png "Example")

## How do I use it?

Here's an example app:

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piano/piano.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        title: 'Piano Demo',
        home: Center(
          child: InteractivePiano(
            highlightedNotes: [
              NotePosition(note: Note.C, octave: 3)
            ],
            naturalColor: Colors.white,
            accidentalColor: Colors.black,
            keyWidth: 60,
            noteRange: NoteRange.forClefs([
              Clef.Treble,
            ]),
            onNotePositionTapped: (position) {
              // Use an audio library like flutter_midi to play the sound
            },
          ),
        ));
  }
}
```

## More like this

* I blog about Flutter here: https://handform.net/
* I'm on LinkedIn: https://www.linkedin.com/in/craigbmcmahon/
