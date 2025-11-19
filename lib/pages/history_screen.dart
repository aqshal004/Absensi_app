import 'package:flutter/material.dart';
import 'package:ppkd_absensi/service/api_history.dart';
import 'package:ppkd_absensi/preferences/preferences_handler.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool loading = true;
  List history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final token = await PreferenceHandler.getToken();
    final result = await HistoryAbsenApi.getHistory(token: token ?? "");

    setState(() {
      loading = false;
      history = result?.data ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History Absensi")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];

                return ListTile(
                  title: Text(
                    item.attendanceDate.toString().split(" ")[0],
                  ),
                  subtitle: Text(
                      "In: ${item.checkInTime ?? '-'}  | Out: ${item.checkOutTime ?? '-'}"),
                );
              },
            ),
    );
  }
}
