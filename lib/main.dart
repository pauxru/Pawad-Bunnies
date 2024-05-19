import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_drive/new_rabbit.dart';
import 'package:test_drive/ToDoPage.dart';
import 'package:test_drive/rabbit_details_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
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

  Future<void> loadRabbits() async {
    // Load JSON data from the 'assets/rabbits.json' file
    final String jsonString =
        await rootBundle.loadString('assets/rabbits/rabbits.json');
    // Parse the JSON data into a list of Rabbit objects
    final List<dynamic> jsonList = json.decode(jsonString);
    final List<Rabbit> rabbitList =
        jsonList.map((json) => Rabbit.fromJson(json)).toList();

    setState(() {
      rabbits = rabbitList;
    });
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
            }
          },
        ),
      ),
    );
  }
}

// The Rabbit class and RabbitListWidget class remain unchanged

class Rabbit {
  final String tagNo;
  final DateTime birthday;
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
    required this.birthday,
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
    return Rabbit(
      tagNo: json['tagNo'],
      birthday: DateTime.parse(json['birthday']),
      breed: json['breed'],
      mother: json['mother'],
      father: json['father'],
      sex: json['sex'],
      origin: json['origin'],
      diseases: json['diseases'],
      comments: json['comments'],
      weight: json['weight'],
      priceSold: json['price_sold'],
      cage: json['cage'],
      images: List<String>.from(json['images']),
    );
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

            child: rabbit.sex == "female"
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
                '${((DateTime.now().difference(rabbit.birthday).inDays) / 30).toStringAsFixed(1)} : ${rabbit.sex}',
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
