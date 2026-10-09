# Worksheet 6 - Course Explorer v2

**Nama**: Made Pasek Merta Sujati  
**NIM**: 2415051096  

## Arsitektur Aplikasi & Tanggung Jawab Folder

Aplikasi ini menerapkan alur ketergantungan (*dependency direction*) satu arah:  
`Screen / Widget` -> `Provider` -> `Repository` -> `Service / Data Source`

Berikut adalah tanggung jawab masing-masing direktori di dalam folder `lib/`:

* **`models/`**: Mendefinisikan class data (`course.dart`) dan proses parsing JSON.
* **`services/`**: Menangani pembacaan data mentah dari data source (`rootBundle` / file JSON `student_data.json`).
* **`repositories/`**: Mengelola logika bisnis dan pengolahan data yang didapat dari layer Service.
* **`providers/`**: Mengelola state aplikasi (aplikasi state & favorit) dan memberitahu UI saat terjadi perubahan data (`notifyListeners`).
* **`screens/`**: Menampilkan antarmuka halaman utama, detail, dan favorit.
* **`widgets/`**: Menyimpan komponen UI modular yang dapat digunakan kembali (*reusable widgets*).