# HackOn: Student Details Management System

HackOn is a Flutter-based project designed to manage student details efficiently. It integrates Firebase for authentication and Firestore for data storage, while leveraging Azure Blob Storage for image uploads. This application enables users to upload, update, and retrieve student information seamlessly with a user-friendly interface.

---

## Features

1. **User Authentication**:
   - Firebase Authentication for secure user login and registration.

2. **Student Details Management**:
   - Update personal information (Name, College, Department, Phone Number, Semester).
   - Upload and update profile images with Azure Blob Storage integration.

3. **Firestore Integration**:
   - Store and retrieve student details in real-time.

4. **Azure Blob Storage**:
   - Securely upload profile images to Azure Blob Storage using a SAS token.

5. **Responsive UI**:
   - Adaptive design ensures compatibility across multiple devices.

---

## Tech Stack

- **Frontend**: Flutter
- **Backend**: Firebase Firestore, Firebase Authentication
- **Storage**: Azure Blob Storage
- **Language**: Dart

---

## Prerequisites

Before you begin, ensure you have met the following requirements:

1. Install Flutter SDK: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
2. Set up Firebase for your project: [Firebase Setup Guide](https://firebase.google.com/docs/flutter/setup)
3. Configure an Azure Blob Storage account:
   - Create a storage account in Azure.
   - Generate a SAS token with necessary permissions for the Blob Container.

---

## Setup Instructions

1. **Install dependencies**:
    ```bash
    flutter pub get
    ```

2. **Firebase Configuration**:
    - Add your `google-services.json` file to the `android/app` directory.
    - Add your `GoogleService-Info.plist` file to the `ios/Runner` directory.

3. **Configure Azure Blob Storage**:
    - Update the `uploadImageToAzure` method in the code with your Azure Storage account name, container name, and SAS token.

4. **Run the project**:
    ```bash
    flutter run
    ```

