import 'package:geolocator/geolocator.dart';
import 'package:uber_rider/Assistant/requestAssistant.dart';
import 'package:uber_rider/configMap.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAdress(Position position) async {
    String placeAdress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(url);
    if (response != null) {
      placeAdress = response["results"][0]["formatted_address"];
    }
    return placeAdress;
  }
}
