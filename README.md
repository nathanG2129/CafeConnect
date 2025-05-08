# Cafe Connect - Flutter Coffee Shop App

A Flutter coffee shop application with user roles, authentication, and staff management features.

## User Roles

The application supports two user roles:

- **User**: Regular customers who can view the menu, place orders, and manage their profiles.
- **Staff**: Staff members who can access the staff dashboard, manage orders, customers, and inventory.

## Setting Up Staff Accounts

### Using the Create Staff Accounts Script

The application includes a script to create staff accounts. To use it:

1. Make sure Firebase is properly set up.
2. Run the following command:

```bash
dart scripts/create_staff_accounts.dart
```

This will create two staff accounts:

1. Email: staff1@example.com, Password: staff123
2. Email: staff2@example.com, Password: staff123

### Manually Creating Staff Accounts

To manually create a staff account:

1. Create a new user account through the registration page.
2. Use a Firebase Admin SDK or Firestore console to update the user's role field to 'staff'.

## App Navigation Based on Roles

- When a user logs in, they are directed to the appropriate page based on their role:
  - Regular users (role: 'user') are directed to the Home page.
  - Staff members (role: 'staff') are directed to the Staff Dashboard.

- The drawer menu shows different options based on the user's role.

## Implementation Details

- **Role field**: Added to the UserModel class with a default value of 'user'.
- **Existing accounts**: If an existing account doesn't have a role, it's automatically assigned the 'user' role on login.
- **Staff Dashboard**: Created a dashboard page specifically for staff members with management features.
- **Adaptive UI**: Drawer menu and navigation options adapt based on the user's role.

## For Developers

To extend the role system:

1. Add new roles in the appropriate dropdown in registration_page.dart
2. Update the getAppropriateRoute() method in auth_service.dart 
3. Create role-specific pages as needed
4. Modify the app_drawer.dart file to show appropriate menu items for new roles

## Features Overview

Cafe Connect offers a complete coffee shop experience with the following features:

- **User Authentication**: Secure login and registration system
- **Role-Based Access**: Different interfaces for customers and staff
- **Coffee Menu**: Browse a variety of coffee beverages with detailed information
- **Custom Ordering**: Select size, quantity, and add-ons for beverages
- **Order History**: View past orders and their status
- **Coffee Guide**: Educational content about coffee types and preparation
- **Profile Management**: User profile editing and settings
- **Staff Dashboard**: Monitor and manage orders, products, and customers
- **Inventory Management**: Staff can update product availability and details

## Technical Architecture

This application is built with the following technical components:

- **Flutter**: UI framework for cross-platform development
- **Firebase Authentication**: Secure user authentication system
- **Cloud Firestore**: NoSQL database for storing user data, orders, and product information
- **GetStorage**: Local storage solution for persisting app state
- **Responsive Design**: Adapts to different screen sizes and orientations

## Installation & Setup

### Prerequisites
- Flutter SDK (2.0 or newer)
- Dart SDK
- Android Studio or VS Code with Flutter plugins
- Firebase account

### Setup Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/cafe-connect.git
   cd cafe-connect
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up Firebase (see Firebase Configuration section below)

4. Run the app:
   ```bash
   flutter run
   ```

## Coffee Menu & Ordering System

The app features a comprehensive coffee ordering system:

- **Menu Browsing**: Users can browse through various coffee types with detailed descriptions
- **Order Customization**: Each drink can be customized with:
  - Different sizes (Small, Medium, Large) with corresponding price adjustments
  - Optional add-ons (Extra shot, Whipped cream, etc.)
  - Quantity selection
- **Cart Management**: Add, edit, or remove items before checkout
- **Order Confirmation**: Review order details before finalizing
- **Order Tracking**: Follow the status of current orders (Pending, In Progress, Ready, Completed)

## Firebase Configuration

To configure Firebase for this project:

1. Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com/)
2. Add an Android and/or iOS app to your Firebase project
3. Download the configuration files:
   - For Android: `google-services.json` (place in android/app/)
   - For iOS: `GoogleService-Info.plist` (place in ios/Runner/)
4. Enable Authentication with Email/Password sign-in method
5. Create Firestore Database and set up security rules
6. Update the Firebase configuration in the app:
   ```dart
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

## Screenshots & UI

[Consider adding screenshots of key app screens here, such as:]
- Login Screen
- User Home Page
- Coffee Menu
- Order Customization Dialog
- Staff Dashboard
- Order Management

## Troubleshooting

### Common Issues and Solutions

- **Firebase Connection Issues**: 
  - Check your internet connection
  - Verify that your Firebase configuration files are properly placed
  - Ensure Firebase services are enabled in your project

- **Build Errors**:
  - Run `flutter clean` followed by `flutter pub get`
  - Check for any conflicting dependencies in pubspec.yaml

- **Authentication Problems**:
  - Verify that Email/Password authentication is enabled in Firebase Console
  - Check if the user exists in Firebase Authentication

## Future Enhancements

Planned features for future releases:

- **Payment Integration**: Add secure payment processing
- **Loyalty Program**: Reward system for regular customers
- **Push Notifications**: Order status updates and promotional offers
- **Offline Mode**: Basic functionality when offline
- **Analytics Dashboard**: Insights for business owners
- **Multi-language Support**: Internationalization for wider accessibility
