# Rentahanan

**Rentahanan** is a Flutter-based mobile application designed to help property managers and tenants efficiently manage dues, payments, and tenant information.

---

## Features

- Add, view, and manage tenants
- Track dues and payments for each tenant
- Swipeable carousel to view past dues
- Generate summaries of total amounts to pay and remaining balances

---
## 📁 Project Structure
```
App-Title/
└── lib/
    ├── data/
    │   ├── models/      		    # Blueprints: Converts Firestore JSON to Dart Objects
    │   └── repositories/     	# Logic: Pure Firebase functions (Auth, CRUD, etc.)
    │
    ├── features/             	# Business Logic & UI grouped by feature
    │   ├── auth/             	# Login, Signup, Forgot Password
    │   │   ├── pages/        	# Full-screen widgets
    │   │   └── widgets/      	# Small, reusable auth-only components
    │   │
    │   ├── tenant/           	# Logic specific to the Tenant role
    │   │   ├── pages/        
    │   │   └── widgets/      
    │   │
    │   └── manager/          	# Logic specific to the Manager role
    │       ├── pages/        
    │       └── widgets/      
    │
    ├── app.dart              	# Global app settings (Theming, Route generation)
    └── main.dart             	# Root: App entry point & Firebase initialization
```
---

## Getting Started

You can download the app from this link:

[Download Rentahanan APK](https://drive.google.com/file/d/1t8bHgFoL3LDYk-pxi9IEHhWny_K9KOh2/view?usp=drive_link)

Simply install the APK on your Android device and start managing your rental properties.

---

## Built With

- [Flutter](https://flutter.dev/)
- [Firebase Firestore](https://firebase.google.com/docs/firestore) for backend data storage
