// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'note_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$NotePositionTearOff {
  const _$NotePositionTearOff();

  _NotePosition call(
      {required Note note,
      int octave = 4,
      Accidental accidental = Accidental.None}) {
    return _NotePosition(
      note: note,
      octave: octave,
      accidental: accidental,
    );
  }
}

/// @nodoc
const $NotePosition = _$NotePositionTearOff();

/// @nodoc
mixin _$NotePosition {
  Note get note => throw _privateConstructorUsedError;
  int get octave => throw _privateConstructorUsedError;
  Accidental get accidental => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotePositionCopyWith<NotePosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotePositionCopyWith<$Res> {
  factory $NotePositionCopyWith(
          NotePosition value, $Res Function(NotePosition) then) =
      _$NotePositionCopyWithImpl<$Res>;
  $Res call({Note note, int octave, Accidental accidental});
}

/// @nodoc
class _$NotePositionCopyWithImpl<$Res> implements $NotePositionCopyWith<$Res> {
  _$NotePositionCopyWithImpl(this._value, this._then);

  final NotePosition _value;
  // ignore: unused_field
  final $Res Function(NotePosition) _then;

  @override
  $Res call({
    Object? note = freezed,
    Object? octave = freezed,
    Object? accidental = freezed,
  }) {
    return _then(_value.copyWith(
      note: note == freezed
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as Note,
      octave: octave == freezed
          ? _value.octave
          : octave // ignore: cast_nullable_to_non_nullable
              as int,
      accidental: accidental == freezed
          ? _value.accidental
          : accidental // ignore: cast_nullable_to_non_nullable
              as Accidental,
    ));
  }
}

/// @nodoc
abstract class _$NotePositionCopyWith<$Res>
    implements $NotePositionCopyWith<$Res> {
  factory _$NotePositionCopyWith(
          _NotePosition value, $Res Function(_NotePosition) then) =
      __$NotePositionCopyWithImpl<$Res>;
  @override
  $Res call({Note note, int octave, Accidental accidental});
}

/// @nodoc
class __$NotePositionCopyWithImpl<$Res> extends _$NotePositionCopyWithImpl<$Res>
    implements _$NotePositionCopyWith<$Res> {
  __$NotePositionCopyWithImpl(
      _NotePosition _value, $Res Function(_NotePosition) _then)
      : super(_value, (v) => _then(v as _NotePosition));

  @override
  _NotePosition get _value => super._value as _NotePosition;

  @override
  $Res call({
    Object? note = freezed,
    Object? octave = freezed,
    Object? accidental = freezed,
  }) {
    return _then(_NotePosition(
      note: note == freezed
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as Note,
      octave: octave == freezed
          ? _value.octave
          : octave // ignore: cast_nullable_to_non_nullable
              as int,
      accidental: accidental == freezed
          ? _value.accidental
          : accidental // ignore: cast_nullable_to_non_nullable
              as Accidental,
    ));
  }
}

/// @nodoc

class _$_NotePosition implements _NotePosition {
  _$_NotePosition(
      {required this.note, this.octave = 4, this.accidental = Accidental.None});

  @override
  final Note note;
  @JsonKey(defaultValue: 4)
  @override
  final int octave;
  @JsonKey(defaultValue: Accidental.None)
  @override
  final Accidental accidental;

  @override
  String toString() {
    return 'NotePosition(note: $note, octave: $octave, accidental: $accidental)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _NotePosition &&
            (identical(other.note, note) ||
                const DeepCollectionEquality().equals(other.note, note)) &&
            (identical(other.octave, octave) ||
                const DeepCollectionEquality().equals(other.octave, octave)) &&
            (identical(other.accidental, accidental) ||
                const DeepCollectionEquality()
                    .equals(other.accidental, accidental)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(note) ^
      const DeepCollectionEquality().hash(octave) ^
      const DeepCollectionEquality().hash(accidental);

  @JsonKey(ignore: true)
  @override
  _$NotePositionCopyWith<_NotePosition> get copyWith =>
      __$NotePositionCopyWithImpl<_NotePosition>(this, _$identity);
}

abstract class _NotePosition implements NotePosition {
  factory _NotePosition(
      {required Note note,
      int octave,
      Accidental accidental}) = _$_NotePosition;

  @override
  Note get note => throw _privateConstructorUsedError;
  @override
  int get octave => throw _privateConstructorUsedError;
  @override
  Accidental get accidental => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$NotePositionCopyWith<_NotePosition> get copyWith =>
      throw _privateConstructorUsedError;
}
