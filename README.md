# 🤖 Integrasi Generative AI (Google Gemini)

Proyek **Flutter** untuk **Praktikum Pemrograman Mobile (Semester 7)** yang mendemonstrasikan integrasi **Generative AI Google Gemini** dalam bentuk aplikasi **chat sederhana**.

---

## 📖 Deskripsi Proyek

Aplikasi ini merupakan **aplikasi Flutter minimal** yang menyediakan **halaman chat** sebagai antarmuka interaksi antara pengguna dan layanan **Generative AI Google Gemini**.  
Proyek ini dirancang untuk membantu mahasiswa memahami:

- Struktur dasar proyek Flutter
- Alur pengembangan aplikasi mobile
- Integrasi layanan AI pada aplikasi mobile

Seluruh kode sumber utama berada pada folder `lib/`, dengan fokus pada implementasi **UI**, **navigasi**, dan **pengembangan fitur lanjutan**.

---

## ✨ Fitur Utama

- 💬 **Halaman Chat Sederhana**  
  Menampilkan antarmuka chat dasar yang diimplementasikan pada  
  `lib/pages/chat_page.dart`.

- 🧱 **Struktur Proyek Standar Flutter**  
  Mengikuti standar Flutter dan mendukung multi-platform:
  Android, iOS, Web, dan Desktop.

- 🚀 **Mudah Dikembangkan**  
  Struktur kode memungkinkan penambahan:
  - Integrasi API Google Gemini
  - State management
  - Penyimpanan data
  - Fitur AI lanjutan

---

## ⚙️ Persyaratan Sistem

Pastikan lingkungan pengembangan telah memenuhi persyaratan berikut:

- **Flutter SDK** (disarankan versi stabil terbaru)
- **Android SDK** dan/atau **Xcode** (untuk target Android/iOS)
- **Emulator** atau **perangkat fisik**

---

## 🛠️ Instalasi

### 1️⃣ Clone Repository

```bash
git clone <repo-url>
cd iga_2200016058
````

### 2️⃣ Install Dependency

```bash
flutter pub get
```

---

## ▶️ Menjalankan Aplikasi

### Menjalankan di Emulator / Perangkat Android

```bash
flutter run
```

### Menjalankan di Browser (Web)

```bash
flutter run -d chrome
```

### Build APK (Release)

```bash
flutter build apk --release
```

---

## 🧪 Catatan Pengembangan

* Seluruh pengembangan UI dan logika aplikasi berada di folder `lib/`.
* Untuk menambah fitur baru:

  1. Buat file halaman baru di `lib/pages/`
  2. Daftarkan navigasinya di `main.dart`
* Jika terjadi error dependency, jalankan:

```bash
flutter clean
flutter pub get
```

---
## 📄 Lisensi

Proyek ini **tidak menyertakan lisensi khusus** dan digunakan untuk **keperluan akademis dan pembelajaran**.

