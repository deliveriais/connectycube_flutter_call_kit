import 'dart:convert';

import 'package:flutter/foundation.dart';

/// {@template call_event}
/// Information about the call events (e.g. CallAccepted / CallRejected)
/// {@endtemplate}
@immutable
class CallEvent {
  /// {@macro call_event}
  const CallEvent({
    required this.sessionId,
    required this.callType,
    required this.callerId,
    required this.callerName,
    required this.opponentsIds,
    this.avatarPath,
    this.userInfo,
    this.acceptActionText = "Accept",
    this.rejectActionText = "Reject"
  });

  final String sessionId;
  final int callType;
  final int callerId;
  final String callerName;
  final Set<int> opponentsIds;
  final String? avatarPath;
  final String? rejectActionText;
  final String? acceptActionText;

  /// Used for exchanging additional data between the Call notification and your app,
  /// you will get this data in event callbacks (e.g. onCallAcceptedWhenTerminated,
  /// onCallAccepted, onCallRejectedWhenTerminated, or onCallRejected)
  /// after setting it in method showCallNotification
  final Map<String, String>? userInfo;

  CallEvent copyWith({
    String? sessionId,
    int? callType,
    int? callerId,
    String? callerName,
    Set<int>? opponentsIds,
    Map<String, String>? userInfo,
    String? avatarPath,
    String? rejectActionText,
    String? acceptActionText
  }) {
    return CallEvent(
        sessionId: sessionId ?? this.sessionId,
        callType: callType ?? this.callType,
        callerId: callerId ?? this.callerId,
        callerName: callerName ?? this.callerName,
        opponentsIds: opponentsIds ?? this.opponentsIds,
        userInfo: userInfo ?? this.userInfo,
        avatarPath: avatarPath ?? this.avatarPath,
        rejectActionText: rejectActionText ?? this.rejectActionText,
        acceptActionText: acceptActionText ?? this.acceptActionText
    );
  }

  Map<String, Object?> toMap() {
    return {
      'session_id': sessionId,
      'call_type': callType,
      'caller_id': callerId,
      'caller_name': callerName,
      'call_opponents': opponentsIds.join(','),
      'user_info': jsonEncode(userInfo ?? <String, String>{}),
      'avatar_path': avatarPath,
      'reject_action_text': rejectActionText,
      'accept_action_text': acceptActionText
    };
  }

  factory CallEvent.fromMap(Map<String, dynamic> map) {
    print('[CallEvent.fromMap] map: $map');
    return CallEvent(
        sessionId: map['session_id'] as String,
        callType: map['call_type'] as int,
        callerId: map['caller_id'] as int,
        callerName: map['caller_name'] as String,
        opponentsIds:
        (map['call_opponents'] as String).split(',').map(int.parse).toSet(),
        userInfo: map['user_info'] != null
            ? Map<String, String>.from(jsonDecode(map['user_info']))
            : null,
        avatarPath: map['avatar_path'] as String?
    );

    // userInfo: map['user_info'] == null || map['user_info'].isEmpty
    //     ? null
    //     : Map<String, String>.from(jsonDecode(map['user_info'])),

  }

  String toJson() => json.encode(toMap());

  factory CallEvent.fromJson(String source) =>
      CallEvent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CallEvent('
        'sessionId: $sessionId, '
        'callType: $callType, '
        'callerId: $callerId, '
        'callerName: $callerName, '
        'opponentsIds: $opponentsIds, '
        'avatar_path: $avatarPath, '
        'userInfo: $userInfo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CallEvent &&
        other.sessionId == sessionId &&
        other.callType == callType &&
        other.callerId == callerId &&
        other.callerName == callerName &&
        other.avatarPath == avatarPath &&
        setEquals(other.opponentsIds, opponentsIds) &&
        mapEquals(other.userInfo, userInfo);
  }

  @override
  int get hashCode {
    return sessionId.hashCode ^
    callType.hashCode ^
    callerId.hashCode ^
    callerName.hashCode ^
    opponentsIds.hashCode ^
    avatarPath.hashCode ^
    userInfo.hashCode;
  }
}
