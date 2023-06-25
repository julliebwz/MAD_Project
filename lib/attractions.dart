import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
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
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
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
                                    int numberOfPeople = 1;
                                    DateTime selectedDate = DateTime.now();

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
                                                    builder: (context) => BookingPage(attraction: attraction),
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
      ),
    );
  }
}



class BookingPage extends StatelessWidget {
  final Attraction attraction;

  const BookingPage({required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB86BC7),
        title: Text('Booking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Attraction: ${attraction.name}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
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
              'Number of People: 1',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Perform the booking logic here
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
