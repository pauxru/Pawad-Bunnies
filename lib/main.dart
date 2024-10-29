import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_drive/new_rabbit.dart';
import 'package:test_drive/ToDoPage.dart';
import 'package:test_drive/rabbit_details_page.dart';
import 'package:test_drive/profile.dart';
import 'package:test_drive/AppConfig.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    AppConfig().API_ENDPOINT_GLOBAL = dotenv.env['API_ENDPOINT'] ??
        'http://pawadtech.one:8080'; // Initialize the global variable
    print('Loaded .env file successfully');
  } catch (e) {
    print('Error loading .env file: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawad Bunnies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 90, 224, 241),
          onPrimary: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pawad Bunnies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Rabbit> rabbits = [];

  @override
  void initState() {
    super.initState();
    // Load rabbits from the local JSON file
    loadRabbits();
  }

  Future<File> get _rLocalFile async {
    // Get the directory where the app can store data
    final directory = await getApplicationDocumentsDirectory();
    // Return the file path for 'rabbits.json' in the document directory
    return File('${directory.path}/rabbits.json');
  }

  Future<void> loadRabbits() async {
    int localSize = 0;

    try {
      // Get the path to the local file
      final file = await _rLocalFile;

      // Check if the file exists in the internal storage directory
      if (await file.exists()) {
        // Read the JSON data from the file
        String jsonString = await file.readAsString();
        if (jsonString.isEmpty || jsonString.length < 10) {
          print('No Data Found in local file!!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No data is available locally!')),
          );
        } else {
          print('Loaded data from local file: ${file.path}');
          print('JSON String from file: $jsonString');

          // Decode the JSON data
          final jsonContent = jsonDecode(jsonString);

          // Check if jsonContent is a List
          if (jsonContent is List) {
            // Parse the JSON data into a list of Rabbit objects
            final List<Rabbit> rabbitList = jsonContent
                .map<Rabbit>((json) => Rabbit.fromJson(json))
                .toList();
            localSize = rabbitList.length;

            setState(() {
              rabbits = rabbitList;
            });

            print('Successfully loaded $localSize rabbits from local file.');
          } else {
            print(
                'Error: JSON data is not a list. Current content: $jsonContent');
          }
        }
      } else {
        print('Local file not found: ${file.path}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('First time! Welcome!!')),
        );
      }
    } catch (e) {
      print('Error loading rabbits from file: $e');
    }

    // Now, initiate the API call in the background and update the state when the response is received.
    loadRabbits_API(localSize).then((rret) {
      if (rret == 200) {
        print('Rabbits loaded successfully from API and local data refreshed.');
        //loadRabbits(); // Reload rabbits from local file to update state
      } else {
        print('Failed to update rabbits from API.');
      }
    });
  }

  Future<int> loadRabbits_API(int localSize) async {
    int serverSize = 0;
    print('Here at loadRabbits_API');
    try {
      // Define the API endpoint URL
      final String apiUrl = '${AppConfig().API_ENDPOINT_GLOBAL}/api/rabbits';
      print('Getting Rabbits from: $apiUrl');

      if (apiUrl.isEmpty || !(Uri.parse(apiUrl).isAbsolute)) {
        print('Invalid API URL: $apiUrl');
        return -1; // or handle the error appropriately
      }

      // Make the HTTP GET request to the API
      final http.Response response = await http.get(Uri.parse(apiUrl));

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        print('Successfully received response: ${response.body}');

        // Parse the JSON data into a list of Rabbit objects
        final List<dynamic> jsonList = json.decode(response.body);

        // Check if the JSON is a list
        if (jsonList is List) {
          final List<Rabbit> rabbitList =
              jsonList.map((json) => Rabbit.fromJson(json)).toList();

          // Save the data to the local file (write new data, removing old data)
          await saveRabbitDataToFile(
              rabbitList.map((rabbit) => rabbit.toJson()).toList());

          print('Parsed rabbit data successfully: $rabbitList');
          serverSize = rabbitList.length;

          if (localSize > serverSize) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('New data available. Please refresh!')),
            );
          }
        } else {
          print('Unexpected JSON format, expected a list but got: $jsonList');
          throw Exception('Failed to parse rabbit data, unexpected format');
        }
      } else {
        // Handle the error if the response is not successful
        print(
            'Failed to load rabbits with status code: ${response.statusCode}');
        throw Exception('Failed to load rabbits');
      }
      return response.statusCode;
    } on FormatException catch (e) {
      print('Error parsing JSON data: $e');
      return -1;
    } catch (e) {
      // Handle any other errors that occur during the HTTP request
      print('Unexpected error loading rabbits: $e');
      return -2;
    }
  }

  Future<int> saveRabbitDataToFile(List<dynamic> jsonDataList) async {
    print('Here at saveRabbitDataToFile');
    try {
      // Get the local file path
      final file = await _rLocalFile;

      // If the file doesn't exist, create it
      if (!(await file.exists())) {
        print('File does not exist. Creating it.');
        // Create the file
        await file.create();
      }

      // Write the new data to the file, removing any existing content
      await file.writeAsString(jsonEncode(jsonDataList), mode: FileMode.write);
      print('Data written to file successfully at: ${file.path}');
      return 0;
    } catch (e) {
      throw Exception('Error writing data to file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 90, 224, 241),
        title: Text(widget.title),
      ),
      body: RabbitListWidget(rabbits: rabbits),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RabbitForm()),
          );
          // Handle the ADD button press, you can navigate to a new page or perform other actions.
          // For example, let's print a message to the console.
          print('ADD button pressed');
        },
        backgroundColor: Color.fromARGB(255, 90, 224, 241),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.lightGreenAccent,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Rabbits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Todo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          //selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
            // Handle navigation based on index
            print('Tapped index: $index');

            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodoListPage()),
                );
                break;
              case 2:
                // Navigate to the new ProfilePage when index 2 is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}

class Rabbit {
  final String tagNo;
  final DateTime? birthday;
  final String breed;
  final String mother;
  final String father;
  final String sex;
  final String origin;
  final String diseases;
  final String comments;
  final String weight;
  final String priceSold;
  final String cage;
  final List<String> images;

  Rabbit({
    required this.tagNo,
    this.birthday,
    required this.breed,
    required this.mother,
    required this.father,
    required this.sex,
    required this.origin,
    required this.diseases,
    required this.comments,
    required this.weight,
    required this.priceSold,
    required this.cage,
    required this.images,
  });

  factory Rabbit.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null; // Handle null input

      try {
        return DateTime.parse(dateString);
      } catch (e) {
        try {
          final DateFormat customFormat = DateFormat('dd/MM/yyyy');
          return customFormat.parse(dateString);
        } catch (e) {
          print('Error parsing date: $dateString');
          return null; // Return null if parsing fails
        }
      }
    }

    // Safely handle the images list
    List<String> images = [];
    if (json['images'] != null) {
      if (json['images'] is List) {
        images = List<String>.from(json['images']);
      } else if (json['images'] is String) {
        images = [json['images']]; // Wrap the string in a list
        print('Warning: "images" is a String, converted to list: $images');
      } else {
        print(
            'Warning: "images" is not a List or String, received: ${json['images']}');
      }
    } else {
      print('Warning: "images" key is missing or null');
    }

    // Ensure required fields are present
    if (json['tagNo'] == null) {
      throw ArgumentError('Missing required field: tagNo');
    }

    return Rabbit(
      tagNo: json['tagNo'],
      birthday: parseDate(json['birthday']),
      breed: json['breed'] ?? 'Unknown', // Provide default value if missing
      mother: json['mother'] ?? 'Unknown', // Provide default value if missing
      father: json['father'] ?? 'Unknown', // Provide default value if missing
      sex: json['sex'] ?? 'Unknown', // Provide default value if missing
      origin: json['origin'] ?? 'Unknown', // Provide default value if missing
      diseases: json['diseases'] ?? 'None', // Provide default value if missing
      comments: json['comments'] ?? '', // Provide default value if missing
      weight: json['weight'] ?? '0', // Provide default value if missing
      priceSold: json['price_sold'] ?? '0', // Provide default value if missing
      cage: json['cage'] ?? 'Unknown', // Provide default value if missing
      images: images,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagNo': tagNo,
      'birthday': birthday?.toIso8601String(), // Convert DateTime to String
      'breed': breed,
      'mother': mother,
      'father': father,
      'sex': sex,
      'origin': origin,
      'diseases': diseases,
      'comments': comments,
      'weight': weight,
      'price_sold': priceSold, // Use consistent naming with API
      'cage': cage,
      'images': images,
    };
  }
}

class RabbitListWidget extends StatelessWidget {
  final List<Rabbit> rabbits;

  const RabbitListWidget({super.key, required this.rabbits});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: rabbits.length,
      itemBuilder: (context, index) {
        return RabbitCard(rabbit: rabbits[index]);
      },
    );
  }
}

class PlaceholderImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/rabbit1.png', // Replace with your placeholder image path
      height: 100,
      width: 180,
      fit: BoxFit.cover,
    );
  }
}

class PlaceholderImageFemaleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/rabbit2.png', // Replace with your placeholder image path
      height: 100,
      width: 180,
      fit: BoxFit.cover,
    );
  }
}

class RabbitCard extends StatelessWidget {
  final Rabbit rabbit;

  const RabbitCard({super.key, required this.rabbit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.cyan,
      color: Colors.white,
      child: Column(
        children: [
          ClipRRect(
            //shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0)),

            child: rabbit.sex == "female" || rabbit.sex == "Female"
                ? PlaceholderImageFemaleWidget()
                /*
                Image.network(
                    rabbit.images[0], // You can display the first image here 
                    height: 100,
                    width: 180,
                    fit: BoxFit.cover,
                  )
                  */
                : PlaceholderImageWidget(),
          ),
          //SizedBox(
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RabbitDetails(rabbit: rabbit)),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          '${rabbit.tagNo} ',
                          //textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Container(
                          width: 5.0,
                          height: 5.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Cage - ${rabbit.cage}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                rabbit.breed,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                // Check if rabbit.birthday is null, if so, display "N/A"
                rabbit.birthday != null
                    ? '${((DateTime.now().difference(rabbit.birthday!).inDays) / 30).toStringAsFixed(1)} months : ${rabbit.sex}'
                    : 'N/A : ${rabbit.sex}', // Handle null birthday gracefully
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),

          //),
        ],
      ),
    );
  }
}
