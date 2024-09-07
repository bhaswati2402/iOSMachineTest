# iOSMachineTest
Machine test application
# Bluetooth Device List

## Overview

This iOS app demonstrates Bluetooth device scanning, connection, and management using CoreBluetooth and the MVVM architecture pattern.

## Features

- **Scan for Nearby Bluetooth Devices**: Automatically detects nearby Bluetooth devices.
- **Display Devices**: Lists available Bluetooth devices with their RSSI (signal strength).
- **Connect to a Device**: Allows users to connect to a selected Bluetooth device. The system handles pairing prompts if necessary.
- **Error Handling**: Provides feedback if there are issues with Bluetooth scanning, connection, or other errors.

## Architecture

- **Model**: Represents Bluetooth devices with relevant properties.
- **ViewModel**: Handles business logic, including scanning, connecting, and managing Bluetooth devices. It communicates state changes to the View.
- **View**: Displays the list of devices and handles user interactions. Updates UI based on the ViewModel's state.

## Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/bhaswati2402/iOSMachineTest.git
   
2. **Open the Project** :

Open the iOSMachineTest.xcodeproj file in Xcode.

3. **Run the Application**:

Connect a physical iOS device (since Bluetooth cannot be tested on the simulator).

Select your device in Xcode and click the Run button.
