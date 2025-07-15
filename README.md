## 🚀 Langkah Setup
Berikut langkah - langkahnya:
1. Open Projek kemudian buka terminal di vs code
2. Buat virtual environment (disini saya menggunakan python v3.12)
   ```shell
   python -m venv venv
   ```
3. Masuk ke environment
   - untuk windows
      ```shell
      venv\Scripts\activate
      ```
   - untuk macos
      ```shell
      source venv/bin/activate
      ```
4. Instalasi requirements
   ```shell
   pip install -r requirements.txt
   ```
5. Rename .env.example menjadi .env lalu sesuaikan konfigurasinya
6. Export database db_teman_belajar_backup.sql atau bisa juga menggunakan db yang sudah ada
   ```shell
   psql -U username -d db_teman_belajar < db_teman_belajar_backup.sql
   ```
7. Run projek
   ```shell
    uvicorn api.main:app --reload
   ```
8. Kemudian bisa akses endpoint <code>/health</code> untuk cek apakah projek nya sudah running
