import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ppkd_absensi/preferences/preferences_handler.dart';
import 'package:ppkd_absensi/service/api_attendance.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  GoogleMapController? mapController;
  LatLng? currentPosition;
  bool isLoading = true;
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin lokasi ditolak")),
      );
      return;
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentPosition = LatLng(pos.latitude, pos.longitude);
      isLoading = false;
    });
  }

  Future<void> _handleCheckOut() async {
    if (currentPosition == null) return;

    setState(() => isSending = true);

    try {
      final token = await PreferenceHandler.getToken();

      await AttendanceApi.checkOut(
        token: token ?? "",
        lat: currentPosition!.latitude,
        lng: currentPosition!.longitude,
        address: "Lokasi Map",
      );

      if (!mounted) return;

      setState(() => isSending = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✓ Check out berhasil")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() => isSending = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal check out: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Check Out")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentPosition!,
                    zoom: 16,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId("pos"),
                      position: currentPosition!,
                    ),
                  },
                ),

                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: isSending ? null : _handleCheckOut,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: isSending
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Check Out Sekarang",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                )
              ],
            ),
    );
  }
}
