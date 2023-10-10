import 'package:flutter_test/flutter_test.dart';

import 'package:piano/piano.dart';

void main() {
  test('Can generate natural note positions from ranges', () {
    final first = NotePosition(note: Note.C, octave: 3);
    final last = NotePosition(note: Note.C, octave: 5);
    final range = NoteRange(from: first, to: last);

    final positions = range.naturalPositions;

    expect(positions.length, equals(15));
    expect(positions.first, equals(first));
    expect(positions.last, equals(last));
  });
}
