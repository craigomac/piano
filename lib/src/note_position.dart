import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_position.freezed.dart';

enum Note { C, D, E, F, G, A, B }

enum Accidental { Sharp, Flat, None }

extension AccidentalName on Accidental {
  String get symbol {
    switch (this) {
      case Accidental.Sharp:
        return "♯";
      case Accidental.Flat:
        return "♭";
      case Accidental.None:
        return "";
    }
  }
}

extension NoteAccidentals on Note {
  List<Accidental> get accidentals {
    switch (this) {
      case Note.C:
        return [Accidental.Sharp];
      case Note.D:
        return [Accidental.Flat, Accidental.Sharp];
      case Note.E:
        return [Accidental.Flat];
      case Note.F:
        return [Accidental.Sharp];
      case Note.G:
        return [Accidental.Flat, Accidental.Sharp];
      case Note.A:
        return [Accidental.Flat, Accidental.Sharp];
      case Note.B:
        return [Accidental.Flat];
      default:
        return [];
    }
  }

  Note get previous =>
      (this == Note.C) ? Note.B : Note.values[Note.values.indexOf(this) - 1];

  Note get next =>
      (this == Note.B) ? Note.C : Note.values[Note.values.indexOf(this) + 1];
}

extension NoteName on Note {
  String get name {
    switch (this) {
      case Note.C:
        return "C";
      case Note.D:
        return "D";
      case Note.E:
        return "E";
      case Note.F:
        return "F";
      case Note.G:
        return "G";
      case Note.A:
        return "A";
      case Note.B:
        return "B";
    }
  }
}

@freezed
class NotePosition with _$NotePosition {
  factory NotePosition({
    required Note note,
    @Default(4) int octave,
    @Default(Accidental.None) Accidental accidental,
  }) = _NotePosition;

  static NotePosition get middleC => NotePosition(note: Note.C, octave: 4);
}

extension NotePositionHelpers on NotePosition {
  String get name => "${note.name}${accidental.symbol}$octave";

  int get pitch {
    int offset;
    switch (this.note) {
      case Note.C:
        offset = 24; // C1
        break;
      case Note.D:
        offset = 26;
        break;
      case Note.E:
        offset = 28;
        break;
      case Note.F:
        offset = 29;
        break;
      case Note.G:
        offset = 31;
        break;
      case Note.A:
        offset = 33;
        break;
      case Note.B:
        offset = 35;
    }
    if (accidental == Accidental.Flat) {
      offset -= 1;
    } else if (accidental == Accidental.Sharp) {
      offset += 1;
    }
    return offset + ((octave - 1) * 12);
  }

  NotePosition? get alternativeAccidental {
    switch (accidental) {
      case Accidental.None:
        return null;
      case Accidental.Sharp:
        // A flat is always the next note after a sharp, in the same octave
        return NotePosition(
            note: note.next, accidental: Accidental.Flat, octave: octave);
      case Accidental.Flat:
        // A sharp is always the previous note before a flat, in the same octave
        return NotePosition(
            note: note.previous, accidental: Accidental.Sharp, octave: octave);
    }
  }

  bool equalsAccidentalInsensitive(NotePosition another) =>
      note == another.note && octave == another.octave;
}
