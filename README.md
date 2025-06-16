# Uber Clone Mobile App

A Flutter-based Uber clone UI with clean architecture and Riverpod, featuring complete ride-sharing flow with dummy interactions.

## Overview

This project implements a mobile-only Uber clone UI using Flutter. It follows clean architecture principles and uses Riverpod for state management. The app focuses on providing a complete user experience for ride-sharing applications.

## Features

- Splash screen and onboarding flow
- Authentication (login/signup) with validation
- Home screen with map view and ride booking
- Location selection for pickup and dropoff
- Vehicle type selection with price estimates
- Driver search and ride assignment
- Ride in progress tracking
- Ride completion with fare summary
- User profile and ride history

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio or Xcode for mobile deployment
- An emulator or physical device for testing

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Connect a mobile device or start an emulator
5. Run `flutter run` to launch the app

## Project Structure

The project follows a feature-first organization with clean architecture principles:

- **lib/app**: App-wide configurations (theme, routing)
- **lib/core**: Core utilities and reusable widgets
- **lib/features**: Feature modules organized by domain
  - **auth**: Authentication-related screens and logic
  - **home**: Home screen and map view
  - **onboarding**: Splash and onboarding screens
  - **profile**: User profile management
  - **ride**: Ride booking and tracking functionality

## Mobile Development Focus

This project is designed specifically for mobile platforms (Android and iOS) with a focus on providing a native-like experience. It uses:

- Responsive layouts for various mobile screen sizes
- Platform-specific UI elements where appropriate
- Material Design guidelines for a modern look and feel
- Efficient state management for smooth performance

## Viewing on Mobile Devices

To view the app on a physical device:

1. Enable USB debugging on your Android device or register your iOS device
2. Connect your device to your computer
3. Run `flutter devices` to ensure your device is recognized
4. Run `flutter run` to install and launch the app

Alternatively, use an emulator:

- Android: `flutter run -d <emulator_id>`
- iOS: `flutter run -d <simulator_id>`

## Screenshots

(Note: Screenshots would be included here in a complete project)

## Credits

This project was developed as a demonstration of Flutter's capabilities for mobile app development, focusing on UI implementation and state management with Riverpod.
