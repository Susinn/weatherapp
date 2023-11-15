import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<GetWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final WeatherFactory weatherFactory = WeatherFactory(
            "c7f051f4cb1dbef4f2183fa15a6ed190",
            language: Language.ENGLISH);
        Weather weather = await weatherFactory.currentWeatherByLocation(
            event.position.latitude, event.position.longitude);
        print(weather);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError());
      }
    });
  }
}
