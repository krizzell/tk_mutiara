class PengumumanModel {
  final String id;
  final String judul;
  final String isi;
  final String tanggal;
  final String kategori; // 'penting', 'info', 'kegiatan'
  final bool isRead;

  PengumumanModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tanggal,
    required this.kategori,
    this.isRead = false,
  });

  factory PengumumanModel.fromJson(Map<String, dynamic> json) {
    return PengumumanModel(
      id: json['id'] ?? '',
      judul: json['judul'] ?? '',
      isi: json['isi'] ?? '',
      tanggal: json['tanggal'] ?? '',
      kategori: json['kategori'] ?? 'info',
      isRead: json['is_read'] ?? false,
    );
  }

  // === DUMMY DATA ===
  static List<PengumumanModel> dummyData() {
    return [
      PengumumanModel(
        id: '1',
        judul: 'Libur Hari Raya Idul Fitri 1446 H',
        isi:
            'Diberitahukan kepada seluruh orang tua/wali murid bahwa TK Mutiara akan libur dalam rangka Hari Raya Idul Fitri 1446 H mulai tanggal 28 Maret - 7 April 2025. Kegiatan belajar mengajar akan kembali normal pada tanggal 8 April 2025. Selamat Hari Raya Idul Fitri 1446 H, Mohon Maaf Lahir dan Batin.',
        tanggal: '25 Mar 2025',
        kategori: 'penting',
        isRead: false,
      ),
      PengumumanModel(
        id: '2',
        judul: 'Kegiatan Pentas Seni Akhir Semester',
        isi:
            'Dalam rangka memperingati akhir semester genap, TK Mutiara akan mengadakan Pentas Seni yang akan dilaksanakan pada tanggal 20 April 2025 pukul 08.00 WIB di Aula TK Mutiara. Mohon dukungan dan kehadiran seluruh orang tua/wali murid. Anak-anak sudah berlatih keras untuk acara ini!',
        tanggal: '20 Mar 2025',
        kategori: 'kegiatan',
        isRead: false,
      ),
      PengumumanModel(
        id: '3',
        judul: 'Jadwal Imunisasi Polio Putaran 2',
        isi:
            'Diberitahukan bahwa akan dilaksanakan imunisasi polio putaran 2 pada tanggal 15 April 2025. Orang tua dimohon untuk memastikan anak hadir pada hari tersebut. Imunisasi ini bersifat GRATIS dan wajib diikuti oleh seluruh siswa.',
        tanggal: '18 Mar 2025',
        kategori: 'penting',
        isRead: true,
      ),
      PengumumanModel(
        id: '4',
        judul: 'Pembayaran SPP Bulan April 2025',
        isi:
            'Mengingatkan kepada seluruh orang tua/wali murid bahwa pembayaran SPP bulan April 2025 sudah dapat dilakukan mulai tanggal 1 April 2025. Harap segera melakukan pembayaran sebelum tanggal 10 April 2025 untuk menghindari denda. Pembayaran dapat dilakukan melalui aplikasi ini atau langsung ke bendahara sekolah.',
        tanggal: '15 Mar 2025',
        kategori: 'info',
        isRead: true,
      ),
      PengumumanModel(
        id: '5',
        judul: 'Rapat Orang Tua & Guru (POMG)',
        isi:
            'Akan diadakan Rapat Orang Tua dan Guru (POMG) pada hari Sabtu, 12 April 2025 pukul 09.00 WIB. Agenda rapat meliputi evaluasi semester dan rencana kegiatan semester berikutnya. Kehadiran orang tua/wali sangat diharapkan.',
        tanggal: '10 Mar 2025',
        kategori: 'kegiatan',
        isRead: true,
      ),
    ];
  }
}