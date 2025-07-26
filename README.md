# Recogenie Restaurant

A Flutter-based restaurant management application with Firebase backend integration, featuring menu management, user authentication, and modern UI design.

## 🚀 Features

- **User Authentication** - Firebase Auth integration
- **Menu Management** - Browse and manage restaurant menu items
- **Modern UI** - Material Design with custom theming
- **State Management** - Flutter Bloc for reactive state management
- **Dependency Injection** - Injectable for clean architecture
- **Routing** - Go Router for navigation
- **Image Caching** - Cached network images for better performance
- **Environment Configuration** - Secure environment variable management

## 📋 Prerequisites

Before running this project, make sure you have the following installed:

- **Flutter SDK** (version 3.8.1 or higher)
- **Dart SDK** (version 3.8.1 or higher)
- **Android Studio** / **VS Code** with Flutter extensions
- **Firebase CLI** (for Firebase configuration)
- **Git** (for version control)

### Flutter Installation

1. Download Flutter from [flutter.dev](https://flutter.dev/docs/get-started/install)
2. Add Flutter to your PATH
3. Run `flutter doctor` to verify installation

### Firebase Setup

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

## 🛠️ Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/recogenie_restaurant.git
   cd recogenie_restaurant
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate dependency injection code**
   ```bash
   flutter packages pub run build_runner build
   ```

## ⚙️ Environment Configuration

The app requires Firebase API keys to be configured. Create a `.env` file in the root directory:

```bash
# Create .env file
touch .env
```

Add the following environment variables to your `.env` file:

```env
API_KEY_android=your_android_api_key_here
API_KEY_ios=your_ios_api_key_here
```

### Getting Firebase API Keys

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (`restaurant-eea70`)
3. Go to Project Settings > General
4. Scroll down to "Your apps" section
5. Copy the API keys for Android and iOS platforms

## 🔧 Firebase Configuration

The project is already configured for Firebase with the following project details:
- **Project ID**: `restaurant-eea70`
- **Android App ID**: `1:459443909960:android:64410a7fa47cd123076f7d`
- **iOS App ID**: `1:459443909960:ios:5a86d66b45e91c19076f7d`

### Firebase Services Used

- **Firebase Auth** - User authentication
- **Cloud Firestore** - Database for menu items and user data
- **Firebase Core** - Core Firebase functionality

## 🚀 Running the App

### Development Mode

1. **Start the app in debug mode**
   ```bash
   flutter run
   ```

2. **For specific platforms**
   ```bash
   # Android
   flutter run -d android
   
   # iOS (requires macOS)
   flutter run -d ios
   ```

### Production Build

1. **Build for Android**
   ```bash
   flutter build apk --release
   ```

2. **Build for iOS**
   ```bash
   flutter build ios --release
   ```

## 📱 Platform Support

- ✅ **Android** - Fully supported
- ✅ **iOS** - Fully supported
- ❌ **Web** - Not configured
- ❌ **Windows** - Not configured
- ❌ **macOS** - Not configured
- ❌ **Linux** - Not configured

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── di/           # Dependency injection
│   ├── routing/      # App routing
│   └── theme/        # App theming
├── features/         # Feature modules
├── firebase_options.dart  # Firebase configuration
└── main.dart         # App entry point
```

## 🛠️ Development

### Code Generation

The project uses code generation for dependency injection. After making changes to injectable classes, run:

```bash
flutter packages pub run build_runner build
```

Or for continuous generation during development:

```bash
flutter packages pub run build_runner watch
```

### Adding Menu Data

To populate the Firestore database with initial menu data, uncomment the following line in `lib/main.dart`:

```dart
//addMenuData(); //todo Uncomment to add initial menu data
```

### Dependencies

Key dependencies used in this project:

- **flutter_bloc** - State management
- **go_router** - Navigation
- **firebase_core** - Firebase core functionality
- **firebase_auth** - User authentication
- **cloud_firestore** - Database
- **injectable** - Dependency injection
- **get_it** - Service locator
- **flutter_dotenv** - Environment variables
- **cached_network_image** - Image caching
- **cherry_toast** - Toast notifications
- **shared_preferences** - Local storage

## 🐛 Troubleshooting

### Common Issues

1. **Environment variables not loading**
   - Ensure `.env` file exists in root directory
   - Check file encoding (should be UTF-8)
   - Verify API keys are correct

2. **Firebase connection issues**
   - Verify Firebase project configuration
   - Check internet connection
   - Ensure API keys are valid

3. **Build errors**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Run `flutter packages pub run build_runner build`

4. **Dependency injection errors**
   - Run `flutter packages pub run build_runner build --delete-conflicting-outputs`

### Flutter Doctor

Run `flutter doctor` to check for any setup issues:

```bash
flutter doctor
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

If you encounter any issues or have questions, please:

1. Check the troubleshooting section above
2. Search existing issues in the repository
3. Create a new issue with detailed information about your problem

---

**Happy coding! 🎉**

