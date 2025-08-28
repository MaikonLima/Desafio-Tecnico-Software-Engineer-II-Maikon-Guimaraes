enum UiStatus { idle, loading, success, error }

class UiState<T> {
  final UiStatus status;
  final T? data;
  final Object? error;

  const UiState._(this.status, {this.data, this.error});
  const UiState.idle() : this._(UiStatus.idle);
  const UiState.loading() : this._(UiStatus.loading);
  const UiState.success(T data) : this._(UiStatus.success, data: data);
  const UiState.error(Object e) : this._(UiStatus.error, error: e);

  bool get isLoading => status == UiStatus.loading;
  bool get isError => status == UiStatus.error;
}
