import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'note_position.dart';
import 'note_range.dart';

typedef OnNotePositionTapped = void Function(NotePosition position);

/// Renders a scrollable interactive piano.
class InteractivePiano extends StatefulWidget {
  /// The range of notes to create interactive keys for.
  final NoteRange noteRange;

  /// The range of notes to highlight.
  final List<NotePosition> highlightedNotes;

  /// The color with which to draw highlighted notes; blended with the color of the key.
  final Color highlightColor;

  /// Color to render "natural" notes—typically white.
  final Color naturalColor;

  /// Color to render "accidental" notes (sharps and flats)—typically black.
  final Color accidentalColor;

  /// Whether to apply a repeating press animation to highlighted notes.
  final bool animateHighlightedNotes;

  /// Whether to treat tapped notes as flats instead of sharps. Affects the value passed to `onNotePositionTapped`.
  final bool useAlternativeAccidentals;

  /// Whether to hide note names on keys.
  final bool hideNoteNames;

  /// Whether to hide the scroll bar, that appears below the keys.
  final bool hideScrollbar;

  /// Leave as `null` to have keys sized automatically to fit the width of the widget.
  final double? keyWidth;

  /// Callback for interacting with piano keys.
  final OnNotePositionTapped? onNotePositionTapped;

  /// Set and change at any time (i.e. with `setState`) to cause the piano to scroll so that the desired note is centered.
  final NotePosition? noteToScrollTo;

  /// See individual parameters for more information. The only required parameter
  /// is `noteRange`. Since the widget wraps a scroll view and therefore has no
  /// "intrinsic" size, be sure to use inside a parent that specifies one.
  ///
  /// For example:
  /// ```
  /// SizedBox(
  ///   width: 300,
  ///   height: 100,
  ///   child: InteractivePiano(
  ///     noteRange: NoteRange.forClefs(
  ///       [Clef.Treble],
  ///       extended: true
  ///     )
  ///   )
  /// )
  /// ```
  ///
  /// Normally you'll want to pass `keyWidth`—if you don't, the entire range of notes
  /// will be squashed into the width of the widget.
  const InteractivePiano(
      {Key? key,
      required this.noteRange,
      this.highlightedNotes = const [],
      this.highlightColor = Colors.red,
      this.naturalColor = Colors.white,
      this.accidentalColor = Colors.black,
      this.animateHighlightedNotes = false,
      this.useAlternativeAccidentals = false,
      this.hideNoteNames = false,
      this.hideScrollbar = false,
      this.onNotePositionTapped,
      this.noteToScrollTo,
      this.keyWidth})
      : super(key: key);

  @override
  _InteractivePianoState createState() => _InteractivePianoState();
}

class _InteractivePianoState extends State<InteractivePiano> {
  /// We group notes into blocks of contiguous accidentals, since they need to be stacked
  late List<List<NotePosition>> _noteGroups;

  ScrollController? _scrollController;
  double _lastWidth = 0.0, _lastKeyWidth = 0.0;

  @override
  void initState() {
    _updateNotePositions();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InteractivePiano oldWidget) {
    if (oldWidget.noteRange != widget.noteRange ||
        oldWidget.useAlternativeAccidentals !=
            widget.useAlternativeAccidentals) {
      _updateNotePositions();
    }

    final noteToScrollTo = widget.noteToScrollTo;
    if (noteToScrollTo != null && oldWidget.noteToScrollTo != noteToScrollTo) {
      _scrollController?.animateTo(
          _computeScrollOffsetForNotePosition(noteToScrollTo),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut);
    }

    super.didUpdateWidget(oldWidget);
  }

  double _computeScrollOffsetForNotePosition(NotePosition notePosition) {
    final closestNatural = notePosition.copyWith(accidental: Accidental.None);

    final int index = widget.noteRange.naturalPositions.indexOf(closestNatural);

    if (index == -1 || _lastWidth == 0.0 || _lastKeyWidth == 0.0) {
      return 0.0;
    }

    return (index * _lastKeyWidth + _lastKeyWidth / 2 - _lastWidth / 2);
  }

  _updateNotePositions() {
    final notePositions = widget.noteRange.allPositions;

    if (widget.useAlternativeAccidentals) {
      for (int i = 0; i < notePositions.length; i++) {
        notePositions[i] =
            notePositions[i].alternativeAccidental ?? notePositions[i];
      }
    }

    _noteGroups = notePositions
        .splitBeforeIndexed((index, _) =>
            _.accidental == Accidental.None &&
            notePositions[index - 1].accidental == Accidental.None)
        .toList();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.black,
        padding: const EdgeInsets.only(top: 2, bottom: 10),
        child: Center(
          child: LayoutBuilder(builder: (context, constraints) {
            _lastWidth = constraints.maxWidth;

            final numberOfKeys = widget.noteRange.naturalPositions.length;
            _lastKeyWidth = widget.keyWidth ?? (_lastWidth - 2) / numberOfKeys;

            if (_scrollController == null) {
              double scrollOffset = _computeScrollOffsetForNotePosition(
                  widget.noteToScrollTo ?? NotePosition.middleC);
              _scrollController =
                  ScrollController(initialScrollOffset: scrollOffset);
            }

            final showScrollbar = !widget.hideScrollbar &&
                (numberOfKeys * _lastKeyWidth) > _lastWidth;

            return _MaybeScrollbar(
                scrollController: showScrollbar ? _scrollController : null,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: widget.hideScrollbar
                        ? const NeverScrollableScrollPhysics()
                        : const ClampingScrollPhysics(),
                    itemCount: _noteGroups.length,
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final naturals = _noteGroups[index]
                          .where((_) => _.accidental == Accidental.None);
                      final accidentals = _noteGroups[index]
                          .where((_) => _.accidental != Accidental.None);

                      return Stack(
                        children: [
                          Row(
                            children: naturals
                                .map((note) => _PianoKey(
                                    notePosition: note,
                                    color: widget.naturalColor,
                                    hideNoteName: widget.hideNoteNames,
                                    isAnimated: widget
                                            .animateHighlightedNotes &&
                                        widget.highlightedNotes.contains(note),
                                    highlightColor:
                                        widget.highlightedNotes.contains(note)
                                            ? widget.highlightColor
                                            : null,
                                    keyWidth: _lastKeyWidth,
                                    onTap: _onNoteTapped(note)))
                                .toList(),
                          ),
                          Positioned(
                              top: 0.0,
                              bottom: 0.0,
                              left:
                                  _lastKeyWidth / 2.0 + (_lastKeyWidth * 0.02),
                              child: FractionallySizedBox(
                                  alignment: Alignment.topCenter,
                                  heightFactor: 0.55,
                                  child: Row(
                                    children: accidentals
                                        .map(
                                          (note) => _PianoKey(
                                            notePosition: note,
                                            color: widget.accidentalColor,
                                            hideNoteName: widget.hideNoteNames,
                                            isAnimated: widget
                                                    .animateHighlightedNotes &&
                                                widget.highlightedNotes
                                                    .contains(note),
                                            highlightColor: widget
                                                    .highlightedNotes
                                                    .contains(note)
                                                ? widget.highlightColor
                                                : null,
                                            keyWidth: _lastKeyWidth,
                                            onTap: _onNoteTapped(note),
                                          ),
                                        )
                                        .toList(),
                                  ))),
                        ],
                      );
                    }));
          }),
        ),
      );

  void Function()? _onNoteTapped(NotePosition notePosition) =>
      widget.onNotePositionTapped == null
          ? null
          : () => widget.onNotePositionTapped!(notePosition);
}

class _PianoKey extends StatefulWidget {
  final NotePosition notePosition;
  final double keyWidth;
  final BorderRadius _borderRadius;
  final bool hideNoteName;
  final VoidCallback? onTap;
  final bool isAnimated;

  final Color _color;

  _PianoKey({
    Key? key,
    required this.notePosition,
    required this.keyWidth,
    required this.hideNoteName,
    required this.onTap,
    required this.isAnimated,
    required Color color,
    Color? highlightColor,
  })  : _borderRadius = BorderRadius.only(
            bottomLeft: Radius.circular(keyWidth * 0.2),
            bottomRight: Radius.circular(keyWidth * 0.2)),
        _color = (highlightColor != null)
            ? Color.lerp(color, highlightColor, 0.5) ?? highlightColor
            : color,
        super(key: key);

  @override
  __PianoKeyState createState() => __PianoKeyState();
}

class __PianoKeyState extends State<_PianoKey>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    const animationBegin = 1.0;
    const animationEnd = 0.95;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    _animation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: animationBegin, end: animationEnd)
            .chain(CurveTween(curve: Curves.decelerate)),
        weight: 30.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: animationEnd, end: animationBegin)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 20.0,
      ),
      TweenSequenceItem(tween: ConstantTween(animationBegin), weight: 50)
    ]).animate(_controller);

    _startOrStopAnimation();
  }

  @override
  void didUpdateWidget(covariant _PianoKey oldWidget) {
    if (widget.isAnimated != oldWidget.isAnimated) {
      _startOrStopAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _startOrStopAnimation() {
    if (widget.isAnimated) {
      _controller.repeat(reverse: false);
    } else {
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        width: widget.keyWidth,
        padding: EdgeInsets.symmetric(
            horizontal: (widget.keyWidth *
                    (widget.notePosition.accidental == Accidental.None
                        ? 0.02
                        : 0.04))
                .ceilToDouble()),
        child: ScaleTransition(
          scale: _animation,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Semantics(
                  button: true,
                  hint: widget.notePosition.name,
                  child: Material(
                      borderRadius: widget._borderRadius,
                      elevation:
                          widget.notePosition.accidental != Accidental.None
                              ? 3.0
                              : 0.0,
                      shadowColor: Colors.black,
                      color: widget._color,
                      child: InkWell(
                        borderRadius: widget._borderRadius,
                        highlightColor: Colors.grey,
                        onTap: widget.onTap == null ? null : () {},
                        onTapDown: widget.onTap == null
                            ? null
                            : (_) {
                                widget.onTap!();
                              },
                      ))),
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: widget.keyWidth / 3,
                child: IgnorePointer(
                  child: Container(
                    decoration: (widget.notePosition == NotePosition.middleC)
                        ? const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          )
                        : null,
                    child: widget.hideNoteName
                        ? SizedBox(
                            width: widget.keyWidth / 2,
                            height: widget.keyWidth / 2,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              widget.notePosition.name,
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontSize: widget.keyWidth / 3.5,
                                color: widget.notePosition.accidental ==
                                        Accidental.None
                                    ? (widget.notePosition ==
                                            NotePosition.middleC)
                                        ? Colors.white
                                        : Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _MaybeScrollbar extends StatelessWidget {
  final ScrollController? scrollController;
  final Widget child;

  const _MaybeScrollbar(
      {Key? key, required this.scrollController, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) => (scrollController == null)
      ? Container(child: child)
      : RawScrollbar(
          thumbColor: Colors.grey.shade600,
          radius: const Radius.circular(16),
          thickness: 16,
          thumbVisibility: true,
          controller: scrollController,
          child: Container(
              color: Colors.black,
              padding: const EdgeInsets.only(bottom: 24),
              child: child));
}
