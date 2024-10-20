# Good Health

Pengembangan Aplikasi Client-Server berbasis Mobile Menggunakan Flutter.

## Installation
Download zip dan ekstrak pada direktori project Flutter dengan nama ``good_health``. Buka project tersebut pada VS Code dan masuk ke terminal dengan menekan tombol ``Ctrl + ` ``

Kemudian, masukkan command berikut untuk melakukan instalasi dependencies yang digunakan.
```sh
flutter pub get
```

Selanjutnya, tekan tombol ``Ctrl + Shift + f``, dan cari kata berikut ``PUT_YOUR_API_KEY_HERE``. Ganti kata tersebut dengan Google Maps API Key yang telah dimiliki. Terdapat 3 file yang menggunakan API_KEY.

Pada folder ``/lib/util/config`` di file ``config_mobile.dart``, ubah IPv4 address sesuaikan dengan yang dimiliki. IPv4 address bisa diliat melalui terminal/cmd dengan menggunakan command berikut.
```sh
ipconfig
```
Karena IPv4 bersifat dinamis (akan berubah ketika 'network disconnected'), jadi perlu diubah setiap kali melakukan koneksi ke internet.

---
Untuk menjalankan project flutter di atas dengan baik, download juga zip untuk kode server-side pada link berikut:
https://github.com/rifqiraehan/hygieia

Pastikan sudah melakukan import database 'goodhealth' sebelumnya, jika sudah lewati saja. Kemudian, ubah konfigurasi database untuk ``username`` dan ``password`` pada file ``db.php``.