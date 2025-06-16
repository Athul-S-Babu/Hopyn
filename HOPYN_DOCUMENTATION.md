# Hopyn Mobile App Documentation

## Overview
This is a Flutter-based mobile Hopyn app with clean architecture and Riverpod for state management. The app focuses on providing a complete ride-sharing flow with dummy interactions and is designed specifically for mobile platforms (Android/iOS).

## Architecture
The project follows Clean Architecture principles with a feature-first organization:

```
lib/
├── app/              # App-wide configurations
├── core/             # Core utilities and widgets
└── features/         # Feature modules
    ├── auth/         # Authentication features
    ├── home/         # Home screen features
    ├── onboarding/   # Onboarding and splash screens
    ├── profile/      # User profile features
    └── ride/         # Ride booking and tracking features
```

## Key Features

### 1. Onboarding and Authentication
- Splash screen with animated logo
- Onboarding screens for first-time users
- Login and signup screens with validation

### 2. Home Screen
- Map view (using Google Maps)
- Location search and saved places
- Ride booking button

### 3. Ride Booking Flow
- Location selection (pickup and dropoff)
- Vehicle type selection (Economy, Comfort, Premium)
- Fare estimate display
- Payment method selection

### 4. Ride Experience
- Driver search animation
- Driver details display
- Ride in progress tracking
- Ride completion with fare summary

### 5. User Profile
- User information management
- Ride history view
- App settings

## State Management
The app uses Riverpod for state management, with the following main providers:

- `currentRideProvider`: Manages the current ride state
- `savedLocationsProvider`: Provides saved user locations
- `vehicleTypesProvider`: Provides available vehicle types
- `rideHistoryProvider`: Provides user's ride history

## Navigation
Navigation is handled with `go_router` for clean, declarative routing between screens.

## UI Components
Custom UI components include:

- `CustomButton`: Versatile button with multiple styles
- `CustomTextField`: Text input field with validation
- `LoadingIndicator`: Loading animation component
- `VehicleTypeCard`: Card for displaying vehicle options
- `RideMap`: Custom map component for ride tracking

## Mobile-Specific Features

### Android
- Native Android implementation
- Material Design components
- Google Maps integration

### iOS
- Native iOS implementation
- Cupertino-style components where appropriate
- Maps integration

## Development Notes
- The app uses dummy data for demonstration purposes
- No backend integration is implemented (offline-only)
- Designed for portrait orientation on mobile devices
