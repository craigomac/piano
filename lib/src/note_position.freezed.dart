// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'note_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
abstract class _$$_NotePositionCopyWith<$Res>
    implements $NotePositionCopyWith<$Res> {
  factory _$$_NotePositionCopyWith(
          _$_NotePosition value, $Res Function(_$_NotePosition) then) =
      __$$_NotePositionCopyWithImpl<$Res>;
  @override
  $Res call({Note note, int octave, Accidental accidental});
}

/// @nodoc
class __$$_NotePositionCopyWithImpl<$Res>
    extends _$NotePositionCopyWithImpl<$Res>
    implements _$$_NotePositionCopyWith<$Res> {
  __$$_NotePositionCopyWithImpl(
      _$_NotePosition _value, $Res Function(_$_NotePosition) _then)
      : super(_value, (v) => _then(v as _$_NotePosition));

  @override
  _$_NotePosition get _value => super._value as _$_NotePosition;

  @override
  $Res call({
    Object? note = freezed,
    Object? octave = freezed,
    Object? accidental = freezed,
  }) {
    return _then(_$_NotePosition(
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
  @override
  @JsonKey()
  final int octave;
  @override
  @JsonKey()
  final Accidental accidental;

  @override
  String toString() {
    return 'NotePosition(note: $note, octave: $octave, accidental: $accidental)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotePosition &&
            const DeepCollectionEquality().equals(other.note, note) &&
            const DeepCollectionEquality().equals(other.octave, octave) &&
            const DeepCollectionEquality()
                .equals(other.accidental, accidental));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(note),
      const DeepCollectionEquality().hash(octave),
      const DeepCollectionEquality().hash(accidental));

  @JsonKey(ignore: true)
  @override
  _$$_NotePositionCopyWith<_$_NotePosition> get copyWith =>
      __$$_NotePositionCopyWithImpl<_$_NotePosition>(this, _$identity);
}

abstract class _NotePosition implements NotePosition {
  factory _NotePosition(
      {required final Note note,
      final int octave,
      final Accidental accidental}) = _$_NotePosition;

  @override
  Note get note => throw _privateConstructorUsedError;
  @override
  int get octave => throw _privateConstructorUsedError;
  @override
  Accidental get accidental => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_NotePositionCopyWith<_$_NotePosition> get copyWith =>
      throw _privateConstructorUsedError;
}
