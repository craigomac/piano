import 'note_position.dart';

enum Clef {
  Bass,
  Alto,
  Treble,
}

extension ClefSymbols on Clef {
  String get symbol {
    switch (this) {
      case Clef.Treble:
        return "𝄞";
      case Clef.Bass:
        return "𝄢";
      case Clef.Alto:
        return "𝄡";
    }
  }
}

extension ClefNotePositions on Clef {
  NotePosition get firstLineNotePosition {
    switch (this) {
      case Clef.Bass:
        return NotePosition(note: Note.G, octave: 2);
      case Clef.Alto:
        return NotePosition(note: Note.F, octave: 3);
      case Clef.Treble:
        return NotePosition(note: Note.E, octave: 4);
    }
  }

  NotePosition get lastLineNotePosition {
    switch (this) {
      case Clef.Bass:
        return NotePosition(note: Note.A, octave: 3);
      case Clef.Alto:
        return NotePosition(note: Note.G, octave: 4);
      case Clef.Treble:
        return NotePosition(note: Note.F, octave: 5);
    }
  }
}
