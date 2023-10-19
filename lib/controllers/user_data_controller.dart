import 'package:didyoucodetoday/app/locator.dart';
import 'package:didyoucodetoday/controllers/auth_controller.dart';
import 'package:didyoucodetoday/models/code_log.dart';
import 'package:didyoucodetoday/models/profile.dart';
import 'package:didyoucodetoday/models/user_data.dart';
import 'package:didyoucodetoday/utils/date.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:secretary/secretary.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef UserDataMap = Map<String, UserData>;

class UserDataController extends Cubit<UserDataMap> {
  UserDataController() : super({}) {
    init();
  }

  final supabase = Supabase.instance.client;

  final _profileSec = Secretary<String, Result<Profile, Object>>(
    maxConcurrentTasks: 3,
    validator: Validators.resultOk,
  );
  final _logsSec = Secretary<String, Result<List<CodeLog>, Object>>(
    maxConcurrentTasks: 3,
    validator: Validators.resultOk,
  );

  void init() {
    auth().stream.startWith(auth().state).listen(_handleAuthState);
    _profileSec.successStream
        .map((e) => (e.key, e.result.object!))
        .listen(_onProfile);
    _logsSec.resultStream.map((e) => e.object!).listen(_onCodeLogs);
    _profileSec.failureStream
        .listen((e) => print('Profile request failed: $e'));
    _logsSec.failureStream.listen((e) => print('Code logs request failed: $e'));
  }

  void _handleAuthState(AppAuthState authState) {
    if (authState.complete && state[authState.user!.id] == null) {
      _onProfile((authState.user!.id, authState.profile!));
    }
  }

  Future<Result<Profile, Object>> _getProfile(String userId) async {
    final result = await supabase.from('profiles').select().eq('id', userId);
    if (result.isEmpty) return Result.error('not_found');
    try {
      final profile = Profile.fromJson(result.first);
      return Result.ok(profile);
    } catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<CodeLog>, Object>> _getCodeLogs(String userId) async {
    final result = await supabase
        .from('codelogs')
        .select()
        .eq('user_id', userId)
        .order('date');
    if (result.isEmpty) return Result.error('not_found');
    try {
      final logs = result.map<CodeLog>((e) => CodeLog.fromJson(e)).toList();
      return Result.ok(logs);
    } catch (e) {
      return Result.error(e);
    }
  }

  void _onProfile((String userId, Profile profile) data) {
    final (userId, profile) = data;
    final userData = state[userId];
    emit({
      ...state,
      userId: userData?.copyWith(profile: profile) ??
          UserData(id: userId, profile: profile),
    });
    getCodeLogs(userId);
  }

  void _onCodeLogs(List<CodeLog> logs) {
    final userId = logs.first.userId;
    final userData = state[userId];
    if (userData == null) return;
    emit({
      ...state,
      userId: userData.copyWith(codeLogs: logs),
    });
  }

  void getUserData(String userId) {
    _profileSec.add(userId, () async => await _getProfile(userId));
  }

  void getCodeLogs(String userId) {
    _logsSec.add(userId, () async => await _getCodeLogs(userId));
  }

  void logToday() async {
    final userId = auth().state.user!.id;
    await supabase.from('codelogs').insert({
      'user_id': userId,
      'date': DateTime.now().roundDownToDay().toIso8601String(),
    });
    getCodeLogs(userId);
  }
}
