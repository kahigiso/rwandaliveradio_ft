import 'package:rwandaliveradio_fl/models/radio_model.dart';

sealed class ScreenState {}

class LoadingState extends ScreenState {}
class LoadedState extends ScreenState {
  final List<RadioModel> data;
  LoadedState(this.data);
}
class ErrorState extends ScreenState {
  final String message;
  ErrorState(this.message);
}