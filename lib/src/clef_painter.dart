import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';

import 'clef.dart';
import 'note_position.dart';
import 'note_range.dart';
import 'dart:math' as math;

class NoteImage {
  final NotePosition notePosition;
  final double offset;
  final Color? color;
  final double noteLength;
  final bool isPause;

  NoteImage({
    required this.notePosition,
    this.noteLength = 1/4,
    this.isPause = false,
    this.offset = 0.5,
    this.color,
  });
}

class ClefPainter extends CustomPainter with EquatableMixin {
  final Clef clef;

  /// The note range we'll make space for in this drawing.
  final NoteRange noteRange;

  /// The note range we'll actually draw notes for.
  final NoteRange? noteRangeToClip;
  final List<NoteImage> noteImages;
  final EdgeInsets padding;
  final int lineHeight;
  final Color clefColor;
  final Color noteColor;

  /// Satisfies `EquatableMixin` and used in shouldRepaint for redraw efficiency
  @override
  List<Object?> get props => [
        clef,
        noteRange,
        noteRangeToClip,
        noteImages,
        padding,
        lineHeight,
        clefColor,
        noteColor,
      ];

  final Paint _linePaint;
  final Paint _notePaint;
  final Paint _tailPaint;

  TextPainter? _clefSymbolPainter;
  Map<Accidental, TextPainter> _accidentalSymbolPainters = {};
  Size? _lastClefSize;
  final List<NotePosition> _naturalPositions;

  ClefPainter(
      {required this.clef,
      required this.noteRange,
      this.noteRangeToClip,
      this.noteImages = const [],
      this.padding = const EdgeInsets.all(16),
      this.clefColor = Colors.black,
      this.noteColor = Colors.black,
      this.lineHeight = 1})
      : _naturalPositions = noteRange.naturalPositions,
        _linePaint = Paint()
          ..color = clefColor
          ..strokeWidth = lineHeight.toDouble(),
        _notePaint = Paint(),
        _tailPaint = Paint()..strokeWidth = lineHeight.toDouble();

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = padding.deflateRect(Offset.zero & size);

    if (bounds.height <= 0) {
      return;
    }

    final naturalPositionOf = (notePosition) =>
        (noteRangeToClip?.contains(notePosition) == false)
            ? -1
            : _naturalPositions.indexWhere((_) =>
                _.note == notePosition.note && _.octave == notePosition.octave);

    final clefSize = Size(80, bounds.height);

    final noteHeight = bounds.height / _naturalPositions.length.toDouble();

    final firstLineIndex =
        _naturalPositions.indexOf(clef.firstLineNotePosition);
    final lastLineIndex = _naturalPositions.indexOf(clef.lastLineNotePosition);

    final firstLineIsEven = firstLineIndex % 2 == 0;

    final ovalHeight = noteHeight * 2;
    final ovalWidth = ovalHeight * 1.5;

    double? firstLineY, lastLineY;

    for (var line = firstLineIsEven ? 0 : 1;
        line < _naturalPositions.length;
        line += 2) {
      NoteImage? ledgerLineImage;
      if (line < firstLineIndex || line > lastLineIndex) {
        ledgerLineImage = line < firstLineIndex
            ? noteImages.firstWhereOrNull((_) {
                final position = naturalPositionOf(_.notePosition);
                return position != -1 && position <= line;
              })
            : noteImages.firstWhereOrNull(
                (_) => naturalPositionOf(_.notePosition) >= line);
        if (ledgerLineImage == null) {
          continue;
        }
      } else {
        ledgerLineImage = null;
      }
      final y = (bounds.height - ((line * noteHeight) - noteHeight / 2))
          .roundToDouble();
      if (ledgerLineImage != null) {
        final ledgerLineLeft = bounds.left +
            clefSize.width +
            (bounds.width - ovalWidth * 2 - clefSize.width) *
                ledgerLineImage.offset;
        final ledgerLineRight = ledgerLineLeft + ovalWidth * 1.6;
        canvas.drawLine(
            Offset(ledgerLineLeft, y), Offset(ledgerLineRight, y), _linePaint);
      } else {
        canvas.drawLine(
            Offset(bounds.left, y), Offset(bounds.right, y), _linePaint);

        if (firstLineY == null) {
          firstLineY = y;
        }
        lastLineY = y;
      }
    }

    final tailHeight = 7;
    final middleLineIndex =
        (firstLineIndex + (lastLineIndex - firstLineIndex - 1) / 2).floor();

    for (final noteImage in noteImages) {

      ///
      ///Draw a Pause
      ///
      if (noteImage.notePosition.octave == -1 /*NotePosition.pause*/) {
        Rect rect;

        _notePaint.color = noteImage.color ?? noteColor;
        if (noteImage.noteLength >= (2 / 4)) {                                  ///Draw Whole or Half PAUSE
          var pos = naturalPositionOf(NotePosition(note: Note.C, octave: 5 ));
          var top = noteImage.noteLength < 4/4
              ? bounds.height - (pos * noteHeight)
              : bounds.height - (pos * noteHeight) - noteHeight / 2 ;

          rect = Rect.fromLTWH(
              bounds.left +
                  clefSize.width +
                  (bounds.width - ovalWidth * 1.5 - clefSize.width) * noteImage.offset,
              top,
              ovalWidth,
              ovalHeight/2);

          _notePaint.style = PaintingStyle.fill;
          _notePaint.strokeWidth = 1.0;

          canvas.save();
          canvas.translate(rect.left, rect.top + noteHeight * 0.3);
          canvas.drawRect(Offset.zero & rect.size, _notePaint);
          canvas.restore();

        } else if (noteImage.noteLength >= (1 / 4))  {                          ///Draw quarter PAUSE

          var pos = naturalPositionOf(NotePosition(note: Note.E, octave: 5 ));
          var top = bounds.height - (pos * noteHeight);

          rect = Rect.fromLTWH(
              bounds.left +
                  clefSize.width +
                  (bounds.width - ovalWidth * 1.5 - clefSize.width) *
                      noteImage.offset,
              top,
              ovalWidth,
              ovalHeight*4);

          _notePaint.style = PaintingStyle.stroke;
          _notePaint.strokeWidth = 1.0;
          print ("draw 4er pause rect=$rect");

          canvas.save();


          canvas.translate(rect.left, rect.top + noteHeight * 0.3);
          //canvas.drawRect(Offset.zero & rect.size, _notePaint);
          var w = rect.width*4/5;
          var h = rect.height;
          canvas.drawLine(Offset.zero,Offset(w,h/4), _notePaint);
          _notePaint.strokeWidth = 5.0;
          canvas.drawLine(Offset(w,h/4),Offset(0,h/2), _notePaint);
          _notePaint.strokeWidth = 1.0;
          canvas.drawLine(Offset(0,h/2),Offset(w,h*3/4), _notePaint);
          _notePaint.strokeWidth = 4.0;
          canvas.drawArc(Rect.fromPoints(Offset(w*3/2,h),Offset(0,h*3/4)),math.pi, math.pi/2,false, _notePaint);
          _notePaint.strokeWidth = 1.0;
          canvas.restore();

        } else if (noteImage.noteLength >= (1 / 8)) {                            ///Draw 8th PAUSE

          var pos = naturalPositionOf(NotePosition(note: Note.C, octave: 5 ));
          var top = bounds.height - (pos * noteHeight);

          rect = Rect.fromLTWH(
              bounds.left +
                  clefSize.width +
                  (bounds.width - ovalWidth * 1.5 - clefSize.width) *
                      noteImage.offset,
              top,
              ovalWidth,
              ovalHeight*2.6);

          _notePaint.style = PaintingStyle.stroke;
          _notePaint.strokeWidth = 1.0;
          print ("draw 8th pause rect=$rect");

          canvas.save();

          canvas.translate(rect.left, rect.top + noteHeight * 0.3);
          //canvas.drawRect(Offset.zero & rect.size, _notePaint);
          var w = rect.width*4/5;
          var h = rect.height;
          canvas.drawLine(Offset(w,0),Offset(0,h), _notePaint);
          _notePaint.style = PaintingStyle.fill;
          canvas.drawCircle(Offset(0,0), w/4, _notePaint);
          _notePaint.style = PaintingStyle.stroke;
          canvas.drawArc(Rect.fromPoints(Offset(0,0),Offset(w*3/4, h/4)), 0,math.pi, false, _notePaint);
          _notePaint.strokeWidth = 1.0;
          canvas.restore();

        }   else if (noteImage.noteLength >= (1 / 16)) {                            ///Draw 16th PAUSE

          var pos = naturalPositionOf(NotePosition(note: Note.C, octave: 5 ));
          var top = bounds.height - (pos * noteHeight);

          rect = Rect.fromLTWH(
              bounds.left +
                  clefSize.width +
                  (bounds.width - ovalWidth * 1.5 - clefSize.width) *
                      noteImage.offset,
              top,
              ovalWidth,
              ovalHeight*2.6);

          _notePaint.style = PaintingStyle.stroke;
          _notePaint.strokeWidth = 1.0;
          print ("draw 16th pause rect=$rect");

          canvas.save();

          canvas.translate(rect.left, rect.top + noteHeight * 0.3);
          //canvas.drawRect(Offset.zero & rect.size, _notePaint);
          var w = rect.width*4/5;
          var h = rect.height;
          canvas.drawLine(Offset(w,0),Offset(0,h), _notePaint);
          _notePaint.style = PaintingStyle.fill;
          canvas.drawCircle(Offset(0,0), w/4, _notePaint);
          _notePaint.style = PaintingStyle.stroke;
          canvas.drawArc(Rect.fromPoints(Offset(0,0),Offset(w*3/4, h/4)), 0,math.pi, false, _notePaint);
          _notePaint.style = PaintingStyle.fill;
          canvas.drawCircle(Offset(0,h*1/3), w/4, _notePaint);
          _notePaint.style = PaintingStyle.stroke;
            canvas.drawArc(Rect.fromPoints(Offset(w/2, h*1/3),Offset(0,h/2)), 0,math.pi, false, _notePaint);
          _notePaint.strokeWidth = 1.0;
          canvas.restore();

        } else if (noteImage.noteLength >= (1 / 32)) {                            ///Draw 32th PAUSE

          var pos = naturalPositionOf(NotePosition(note: Note.D, octave: 5 ));
          var top = bounds.height - (pos * noteHeight);

          rect = Rect.fromLTWH(
              bounds.left +
                  clefSize.width +
                  (bounds.width - ovalWidth * 1.5 - clefSize.width) *
                      noteImage.offset,
              top,
              ovalWidth,
              ovalHeight*3);

          _notePaint.style = PaintingStyle.stroke;
          _notePaint.strokeWidth = 1.0;
          print ("draw 16th pause rect=$rect");

          canvas.save();

          canvas.translate(rect.left, rect.top + noteHeight * 0.3);
          //canvas.drawRect(Offset.zero & rect.size, _notePaint);
          var w = rect.width*4/5;
          var h = rect.height;
          canvas.drawLine(Offset(w,0),Offset(0,h), _notePaint);
          _notePaint.style = PaintingStyle.fill;
          canvas.drawCircle(Offset(0,0), w/4, _notePaint);
          _notePaint.style = PaintingStyle.stroke;
          canvas.drawArc(Rect.fromPoints(Offset(0,0),Offset(w*3/4, h/4)), 0,math.pi, false, _notePaint);
          _notePaint.style = PaintingStyle.fill;
          canvas.drawCircle(Offset(0,h*1/3), w/4, _notePaint);
          _notePaint.style = PaintingStyle.stroke;
          canvas.drawArc(Rect.fromPoints(Offset(w/2, h*1/3),Offset(0,h/2)), 0,math.pi, false, _notePaint);
          _notePaint.style = PaintingStyle.fill;
          canvas.drawCircle(Offset(0,h*3/5), w/4, _notePaint);
          _notePaint.style = PaintingStyle.stroke;
          canvas.drawArc(Rect.fromPoints(Offset(w/3 , h*3/5),Offset(0,h*4/5)), 0,math.pi, false, _notePaint);

          _notePaint.strokeWidth = 1.0;
          canvas.restore();

        } else if (noteImage.noteLength >= (1 / 64)) {                            ///Draw 64th PAUSE

          var pos = naturalPositionOf(NotePosition(note: Note.E, octave: 5 ));
          var top = bounds.height - (pos * noteHeight);

          rect = Rect.fromLTWH(
              bounds.left +
                  clefSize.width +
                  (bounds.width - ovalWidth * 1.5 - clefSize.width) *
                      noteImage.offset,
              top,
              ovalWidth,
              ovalHeight*3.5);

          _notePaint.style = PaintingStyle.stroke;
          _notePaint.strokeWidth = 1.0;
          print ("draw 16th pause rect=$rect");

          canvas.save();

          canvas.translate(rect.left, rect.top + noteHeight * 0.3);
          //canvas.drawRect(Offset.zero & rect.size, _notePaint);
          var w = rect.width*4/5;
          var h = rect.height;
          canvas.drawLine(Offset(w,0),Offset(w/4  ,h), _notePaint);
          _notePaint.style = PaintingStyle.fill;
          canvas.drawCircle(Offset(0,0), w/4, _notePaint);
          _notePaint.style = PaintingStyle.stroke;
          canvas.drawArc(Rect.fromPoints(Offset(0,0),Offset(w*3/4, h/4)), 0,math.pi, false, _notePaint);
          _notePaint.style = PaintingStyle.fill;
          canvas.drawCircle(Offset(0,h*1/3), w/4, _notePaint);
          _notePaint.style = PaintingStyle.stroke;
          canvas.drawArc(Rect.fromPoints(Offset(w/2, h*3/10),Offset(0,h*5/10)), 0,math.pi, false, _notePaint);
          _notePaint.style = PaintingStyle.fill;
          canvas.drawCircle(Offset(0,h*3/5), w/4, _notePaint);
          _notePaint.style = PaintingStyle.stroke;
          canvas.drawArc(Rect.fromPoints(Offset(w/2 , h*5/10),Offset(0,h*6.6/10)), 0,math.pi, false, _notePaint);
          _notePaint.style = PaintingStyle.fill;
          canvas.drawCircle(Offset(0,h*8/10), w/4, _notePaint);
          _notePaint.style = PaintingStyle.stroke;
          //canvas.drawArc(Rect.fromPoints(Offset(w/4 , h*7/10),Offset(0,h*9/10)), 0,math.pi, false, _notePaint);

          _notePaint.strokeWidth = 1.0;
          canvas.restore();

        } else {                                                                 /// Draw WIP Pause
          var pos = naturalPositionOf(NotePosition(note: Note.C, octave: 5 ));
          rect = Rect.fromLTWH(
              bounds.left +
                  clefSize.width +
                  (bounds.width - ovalWidth * 1.5 - clefSize.width) *
                      noteImage.offset,
              bounds.height - (pos * noteHeight) - noteHeight / 2,
              ovalWidth,
              ovalHeight/16/noteImage.noteLength);

          _notePaint.style = PaintingStyle.stroke;
          _notePaint.strokeWidth = 1.0;

          canvas.save();
          canvas.translate(rect.left, rect.top + noteHeight * 0.3);
          canvas.drawRect(Offset.zero & rect.size, _notePaint);
          canvas.restore();

        }


      } else { //Draw a Note

        final noteIndex = naturalPositionOf(noteImage.notePosition);
        if (noteIndex == -1) {
          continue;
        }

        final ovalRect = Rect.fromLTWH(
            bounds.left +
                clefSize.width +
                (bounds.width - ovalWidth * 1.5 - clefSize.width) *
                    noteImage.offset,
            bounds.height - (noteIndex * noteHeight) - noteHeight / 2,
            ovalWidth,
            ovalHeight);
        canvas.save();
        canvas.translate(ovalRect.left, ovalRect.top + noteHeight * 0.3);
        canvas.rotate(-0.2);
        _notePaint.color = noteImage.color ?? noteColor;

        if (noteImage.noteLength >= (2 / 4)) {
          _notePaint.style = PaintingStyle.stroke;
          _notePaint.strokeWidth = 2.0;
        } else {
          _notePaint.style = PaintingStyle.fill;
          _notePaint.strokeWidth = 1.0;
        }

        canvas.drawOval(Offset.zero & ovalRect.size, _notePaint);
        canvas.restore();
        canvas.drawArc(ovalRect, 0, 2, false,
            _notePaint); //figo per abbellire minime e semiminime!

        final isOnOrAboveMiddleLine = noteIndex > middleLineIndex;

        final Offset tailFrom, tailTo;

        if (isOnOrAboveMiddleLine) {
          // Tail hangs down, on the left side
          tailFrom = ovalRect.centerLeft -
              Offset(-_tailPaint.strokeWidth / 2 - ovalWidth * 0.06,
                  -ovalHeight * 0.1);
          tailTo = tailFrom + Offset(0, noteHeight * tailHeight);
        } else {
          // Tail stucks up, on the right side
          tailFrom = ovalRect.centerRight +
              Offset(-_tailPaint.strokeWidth / 2 + ovalWidth * 0.06,
                  -ovalHeight * 0.1);
          tailTo = tailFrom + Offset(0, -noteHeight * tailHeight);
        }

        _tailPaint.color = noteImage.color ?? noteColor;
        if (noteImage.noteLength < 4 / 4) {
          canvas.drawLine(tailFrom, tailTo, _tailPaint);
        }

        if (noteImage.noteLength < 1 / 4) {
          final arcRect = Rect.fromLTWH(
              tailTo.dx - ovalWidth / 2,
              isOnOrAboveMiddleLine ? tailTo.dy - ovalHeight : tailTo.dy,
              //bounds.height - (noteIndex * noteHeight) - noteHeight / 2,
              ovalWidth * 3 / 2,
              ovalHeight //tailHeight.toDouble()
          );
          _tailPaint.strokeWidth = 0.25;
          canvas.drawArc(
              arcRect, 0, isOnOrAboveMiddleLine ? 2 : -2, false, _tailPaint);
        }

        if (noteImage.noteLength < 1 / 8) {
          final arcRect = Rect.fromLTWH(
              tailTo.dx - ovalWidth / 2,
              isOnOrAboveMiddleLine ? tailTo.dy - ovalHeight * 3 / 2 : tailTo
                  .dy + ovalHeight / 2,
              //bounds.height - (noteIndex * noteHeight) - noteHeight / 2,
              ovalWidth * 3 / 2,
              ovalHeight //tailHeight.toDouble()
          );
          _tailPaint.strokeWidth = 0.25;
          canvas.drawArc(
              arcRect, 0, isOnOrAboveMiddleLine ? 2 : -2, false, _tailPaint);
        }

        if (noteImage.noteLength < 1 / 16) {
          final arcRect = Rect.fromLTWH(
              tailTo.dx - ovalWidth / 2,
              isOnOrAboveMiddleLine ? tailTo.dy - ovalHeight * 2 : tailTo.dy +
                  ovalHeight,
              //bounds.height - (noteIndex * noteHeight) - noteHeight / 2,
              ovalWidth * 3 / 2,
              ovalHeight //tailHeight.toDouble()
          );
          _tailPaint.strokeWidth = 0.25;
          canvas.drawArc(
              arcRect, 0, isOnOrAboveMiddleLine ? 2 : -2, false, _tailPaint);
        }

        if (noteImage.noteLength < 1 / 32) {
          final arcRect = Rect.fromLTWH(
              tailTo.dx - ovalWidth / 2,
              isOnOrAboveMiddleLine ? tailTo.dy - ovalHeight * 2.5 : tailTo.dy +
                  ovalHeight * 1.5,
              //bounds.height - (noteIndex * noteHeight) - noteHeight / 2,
              ovalWidth * 3 / 2,
              ovalHeight //tailHeight.toDouble()
          );
          _tailPaint.strokeWidth = 0.25;
          canvas.drawArc(
              arcRect, 0, isOnOrAboveMiddleLine ? 2 : -2, false, _tailPaint);
        }


        if (noteImage.notePosition.accidental != Accidental.None) {
          if (_accidentalSymbolPainters[noteImage.notePosition.accidental] ==
              null) {
            _accidentalSymbolPainters[noteImage.notePosition.accidental] =
            TextPainter(
                text: TextSpan(
                    text: noteImage.notePosition.accidental.symbol,
                    style: TextStyle(
                        fontSize: ovalHeight * 2,
                        color: noteImage.color ?? noteColor)),
                textDirection: TextDirection.ltr)
              ..layout();
          }

          _accidentalSymbolPainters[noteImage.notePosition.accidental]?.paint(
              canvas,
              ovalRect.topLeft.translate(
                -ovalHeight,
                -ovalHeight / 2,
              ));
        }
      }
    } //!isPause

    if (firstLineY == null || lastLineY == null) {
      return;
    }

    final clefHeight = (firstLineY - lastLineY);
    final clefSymbolOffset = (clef == Clef.Treble) ? 0.45 : 0.08;

    if (_clefSymbolPainter == null || clefSize != _lastClefSize) {
      final clefSymbolScale = (clef == Clef.Treble) ? 2.35 : 1.34;
      _clefSymbolPainter = TextPainter(
          text: TextSpan(
              text: clef.symbol,
              style: TextStyle(
                  fontSize: clefHeight * clefSymbolScale, color: clefColor)),
          textDirection: TextDirection.ltr)
        ..layout();
    }
    _lastClefSize = clefSize;

    _clefSymbolPainter?.paint(
        canvas, Offset(bounds.left, lastLineY - clefSymbolOffset * clefHeight));
  }

  @override
  bool shouldRepaint(covariant ClefPainter oldDelegate) => oldDelegate != this;
}
