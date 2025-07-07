# 📄 `setup.py` - Setup Script untuk Instalasi Database dan Dependencies

## 📦 Instalasi Requirements
Script ini secara otomatis akan menginstal semua dependensi Python yang diperlukan oleh aplikasi, termasuk:
- FastAPI untuk backend framework
- Uvicorn sebagai ASGI server
- SQLAlchemy dan psycopg2 untuk koneksi dan manajemen database PostgreSQL
- dotenv untuk mengambil variabel dari file `.env`
- Pydantic untuk validasi data
- Langchain dan langgraph untuk integrasi model bahasa
- Sentence Transformers dan FAISS untuk pencarian semantik
- Numpy untuk komputasi numerik
- Python Multipart untuk kebutuhan upload file

## 🗄️ Pembuatan Database Otomatis
Script ini akan membuat database PostgreSQL secara otomatis jika belum ada, dengan cara:
- Mengambil konfigurasi dari file `.env` (host, port, user, password, db name)
- Mengecek apakah database sudah ada
- Jika belum, database akan dibuat dengan nama yang ditentukan

## 🏗️ Setup Schema Database
Bagian ini memberikan instruksi kepada pengguna untuk menjalankan file SQL secara manual agar struktur tabel dan data awal tersedia. Schema ini biasanya tersedia di artifact atau file terpisah.

## ⚠️ Validasi File .env
Script juga akan memeriksa apakah file `.env` tersedia. Jika tidak ditemukan, akan diberikan template isi `.env` yang harus dibuat oleh pengguna, berisi:
- URL koneksi ke database
- API key untuk Gemini
- Konfigurasi database (host, port, user, password, nama database)

## 🚀 Langkah Setup
Secara keseluruhan, langkah-langkah setup meliputi:
1. Instalasi requirements
2. Pembuatan database jika belum ada
3. Instruksi manual untuk menjalankan SQL schema
4. Informasi langkah selanjutnya seperti:
   - Menjalankan SQL schema
   - Mengisi `.env` dengan kredensial yang benar
   - Menambahkan API key
   - Menjalankan aplikasi dengan `python main.py`
