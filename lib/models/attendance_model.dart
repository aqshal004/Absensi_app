import 'dart:convert';

AttendanceModel attendanceModelFromJson(String str) => AttendanceModel.fromJson(json.decode(str));

String attendanceModelToJson(AttendanceModel data) => json.encode(data.toJson());

class AttendanceModel {
  DateTime? attendanceDate;
  String? checkIn;
  double? checkInLat;
  double? checkInLng;
  String? checkInAddress;
  String? status;
  String? checkOut;
  double? checkOutLat;
  double? checkOutLng;
  String? checkOutLocation;
  String? checkOutAddress;

  AttendanceModel({
    this.attendanceDate,
    this.checkIn,
    this.checkInLat,
    this.checkInLng,
    this.checkInAddress,
    this.status,
    this.checkOut,
    this.checkOutLat,
    this.checkOutLng,
    this.checkOutLocation,
    this.checkOutAddress,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      attendanceDate: json["attendance_date"] == null
          ? null
          : DateTime.tryParse(json["attendance_date"]),

      checkIn: json["check_in"],
      checkInLat: json["check_in_lat"] == null
          ? null
          : double.tryParse(json["check_in_lat"].toString()),
      checkInLng: json["check_in_lng"] == null
          ? null
          : double.tryParse(json["check_in_lng"].toString()),
      checkInAddress: json["check_in_address"],
      status: json["status"],

      checkOut: json["check_out"],
      checkOutLat: json["check_out_lat"] == null
          ? null
          : double.tryParse(json["check_out_lat"].toString()),
      checkOutLng: json["check_out_lng"] == null
          ? null
          : double.tryParse(json["check_out_lng"].toString()),
      checkOutLocation: json["check_out_location"],
      checkOutAddress: json["check_out_address"],
    );
  }
   // 🔥 Tambahkan method toJson() di sini
  Map<String, dynamic> toJson() => {
        "attendance_date": attendanceDate == null
            ? null
            : "${attendanceDate!.year.toString().padLeft(4, '0')}-${attendanceDate!.month.toString().padLeft(2, '0')}-${attendanceDate!.day.toString().padLeft(2, '0')}",

        "check_in": checkIn,
        "check_in_lat": checkInLat,
        "check_in_lng": checkInLng,
        "check_in_address": checkInAddress,

        "status": status,

        "check_out": checkOut,
        "check_out_lat": checkOutLat,
        "check_out_lng": checkOutLng,
        "check_out_location": checkOutLocation,
        "check_out_address": checkOutAddress,
      };
}

