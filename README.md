## 🚀 Langkah Setup
Berikut langkah - langkahnya:
1. Buat virtual environment (disini saya menggunakan python v3.12)
   ```shell
   python -m venv venv
   ```
2. Masuk ke environment
   - untuk windows
      ```shell
      venv\Scripts\activate
      ```
   - untuk macos
      ```shell
      source venv/bin/activate
      ```
3. Instalasi requirements
   ```shell
   pip install -r requirements.txt
   ```
4. Rename .env.example menjadi .env lalu sesuaikan konfigurasinya
5. Export database db_teman_belajar_backup.sql atau bisa juga menggunakan db yang sudah ada
   ```shell
   psql -U username -d db_teman_belajar < db_teman_belajar_backup.sql
   ```
6. Run projek
   ```shell
    uvicorn api.main:app --reload
   ```
7. Kemudian bisa akses endpoint <code>/health</code> untuk cek apakah projek nya sudah running
