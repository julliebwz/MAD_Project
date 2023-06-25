# MAD_Project
- AL-QERSHI ABDULLAH ABDULRAHMAN - 1923111
- MOHAMMAD AYYUB AZIZULLAH - 1915021
- BAWAZIER NAJLA GEIS JUNAID - 2017868
- SHOMIDA ROUMHAYATY - 2011978


The provided code is a Flutter application that demonstrates Firebase authentication and data fetching from an API. It includes several screens and functionalities. Here's a breakdown of the code:

1. The code imports necessary packages, including flutter/material.dart, dart:convert, http, firebase_core, firebase_auth, image_picker, and others.

2. The main function initializes Firebase and runs the Flutter application.

3. The MyApp class is the root widget of the application. It sets the title, theme, and initial screen.

4. The AuthenticationScreen class is a StatefulWidget that represents the authentication screen. It includes text fields for email and password, an icon, a title, and a sign-in button. When the user taps the sign-in button, it triggers the _signInWithEmailAndPassword function to authenticate the user using Firebase Authentication.

5. The _signInWithEmailAndPassword function attempts to sign in the user with the provided email and password using the _auth instance of FirebaseAuth. If the sign-in is successful, it navigates to the home page (HomePage) passing the authenticated user. If there's an error, it sets the _errorMessage variable to display the error message.

6. The HomePage class is a StatefulWidget that represents the main page of the application. It fetches data from an API using http package and displays a list of attractions. The user can navigate between pages using a bottom navigation bar.

7. The fetchData function sends an HTTP GET request to the API and retrieves a list of attractions. It then sorts the attractions by name and updates the state with the fetched data.

8. The _currentIndex variable keeps track of the current page in the HomePage. The navigateToPage function is called when the user taps on a bottom navigation bar item, and it updates the _currentIndex accordingly.

9. The buildHomePage function builds the home page by mapping the _attractions list to a ListView.builder and displaying each attraction as a Card.

10. The Booking class represents a booking with an attraction, number of people, and selected date.

11. The BookingPage class displays the booking confirmation screen with the attraction details, number of people, and selected date. When the user taps the "Confirm Booking" button, it navigates to the MyBookingPage passing the booking details.

12. The MyBookingPage class displays the user's bookings as a list. It maintains a list of Booking objects and provides a addBooking function to add a new booking to the list. The getCurrentPage function builds the current page based on the _currentIndex value.

13. The bottomNavigationBar in MyBookingPage allows the user to navigate between different pages: Home, My Bookings (already selected), and Profile.

Overall, the code provides a basic structure for a Flutter application with Firebase authentication and API data fetching. It demonstrates navigation between screens, input handling, and state management.
