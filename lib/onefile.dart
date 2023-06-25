import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationScreen(),
    );
  }
}

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // User signed in successfully
      User? user = userCredential.user;
      // Navigate to the home page after successful sign-in
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: user)),
      );
    } catch (e) {
      // Handle sign-in error
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Remove app bar
      body: Container(
        color: Colors.white, // Set white background color
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.beach_access,
                size: 60,
                color: Color(0xFFB86BC7), // Set icon color
              ),
              SizedBox(height: 8),
              Text(
                'ThrillVille',
                style: TextStyle(
                  color: Colors.black, // Set font color
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic, // Set cursive font style
                  fontFamily: 'cursive', // Specify cursive font family
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.person), // Add person icon
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock), // Add lock icon
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity, // Set button width to match input fields
                child: ElevatedButton(
                  onPressed: _signInWithEmailAndPassword,
                  child: Text('Sign In'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFB86BC7), // Set button color
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Attraction> _attractions = [];
  int _currentIndex = 0;
  int numberOfPeople = 1;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.https(
      'travel-advisor.p.rapidapi.com',
      '/attractions/list',
      {
        'location_id': '298570',
        'currency': 'USD',
        'lang': 'en_US',
        'lunit': 'km',
        'sort': 'recommended',
      },
    );

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': '5f3d821700mshc95f507dd40da3cp136635jsnbe6e780bd95f',
        'X-RapidAPI-Host': 'travel-advisor.p.rapidapi.com',
      },
    );

    final data = json.decode(response.body);
    List<Attraction> attractions = Attraction.fromJsonList(data['data']);

    // Sort the attractions by name in alphabetical order
    attractions.sort((a, b) => a.name.compareTo(b.name));

    setState(() {
      _attractions = attractions;
    });
  }

  void navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget getCurrentPage() {
    if (_currentIndex == 0) {
      return buildHomePage();
    } else if (_currentIndex == 2) {
      return ProfilePage();
     } else {
      return Container(); // Placeholder for additional pages
    }
  }

  Widget buildHomePage() {
    return ListView.builder(
      itemCount: _attractions.length,
      itemBuilder: (context, index) {
        final attraction = _attractions[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Card(
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(attraction.photo),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              attraction.rating,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attraction.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              attraction.locationString,
                              style: TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${attraction.lowestPrice}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        title: Text('Booking Details'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Attraction: ${attraction.name}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text('Number of People:'),
                                            SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (numberOfPeople > 1) {
                                                        numberOfPeople--;
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(Icons.remove),
                                                ),
                                                Text(
                                                  numberOfPeople.toString(),
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      numberOfPeople++;
                                                    });
                                                  },
                                                  icon: Icon(Icons.add),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 16),
                                            Text('Date:'),
                                            SizedBox(height: 8),
                                            InkWell(
                                              onTap: () async {
                                                final DateTime? picked = await showDatePicker(
                                                  context: context,
                                                  initialDate: selectedDate,
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2100),
                                                 builder: (BuildContext context, Widget? child) {
                                                  return Theme(
                                                    data: ThemeData.light().copyWith(
                                                      colorScheme: ColorScheme.light().copyWith(
                                                        primary: Color(0xFFB86BC7), // Set the primary color
                                                       ),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                );
                                                if (picked != null && picked != selectedDate) {
                                                  setState(() {
                                                    selectedDate = picked;
                                                  });
                                                }
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.calendar_today),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                                    style: TextStyle(fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => BookingPage(
                                                    attraction: attraction,
                                                    numberOfPeople: numberOfPeople,
                                                    selectedDate: selectedDate,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text('Book'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xFFB86BC7),
                                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text('Book'),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFB86BC7), // Set button color
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFFB86BC7),
        currentIndex: _currentIndex,
        onTap: navigateToPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'My Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


class Booking {
  final Attraction attraction;
  final int numberOfPeople;
  final DateTime selectedDate;

  Booking({
    required this.attraction,
    required this.numberOfPeople,
    required this.selectedDate,
  });
}

class BookingPage extends StatelessWidget {
  final Attraction attraction;
  final int numberOfPeople;
  final DateTime selectedDate;

  const BookingPage({
    required this.attraction,
    required this.numberOfPeople,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB86BC7),
        title: Text('Booking Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Attraction: ${attraction.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Number of People: $numberOfPeople',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Booking booking = Booking(
                  attraction: attraction,
                  numberOfPeople: numberOfPeople,
                  selectedDate: selectedDate,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyBookingPage(booking: booking),
                  ),
                );
              },
              child: Text('Confirm Booking'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFB86BC7),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBookingPage extends StatefulWidget {
  final Booking booking;

  MyBookingPage({required this.booking});

  @override
  _MyBookingPageState createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    addBooking(widget.booking);
  }

  void addBooking(Booking booking) {
    setState(() {
      bookings.insert(0, booking);
    });
  }

  Widget getCurrentPage() {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        Booking booking = bookings[index];
        return ListTile(
          title: Text('Attraction: ${booking.attraction.name}'),
          subtitle: Text(
            'Number of People: ${booking.numberOfPeople}\nDate: ${booking.selectedDate.day}/${booking.selectedDate.month}/${booking.selectedDate.year}',
          ),
        );
      },
    );
  }

  int _currentIndex = 1;

  void navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      // Navigate to Home page
    } else if (index == 1) {
      // Already on My Booking page
    } else if (index == 2) {
      // Navigate to Profile page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB86BC7),
        title: Text('My Bookings'),
      ),
      body: getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFFB86BC7),
        currentIndex: _currentIndex,
        onTap: navigateToPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'My Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = '';
  TextEditingController _nameController = TextEditingController();

  void _showNameInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Your Name'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  _userName = _nameController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Handle the picked image
      // For example, you can save it to a file or upload it to a server
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('lib/assets/placeholder.png'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Change profile pic'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFB86BC7),
              ),
            ),
            SizedBox(height: 16),
            Text(
              _userName.isNotEmpty ? _userName : 'No name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showNameInputDialog,
              child: Text('Change user name'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFB86BC7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Attraction {
  final String name;
  final String locationString;
  final String photo;
  final String rating;
  final String lowestPrice;

  Attraction({
    required this.name,
    required this.locationString,
    required this.photo,
    required this.rating,
    required this.lowestPrice,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      name: json['name'] ?? 'Unknown',
      locationString: json['location_string'] ?? 'Unknown',
      photo: json['photo']?['images']?['large']?['url'] ??
          'https://media.istockphoto.com/id/1409329028/vector/no-picture-available-placeholder-thumbnail-icon-illustration-design.jpg?s=612x612&w=0&k=20&c=_zOuJu755g2eEUioiOUdz_mHKJQJn-tDgIAhQzyeKUQ=',
      rating: json['rating'] ?? '0.0',
      lowestPrice:
          json['offer_group']?['lowest_price']?.toString() ?? '\$0.0',
    );
  }

  static List<Attraction> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Attraction.fromJson(json)).toList();
  }
}
