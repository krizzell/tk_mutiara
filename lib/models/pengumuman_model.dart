// lib/models/pengumuman_model.dart

class PengumumanModel {
  final String id;
  final String judul;
  final String isi;
  final String tanggal;
  final String kategori;
  final bool isRead;

  const PengumumanModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tanggal,
    required this.kategori,
    this.isRead = false,          // default false
  });

  // Factory untuk parsing dari API
  factory PengumumanModel.fromJson(Map<String, dynamic> json) {
    return PengumumanModel(
      id: json['id']?.toString() ?? '',
      judul: json['judul'] ?? 'Tidak ada judul',
      isi: json['isi'] ?? '',
      tanggal: json['tanggal'] ?? json['created_at'] ?? 'Tanggal tidak diketahui',
      kategori: json['kategori']?.toString().toLowerCase() ?? 'informasi',
      isRead: json['is_read'] ?? false,   // kalau backend kirim field ini
    );
  }

  // Method copyWith (WAJIB untuk mengubah isRead)
  PengumumanModel copyWith({
    String? id,
    String? judul,
    String? isi,
    String? tanggal,
    String? kategori,
    bool? isRead,
  }) {
    return PengumumanModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      tanggal: tanggal ?? this.tanggal,
      kategori: kategori ?? this.kategori,
      isRead: isRead ?? this.isRead,
    );
  }

  // Dummy data (untuk fallback saat error koneksi)
  static List<PengumumanModel> dummyData() {
    return [
      PengumumanModel(
        id: '1',
        judul: 'Pengumuman Libur Semester',
        isi: 'Libur semester akan dimulai tanggal 10 April 2026.',
        tanggal: '30 Maret 2026',
        kategori: 'penting',
      ),
      PengumumanModel(
        id: '2',
        judul: 'Jadwal Kegiatan Olahraga',
        isi: 'Lomba olahraga antar kelas akan dilaksanakan minggu depan.',
        tanggal: '29 Maret 2026',
        kategori: 'kegiatan',
      ),
    ];
  }
}