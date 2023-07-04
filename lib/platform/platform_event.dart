import 'package:flutter/services.dart';

enum PlatformEventType {
  unknown,
  initialized,
  isPlayingChanged,
  positionChanged,
  bufferChanged,
  pipChanged,
  muteChanged,
  error,
}

PlatformEventType platformEventTypeFromString(String value) {
  return PlatformEventType.values.firstWhere(
    (type) => type.toString().split('.')[1] == value,
    orElse: () => PlatformEventType.unknown,
  );
}

class PlatformEvent {
  PlatformEvent({
    required this.eventType,
    this.duration,
    this.size,
    this.isPlaying = false,
    this.position,
    this.buffered,
    this.isPip = false,
    this.isMuted = false,
    this.errorDescription,
  });

  final PlatformEventType eventType;

  /// Duration of the video.
  ///
  /// Only used if [eventType] is [PlatformEventType.initialized].
  final Duration? duration;

  /// Size of the video.
  ///
  /// Only used if [eventType] is [PlatformEventType.initialized].
  final Size? size;

  final bool isPlaying;

  final Duration? position;

  /// Buffered parts of the video.
  ///
  /// Only used if [eventType] is [PlatformEventType.bufferingUpdate].
  final DurationRange? buffered;

  final bool isPip;

  final bool isMuted;

  final String? errorDescription;
}

/// Describes a discrete segment of time within a video using a [start] and
/// [end] [Duration].
class DurationRange {
  /// Trusts that the given [start] and [end] are actually in order. They should
  /// both be non-null.
  DurationRange(this.start, this.end);

  /// The beginning of the segment described relative to the beginning of the
  /// entire video. Should be shorter than or equal to [end].
  ///
  /// For example, if the entire video is 4 minutes long and the range is from
  /// 1:00-2:00, this should be a `Duration` of one minute.
  final Duration start;

  /// The end of the segment described as a duration relative to the beginning of
  /// the entire video. This is expected to be non-null and longer than or equal
  /// to [start].
  ///
  /// For example, if the entire video is 4 minutes long and the range is from
  /// 1:00-2:00, this should be a `Duration` of two minutes.
  final Duration end;

  /// Assumes that [duration] is the total length of the video that this
  /// DurationRange is a segment form. It returns the percentage that [start] is
  /// through the entire video.
  ///
  /// For example, assume that the entire video is 4 minutes long. If [start] has
  /// a duration of one minute, this will return `0.25` since the DurationRange
  /// starts 25% of the way through the video's total length.
  double startFraction(Duration duration) {
    return start.inMilliseconds / duration.inMilliseconds;
  }

  /// Assumes that [duration] is the total length of the video that this
  /// DurationRange is a segment form. It returns the percentage that [start] is
  /// through the entire video.
  ///
  /// For example, assume that the entire video is 4 minutes long. If [end] has a
  /// duration of two minutes, this will return `0.5` since the DurationRange
  /// ends 50% of the way through the video's total length.
  double endFraction(Duration duration) {
    return end.inMilliseconds / duration.inMilliseconds;
  }

  @override
  // ignore: no_runtimetype_tostring
  String toString() => '$runtimeType(start: $start, end: $end)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DurationRange &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}