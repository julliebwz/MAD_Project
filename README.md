# MAD_PROJECT
## Members:
- AL-QERSHI ABDULLAH ABDULRAHMAN - 1923111
- MOHAMMAD AYYUB AZIZULLAH - 1915021
- BAWAZIER NAJLA GEIS JUNAID - 2017868
- SHOMIDA ROUMHAYATY - 2011978

## Link of App Screenshots and Video
https://drive.google.com/drive/folders/1YYMIjI_Pq0_hxZsHda1fB9QcCuQZuOWk?usp=sharing

## Summary of the project:
The developed app is a comprehensive platform for booking online tickets to tourist attractions in Malaysia. It provides users with a wide range of attractions to choose from, along with detailed information such as images, location, price, and ratings. Users can make informed decisions and conveniently book their preferred attractions, specifying the date and number of attendees. The app utilizes Firebase for secure user authentication and integrates with the TripAdvisor.com API to offer up-to-date attraction details. By simplifying the booking process and providing valuable information, the app helps users plan their trips, save time, and maximize their travel experiences in Malaysia.

## Getting Started

To get started with this project, follow these steps:

1. Clone the repository:

2. Open the project in your preferred IDE or code editor, the project name should be: mad_project not MAD_project.

3. Make sure you have Flutter and Dart installed on your system.
  
5. Firebase Configurations steps:

   1. Just download the full project from github
      or
   2. Follow these steps:
      - Create new project in firebase
      - Go to "Authentication" apply email/password authentication
          From there you can add the users that you need them to use the app 
          In our case we use:
          Email:
          {Name}@mad.com
          Password:
          {Matric No.}

          List of the users: 
          1. qershi@mad.com
          1923111
          2. aziz@mad.com
          1915021
          3. najla@mad.com
          2017868
          4. shomida@mad.com
          2011978
          5. dr.rizal@mad.com
          123456
      - Go to add app in firebase 
          Copy project name 
          
          And paste in the name app name section
          com.example.{project name}
          
          com.example.mad_project
          
           and click on next 

      - Download the json file and put it in android/app directory in the flutter project

      - Add these dependencies in the yaml file 
      
        
            firebase_auth: ^4.6.3
            firebase_core: ^2.5.0
            http: ^0.13.1


      - Go to android/app/build.gradle in the bottom paste the following line 
      
        apply plugin: 'com.google.gms.google-services'
      
      - Go to android/build.gradle
        Paste the following in the dependencies section
      
        classpath 'com.google.gms:google-services:4.3.15'
      - Run the project and it should be working fine
      


## Features

- Sign in with email and password authentication.
- View a list of attractions and their information such as photo, name, location, rating, price.
- Book attractions with the desired number of people and date
- Confirmation page of booking details
- Lets the user edit profile by changing the name and signout feature, the profile name for each account would still be stored even when the account is already signed out.
- Navigate between pages using navigation bar at the bottom of the page.


## Dependencies

This project uses the following dependencies:

- `flutter/material.dart`: Provides the material design components for the UI.
- `dart:convert`: Provides JSON encoding and decoding functionality.
- `http`: Provides HTTP client for making API requests.
- `firebase_core`: Provides the core Firebase functionality.
- `firebase_auth`: Provides Firebase authentication functionality.
- `flutter/widgets.dart`: Provides the Flutter widget framework.
- `get_storage`: Provides a simple key-value storage for Flutter.
