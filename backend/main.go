package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {

	r := gin.Default()

	// endpoint test
	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Backend TK Mutiara jalan 🚀",
		})
	})

	// endpoint pengumuman
	r.GET("/pengumuman", func(c *gin.Context) {
		c.JSON(http.StatusOK, []gin.H{
			{
				"id":    1,
				"judul": "Libur Sekolah",
				"isi":   "Sekolah libur hari Senin",
			},
			{
				"id":    2,
				"judul": "Kegiatan Outing",
				"isi":   "Anak-anak akan outing minggu depan",
			},
		})
	})

	r.Run(":8081")
}