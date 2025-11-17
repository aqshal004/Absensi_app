import 'package:flutter/material.dart';
import 'package:ppkd_absensi/models/register_model.dart';
import 'package:ppkd_absensi/preferences/preferences_handler.dart';
import 'package:ppkd_absensi/service/api.dart';
import 'package:ppkd_absensi/views/login_screen.dart';
import 'package:ppkd_absensi/widgets/custom_widget.dart';

class RegisterScreenWidget extends StatefulWidget {
  const RegisterScreenWidget({Key? key}) : super(key: key);

  @override
  State<RegisterScreenWidget> createState() => _RegisterScreenWidgetState();
}

class _RegisterScreenWidgetState extends State<RegisterScreenWidget>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _selectedTrainingId;
  String? _selectedGender;
  String? _selectedBatch;

  List<Training> trainings = [];
  List<Batch> batches = [];

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _loadTrainingData();
    _loadBatchData();
  }

  void _setupAnimation() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _loadTrainingData() async {
    try {
      final result = await TrainingAPI.getTrainings();
      setState(() => trainings = result);
    } catch (e) {
      _showError("Gagal memuat data training: $e");
    }
  }

  Future<void> _loadBatchData() async {
    try {
      final result = await TrainingAPI.getTrainingBatches();
      setState(() => batches = result);
    } catch (e) {
      _showError("Gagal memuat data batch: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedGender == null ||
        _selectedBatch == null ||
        _selectedTrainingId == null) {
      _showError("Semua field harus dipilih");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await AuthAPI.registerUser(
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
        password: _passwordController.text.trim(),
        jenisKelamin: _selectedGender!,
        batchId: int.parse(_selectedBatch!),
        trainingId: int.parse(_selectedTrainingId!),
      );

      // Simpan token ke SharedPreferences
      await PreferenceHandler.saveToken(response.data?.token ?? "");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Registrasi berhasil!"),
          backgroundColor: Colors.green.shade600,
        ),
      );

      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreenWidget()),
);
    } catch (e) {
      _showError(e.toString());
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Buat Akun Baru",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800)),
                        const SizedBox(height: 6),
                        Text("Lengkapi data diri untuk mendaftar",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade600)),
                        const SizedBox(height: 30),

                        // === FORM ===
                        _buildFormCard(),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sudah punya akun?",
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 14)),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200, blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              hintText: "Nama Lengkap",
              prefixIcon: Icons.person_outline,
              validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _emailController,
              hintText: "Email",
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v!.isEmpty) return "Email wajib diisi";
                if (!v.contains("@")) return "Email tidak valid";
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildGenderDropdown(),
            const SizedBox(height: 16),

            _buildBatchDropdown(),
            const SizedBox(height: 16),

            _buildTrainingDropdown(),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _passwordController,
              hintText: "Password",
              prefixIcon: Icons.lock_outline,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) =>
                  v!.length < 6 ? "Password minimal 6 karakter" : null,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _confirmPasswordController,
              hintText: "Konfirmasi Password",
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
              validator: (v) => v != _passwordController.text
                  ? "Password tidak cocok"
                  : null,
            ),

            const SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        strokeWidth: 2.4, color: Colors.white)
                    : const Text(
                        "Daftar",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return _styledDropdown<String>(
      value: _selectedGender,
      hint: "Pilih Jenis Kelamin",
      icon: Icons.person_outline,
      items: const [
        DropdownMenuItem(value: "L", child: Text("Laki-laki")),
        DropdownMenuItem(value: "P", child: Text("Perempuan")),
      ],
      onChanged: (v) => setState(() => _selectedGender = v),
    );
  }

  Widget _buildBatchDropdown() {
    return _styledDropdown<String>(
      value: _selectedBatch,
      hint: "Pilih Batch",
      icon: Icons.group_outlined,
      items: batches
          .map((b) => DropdownMenuItem(
                value: b.id.toString(),
                child: Text(b.label),
              ))
          .toList(),
      onChanged: (v) => setState(() => _selectedBatch = v),
    );
  }

  Widget _buildTrainingDropdown() {
    return _styledDropdown<String>(
      value: _selectedTrainingId,
      hint: "Pilih Training",
      icon: Icons.school_outlined,
      items: trainings
          .map((t) =>
              DropdownMenuItem(value: t.id?.toString() ?? "", child: Text(t.title ?? "-")))
          .toList(),
      onChanged: (v) => setState(() => _selectedTrainingId = v),
    );
  }

  Widget _styledDropdown<T>({
    required T? value,
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey.shade500),
          border: InputBorder.none,
          hintText: hint,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        items: items,
        onChanged: onChanged,
        validator: (v) => v == null ? "Field ini wajib dipilih" : null,
      ),
    );
  }
}
