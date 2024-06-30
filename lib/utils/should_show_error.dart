import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'should_show_error.g.dart';

@riverpod
class ShouldShowError extends _$ShouldShowError {
  @override
  bool build() {
    return false;
  }

  void show() {
    state = true;
  }
}
