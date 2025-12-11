# 🚚 EKSPEDISI APP - Dokumentasi Lengkap

## 📋 ANALISIS WORKSPACE

### **Tujuan Aplikasi**
Aplikasi **Flutter EKSPEDISI** ini adalah sistem manajemen logistik dan pengiriman dengan fitur:
- ✅ Authentication (Login/Register)
- ✅ Dashboard approval expedisi
- ✅ Surat Jalan management 
- ✅ Purchasing system
- ✅ Invoice management
- ✅ Profile management
- ✅ Digital signature
- ✅ Scrap/Inventory tracking

### **Struktur Arsitektur**
```
lib/
├── main.dart                   # Entry point app
├── models/                     # Data models
│   ├── ScrapItem.dart         # Model barang scrap
│   └── SuratTagih.dart        # Model surat tagih
├── services/                   # API & business logic
│   ├── auth_service.dart      # Authentication service
│   └── dashboard_service.dart # Dashboard API calls
└── pages/                     # UI screens
    ├── login/                 # Authentication pages
    ├── home/                  # Dashboard & main screens
    ├── ekspedisi/            # Shipping/logistics
    ├── purchasing/           # Purchase order system
    ├── profile/              # User management
    └── riwayat/             # History/reports
```

---

## 🚨 **MASALAH UTAMA & SOLUSI**

### **Problem #1: Backend Connection Error**
```
Error No. 2003: Can't connect to MySQL server on '192.168.3.3' (10060)
```

**Root Cause:** 
- Backend API tidak running di `192.168.3.3:8000`
- MySQL server offline/unreachable
- Network configuration issue

**Solusi:**
```bash
# 1. Start Laravel backend server
php artisan serve --host=192.168.3.3 --port=8000

# 2. Check MySQL service
net start MySQL80

# 3. Test connection
telnet 192.168.3.3 8000
```

### **Problem #2: Flutter Dependencies Issues**
**Status:** ✅ FIXED - All dependencies properly installed

### **Problem #3: Missing Backend Setup**
**Backend Requirements:**
- Laravel 9+ with API routes
- MySQL database
- Auth endpoints: `/api/auth/owner/login`, `/api/auth/me`, `/api/auth/logout`

---

## 🛠️ **CARA RUNNING PROJECT**

### **Step 1: Setup Backend (Laravel)**
```bash
# Clone/setup Laravel project
composer install
cp .env.example .env
php artisan key:generate

# Database setup
php artisan migrate
php artisan db:seed

# Run server
php artisan serve --host=192.168.3.3 --port=8000
```

### **Step 2: Setup Flutter App**
```bash
cd d:\MAGANG\Ekspedisi

# Install dependencies
flutter pub get

# Generate app icons
flutter pub run flutter_launcher_icons:main

# Run on device/emulator
flutter run
```

### **Step 3: Fix Backend URL**
File sudah diupdate: `lib/services/auth_service.dart`
```dart
final String baseUrl = "http://192.168.3.3:8000/api";
```

### **Step 4: Test Login**
Default credentials (setup di Laravel seeder):
```
Email: admin@example.com
Password: 12345678
```

---

## 🔧 **FEATURES IMPLEMENTED**

### **✅ Authentication System**
- Splash screen → Login → Dashboard
- Token-based auth dengan SharedPreferences
- Error handling & validation

### **✅ Dashboard Module**
- Welcome header dengan user info
- "Perlu Disetujui" approval list
- Bottom navigation: Ekspedisi, Profil, Purchasing, Riwayat
- Smooth animations & transitions

### **✅ Surat Jalan (Shipping)**
- Form input penerima & pengirim
- Digital signature pad
- Save & preview functionality
- "Buat Surat Jalan" action

### **✅ Purchasing System**
- Lokal & Import purchase forms
- Supplier selection
- Dynamic item lists
- Image upload signatures

### **✅ Profile Management**
- View/edit profile
- Avatar upload
- Last login tracking

### **✅ Additional Features**
- Invoice export management
- Scrap item tracking
- PDF generation (printing package)
- Image picking & handling

---

## 📱 **NAVIGASI FLOW**

```
WelcomePage (3s timer)
    ↓
LoginPage (auth_service.dart)
    ↓
DashboardPage
    ├── ExpedisiPage → SJUmumPage (digital signature)
    ├── ProfilPage → EditProfilPage
    ├── PurchasingDashboard → Forms
    └── RiwayatPage
```

---

## 🗄️ **DATABASE STRUCTURE (Expected)**

### **Users Table**
```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE,
    password VARCHAR(255),
    name VARCHAR(255),
    role ENUM('admin', 'owner'),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

### **Approvals Table**
```sql
CREATE TABLE approvals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    description TEXT,
    status ENUM('pending', 'approved', 'rejected'),
    created_by INT,
    created_at TIMESTAMP
);
```

---

## ⚠️ **NEXT STEPS TO FIX**

### **Priority 1: Backend Setup**
1. **Setup Laravel project** dengan API routes
2. **Create authentication endpoints**
3. **Setup MySQL database** 
4. **Test API endpoints** dengan Postman

### **Priority 2: Integration Testing**
1. **Test login flow** end-to-end
2. **Verify token storage** & retrieval
3. **Test navigation** antar pages
4. **Check image upload** functionality

### **Priority 3: Deployment**
1. **Setup production backend** (VPS/cloud)
2. **Configure HTTPS** untuk production
3. **Build APK** untuk testing
4. **Setup CI/CD** pipeline

---

## 📞 **TROUBLESHOOTING**

### **Common Issues & Solutions**

**Issue:** "Connection refused"
```bash
# Check if backend running
curl http://192.168.3.3:8000/api/auth/owner/login

# Fix: Start Laravel server
php artisan serve --host=192.168.3.3 --port=8000
```

**Issue:** "Token not found"
```dart
// Clear stored data
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.clear();
```

**Issue:** "Image picker not working"
```yaml
# Add to android/app/src/main/AndroidManifest.xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

---

## 📝 **CATATAN PENTING**

1. **IP Address:** Update `192.168.3.3` sesuai dengan IP backend server kamu
2. **Port:** Default Laravel dev server = `8000`, sesuaikan jika berbeda  
3. **CORS:** Pastikan Laravel config CORS allow Flutter origin
4. **Assets:** All images & fonts sudah properly configured
5. **Packages:** All dependencies compatible dengan Flutter 3.32.7

**Status Project:** 🔄 **READY TO RUN** (setelah backend setup)

---

## 👥 **TEAM INFO**

**Project:** EKSPEDISI Management System  
**Framework:** Flutter 3.32.7 + Dart 3.8.1  
**Backend:** Laravel + MySQL  
**Type:** Mobile Logistics App  

**Current Status:** ✅ Frontend Complete, 🔄 Backend Required