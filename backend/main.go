package main

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

// ==============================
// SECRET KEY JWT
// ==============================
var jwtSecret = []byte("tk_mutiara_secret_key")

// ==============================
// MODELS
// ==============================
type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type Pengumuman struct {
	ID        int    `json:"id"`
	Judul     string `json:"judul"`
	Isi       string `json:"isi"`
	Tanggal   string `json:"tanggal"`
	Kategori  string `json:"kategori"`
}

type Perkembangan struct {
	ID             int     `json:"id"`
	NamaAnak       string  `json:"nama_anak"`
	Tanggal        string  `json:"tanggal"`
	Kategori       string  `json:"kategori"`
	Deskripsi      string  `json:"deskripsi"`
	NilaiKognitif  float64 `json:"nilai_kognitif"`
	NilaiMotorik   float64 `json:"nilai_motorik"`
	NilaiSosial    float64 `json:"nilai_sosial"`
	NilaiBahasa    float64 `json:"nilai_bahasa"`
	NilaiSeni      float64 `json:"nilai_seni"`
	Catatan        string  `json:"catatan"`
}

type Pembayaran struct {
	ID                string `json:"id"`
	Bulan             string `json:"bulan"`
	Tahun             string `json:"tahun"`
	Nominal           int    `json:"nominal"`
	Status            string `json:"status"`
	TanggalBayar      string `json:"tanggal_bayar"`
	MetodePembayaran  string `json:"metode_pembayaran"`
	KodeTransaksi     string `json:"kode_transaksi"`
}

type BayarRequest struct {
	ID     string `json:"id"`
	Metode string `json:"metode"`
}

// ==============================
// JWT MIDDLEWARE
// ==============================
func authMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		tokenString := c.GetHeader("Authorization")
		if tokenString == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Token tidak ditemukan"})
			c.Abort()
			return
		}

		// Hapus prefix "Bearer " jika ada
		if len(tokenString) > 7 && tokenString[:7] == "Bearer " {
			tokenString = tokenString[7:]
		}

		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			return jwtSecret, nil
		})

		if err != nil || !token.Valid {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Token tidak valid"})
			c.Abort()
			return
		}

		c.Next()
	}
}

// ==============================
// MAIN
// ==============================
func main() {
	r := gin.Default()

	// CORS middleware (biar Flutter bisa akses)
	r.Use(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	// ==============================
	// PUBLIC ROUTES (tanpa JWT)
	// ==============================

	// Test endpoint
	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Backend TK Mutiara jalan 🚀",
		})
	})

	// Login → dapat token JWT
	r.POST("/login", func(c *gin.Context) {
		var req LoginRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Format tidak valid"})
			return
		}

		// Dummy user (nanti ganti dari database)
		if req.Email == "orangtua@tkmutiara.com" && req.Password == "mutiara123" {
			token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
				"email": req.Email,
				"role":  "orangtua",
				"exp":   time.Now().Add(24 * time.Hour).Unix(),
			})

			tokenString, err := token.SignedString(jwtSecret)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal buat token"})
				return
			}

			c.JSON(http.StatusOK, gin.H{
				"token": tokenString,
				"user": gin.H{
					"nama":      "Bunda Sari",
					"email":     req.Email,
					"nama_anak": "Bintang Mutiara",
					"kelas":     "Kelas A",
				},
			})
		} else {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Email atau password salah"})
		}
	})

	// ==============================
	// PROTECTED ROUTES (butuh JWT)
	// ==============================
	protected := r.Group("/")
	protected.Use(authMiddleware())
	{
		// GET semua pengumuman
		protected.GET("/pengumuman", func(c *gin.Context) {
			c.JSON(http.StatusOK, []Pengumuman{
				{ID: 1, Judul: "Libur Hari Raya Idul Fitri", Isi: "Sekolah libur mulai 28 Maret - 7 April 2025.", Tanggal: "25 Mar 2025", Kategori: "penting"},
				{ID: 2, Judul: "Kegiatan Pentas Seni", Isi: "Pentas seni akhir semester pada 20 April 2025.", Tanggal: "20 Mar 2025", Kategori: "kegiatan"},
				{ID: 3, Judul: "Jadwal Imunisasi Polio", Isi: "Imunisasi polio putaran 2 pada 15 April 2025.", Tanggal: "18 Mar 2025", Kategori: "penting"},
				{ID: 4, Judul: "Pembayaran SPP April", Isi: "SPP April sudah bisa dibayar mulai 1 April 2025.", Tanggal: "15 Mar 2025", Kategori: "info"},
			})
		})

		// GET data perkembangan anak
		protected.GET("/perkembangan", func(c *gin.Context) {
			c.JSON(http.StatusOK, []Perkembangan{
				{
					ID: 1, NamaAnak: "Bintang Mutiara", Tanggal: "Maret 2025",
					Kategori: "Perkembangan Bulanan",
					Deskripsi: "Bintang menunjukkan perkembangan yang sangat baik.",
					NilaiKognitif: 85, NilaiMotorik: 90, NilaiSosial: 80,
					NilaiBahasa: 88, NilaiSeni: 92,
					Catatan: "Bintang sangat aktif dan sudah bisa menulis namanya sendiri.",
				},
				{
					ID: 2, NamaAnak: "Bintang Mutiara", Tanggal: "Februari 2025",
					Kategori: "Perkembangan Bulanan",
					Deskripsi: "Perkembangan Bintang di bulan Februari stabil.",
					NilaiKognitif: 80, NilaiMotorik: 85, NilaiSosial: 78,
					NilaiBahasa: 82, NilaiSeni: 88,
					Catatan: "Bintang mulai tertarik pada seni menggambar.",
				},
			})
		})

		// GET riwayat pembayaran
		protected.GET("/pembayaran", func(c *gin.Context) {
			c.JSON(http.StatusOK, []Pembayaran{
				{ID: "1", Bulan: "Maret", Tahun: "2025", Nominal: 350000, Status: "lunas", TanggalBayar: "3 Mar 2025", MetodePembayaran: "Transfer Bank", KodeTransaksi: "TRX-20250303-001"},
				{ID: "2", Bulan: "Februari", Tahun: "2025", Nominal: 350000, Status: "lunas", TanggalBayar: "2 Feb 2025", MetodePembayaran: "QRIS", KodeTransaksi: "TRX-20250202-002"},
				{ID: "3", Bulan: "Januari", Tahun: "2025", Nominal: 350000, Status: "lunas", TanggalBayar: "5 Jan 2025", MetodePembayaran: "Transfer Bank", KodeTransaksi: "TRX-20250105-003"},
				{ID: "4", Bulan: "April", Tahun: "2025", Nominal: 350000, Status: "belum", TanggalBayar: "", MetodePembayaran: "", KodeTransaksi: ""},
			})
		})

		// POST bayar SPP
		protected.POST("/pembayaran/bayar", func(c *gin.Context) {
			var req BayarRequest
			if err := c.ShouldBindJSON(&req); err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": "Format tidak valid"})
				return
			}

			// Nanti ganti dengan update ke database
			kode := "TRX-" + time.Now().Format("20060102") + "-" + req.ID
			c.JSON(http.StatusOK, gin.H{
				"success":        true,
				"kode_transaksi": kode,
				"message":        "Pembayaran berhasil diproses",
			})
		})
	}

	r.Run(":8081")
}