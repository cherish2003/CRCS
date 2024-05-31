import 'dart:math';

class GeofenceService {
  final double _radiusOfEarth = 6371000; // Earth's radius in meters

  // Destination coordinates
  final double destinationLatitude=16.46367721542266;
  final double destinationLongitude= 80.50753185333085;
// 16.463679207203366, 80.50738103369875
// 16.46367721542266, 80.50753185333085
 
  // Validate latitude and longitude values (optional)
  bool _isValidLatLon(double value) {
    return value >= -90 && value <= 90;
  }

  // Convert degrees to radians
  double _degreesToRadians(double degrees) {
    if (!_isValidLatLon(degrees)) {
      throw ArgumentError("Invalid latitude or longitude value: $degrees");
    }
    return degrees * (pi / 180);
  }

  // Calculate the distance between two points on the Earth's surface using the Haversine formula
  double _calculateDistance(
      double startLat, double startLon, double endLat, double endLon) {
    double dLat = _degreesToRadians(endLat - startLat);
    double dLon = _degreesToRadians(endLon - startLon);
    double startLatRad = _degreesToRadians(startLat);
    double endLatRad = _degreesToRadians(endLat);

    double a = pow(sin(dLat / 2), 2) +
        cos(startLatRad) * cos(endLatRad) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return _radiusOfEarth * c;
  }

  // Check if the current position falls within the geofence area
  bool isWithinGeofence(double currentLat, double currentLon) {
    // Validate latitude and longitude values (optional)
    if (!_isValidLatLon(currentLat) || !_isValidLatLon(currentLon)) {
      throw ArgumentError("Invalid latitude or longitude value");
    }
    double distance = _calculateDistance(
        currentLat, currentLon, destinationLatitude, destinationLongitude);
        print(distance);
    return isWithinRadius(distance);
  }

  // Check if distance is within the specified radius
  bool isWithinRadius(double distance) {
    return distance <= 100;
  }
}
