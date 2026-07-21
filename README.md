# Tinggal Klik - Aplikasi Pemesanan Lapangan Olahraga

Tinggal Klik adalah aplikasi pemesanan lapangan olahraga berbasis mobile dan web yang dibangun menggunakan Flutter dan backend Laravel. Proyek ini dibuat untuk memudahkan pengguna dalam mencari serta memesan lapangan secara online, sekaligus membantu pemilik lapangan (owner) dalam mengelola jadwal penyewaan dan pencatatan keuangan.

---

## Fitur Utama

### 1. Pelanggan (Customer)
* **Katalog & Pencarian:** Filter lapangan berdasarkan kategori olahraga (Futsal, Badminton, Basket, Tenis, dll).
* **Detail Lapangan:** Informasi fasilitas, harga per jam, deskripsi, foto, dan lokasi.
* **Pemesanan:** Pemilihan tanggal dan slot jam bermain secara fleksibel.
* **Pembayaran Online:** Integrasi pembayaran otomatis menggunakan Midtrans Payment Gateway.
* **Riwayat Pemesanan:** Memantau status transaksi (pending/lunas) dan histori booking.
* **Ulasan:** Memberikan ulasan dan rating pada lapangan yang telah disewa.

### 2. Pemilik Lapangan (Owner)
* **Manajemen Lapangan (CRUD):** Tambah, edit, hapus, dan unggah foto lapangan.
* **Dashboard Finansial:** Ringkasan statistik pendapatan, grafik transaksi, dan ringkasan penyewaan.
* **Monitoring Transaksi:** Memantau data pemesanan yang masuk dari pelanggan.
* **Penarikan Dana (Withdrawal):** Pengajuan pencairan saldo pendapatan ke rekening bank lokal.

### 3. Administrator (Admin)
* **Verifikasi Penarikan Dana:** Meninjau dan menyetujui atau menolak pengajuan penarikan dana dari owner.
* **Manajemen Sistem:** Pengelolaan akun pengguna dan hak akses.

---

## Tech Stack

* **Frontend:** Flutter, GetX (State Management & Routing), Dio (HTTP Client).
* **Backend:** Laravel 11 (PHP 8.3), Laravel Sanctum (Authentication).
* **Database:** MySQL.
* **Payment Gateway:** Midtrans Snap API.

---

## Skema Database

Struktur tabel utama pada database `db_tinggal_klik`:

* `users`: Menyimpan data akun pengguna (pelanggan, owner, admin).
* `lapangan`: Menyimpan data lokasi, harga, fasilitas, dan foto lapangan.
* `pemesanan`: Menyimpan data jadwal booking dan reservasi.
* `transactions`: Menyimpan rincian pembayaran dan status transaksi Midtrans.
* `ulasan`: Menyimpan data rating dan komentar dari pelanggan.
* `withdrawals`: Menyimpan data riwayat pencairan saldo oleh owner.

---

## Panduan Instalasi

### 1. Setup Backend (Laravel)


# Clone repositori backend
git clone [https://github.com/makbulldrrt/tinggal_klik_backend.git](https://github.com/makbulldrrt/tinggal_klik_backend.git)
cd tinggal_klik_backend

# Install dependensi PHP
composer install

# Salin file environment dan sesuaikan konfigurasi database/Midtrans
cp .env.example .env

# Generate application key
php artisan key:generate

# Jalankan migrasi database beserta seeder
php artisan migrate --seed

# Buat shortcut penyimpanan file media/foto
php artisan storage:link

# Jalankan server Laravel
php artisan serve



2. Setup Frontend (Flutter)
Bash
# Clone repositori frontend
git clone [https://github.com/username-anda/tinggal_klik_mobile.git](https://github.com/username-anda/tinggal_klik_mobile.git)
cd tinggal_klik_mobile

# Install dependensi Flutter
flutter pub get

# Jalankan aplikasi
flutter run
Struktur Folder Frontend
Plaintext
lib/
├── app/
│   └── data/
│       └── services/          # Konfigurasi ApiService & Dio
├── features/
│   ├── auth/                  # Halaman & Controller Login/Register
│   ├── booking/               # Halaman & Controller Booking & Riwayat
│   ├── dashboard/             # Halaman & Controller Dashboard Owner
│   ├── lapangan/              # Halaman & Controller Kelola Lapangan
│   └── shared/                # Widget & Komponen Reusable
└── main.dart                  # Entry point aplikasi & konfigurasi rute
Tim Pengembang
Makbul Insan Darojat - Fullstack Developer (Project Manager)
Raihan Hafidz Putra P - Database Administrator
Ahmad Mahdi - Frontend Integration
Decky Registian - Backend Developer