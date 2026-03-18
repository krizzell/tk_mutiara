import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/pengumuman_model.dart';

class PengumumanScreen extends StatefulWidget {
  final List<PengumumanModel> pengumuman;
  final String? selectedId;

  const PengumumanScreen({
    super.key,
    required this.pengumuman,
    this.selectedId,
  });

  @override
  State<PengumumanScreen> createState() => _PengumumanScreenState();
}

class _PengumumanScreenState extends State<PengumumanScreen> {
  String _filter = 'semua';
  PengumumanModel? _selected;

  @override
  void initState() {
    super.initState();
    if (widget.selectedId != null) {
      _selected = widget.pengumuman.firstWhere(
        (p) => p.id == widget.selectedId,
        orElse: () => widget.pengumuman.first,
      );
    }
  }

  List<PengumumanModel> get _filtered {
    if (_filter == 'semua') return widget.pengumuman;
    return widget.pengumuman.where((p) => p.kategori == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: _selected != null
            ? _buildDetail(context)
            : _buildList(context),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        _buildFilterChips(),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            itemCount: _filtered.length,
            itemBuilder: (_, i) => _buildCard(_filtered[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final unread = widget.pengumuman.where((p) => !p.isRead).length;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 20, 16),
      color: AppTheme.white,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppTheme.textDark, size: 20),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pengumuman',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '$unread pengumuman belum dibaca',
                  style: TextStyle(
                    color: unread > 0 ? AppTheme.primary : AppTheme.textMedium,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (unread > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$unread Baru',
                style: const TextStyle(
                    color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      {'key': 'semua', 'label': 'Semua'},
      {'key': 'penting', 'label': '🔴 Penting'},
      {'key': 'kegiatan', 'label': '🎉 Kegiatan'},
      {'key': 'info', 'label': '💚 Info'},
    ];

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppTheme.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filters.map((f) {
          final isSelected = _filter == f['key'];
          return GestureDetector(
            onTap: () => setState(() => _filter = f['key']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10, bottom: 8, top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.primary.withOpacity(0.2),
                ),
              ),
              child: Center(
                child: Text(
                  f['label']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textDark,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCard(PengumumanModel p) {
    final config = _getKategoriConfig(p.kategori);

    return GestureDetector(
      onTap: () => setState(() => _selected = p),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.cardShadowList,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 5,
                height: 110,
                color: config['color'] as Color,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: (config['color'] as Color).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              config['label'] as String,
                              style: TextStyle(
                                color: config['color'] as Color,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (!p.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: config['color'] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p.judul,
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 14,
                          fontWeight: p.isRead ? FontWeight.w600 : FontWeight.w800,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p.isi,
                        style: const TextStyle(
                          color: AppTheme.textMedium,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 12, color: AppTheme.textLight),
                          const SizedBox(width: 4),
                          Text(
                            p.tanggal,
                            style: const TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Baca selengkapnya →',
                            style: TextStyle(
                              color: config['color'] as Color,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(BuildContext context) {
    final p = _selected!;
    final config = _getKategoriConfig(p.kategori);

    return Column(
      children: [
        // Header detail
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 20, 16),
          color: AppTheme.white,
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _selected = null),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppTheme.textDark, size: 20),
              ),
              const Text(
                'Detail Pengumuman',
                style: TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kategori badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (config['color'] as Color).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    config['label'] as String,
                    style: TextStyle(
                      color: config['color'] as Color,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  p.judul,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 14, color: config['color'] as Color),
                    const SizedBox(width: 6),
                    Text(
                      p.tanggal,
                      style: TextStyle(
                        color: config['color'] as Color,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'TK Mutiara',
                      style: const TextStyle(
                        color: AppTheme.textMedium,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        config['color'] as Color,
                        (config['color'] as Color).withOpacity(0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  p.isi,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDE0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppTheme.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.school_rounded, color: AppTheme.primary, size: 20),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Pengumuman resmi dari TK Mutiara. Hubungi pihak sekolah jika ada pertanyaan.',
                          style: TextStyle(
                            color: AppTheme.textDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getKategoriConfig(String kategori) {
    switch (kategori) {
      case 'penting':
        return {'color': const Color(0xFFEF4444), 'label': '🔴 Penting'};
      case 'kegiatan':
        return {'color': const Color(0xFF6366F1), 'label': '🎉 Kegiatan'};
      default:
        return {'color': const Color(0xFF22C55E), 'label': '💚 Info'};
    }
  }
}