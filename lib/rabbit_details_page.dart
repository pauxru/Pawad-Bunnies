// import 'package:flutter/material.dart';
// import 'package:test_drive/main.dart';

// class RabbitDetails extends StatelessWidget {
//   final Rabbit rabbit;

//   // Constructor to recieve arguments
//   const RabbitDetails({super.key, required this.rabbit});

//   @override
//   Widget build(BuildContext context) {
//     const double h = 8.0;
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(rabbit.tagNo),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Section for horizontally scrollable images
//               SizedBox(
//                 height: 200.0,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: rabbit.images.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Image.network(
//                         rabbit.images[index],
//                         width: 150.0,
//                         height: 150.0,
//                         fit: BoxFit.cover,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               // Section for rabbit details
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Table(
//                         border: TableBorder.all(
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(10)),
//                           color: const Color.fromARGB(255, 53, 155, 250),
//                           width: 0.5,
//                         ),
//                         // Allows to add a border decoration around your table

//                         children: [
//                           TableRow(children: [
//                             const Text(
//                               'Tag No',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               rabbit.tagNo,
//                               style: const TextStyle(
//                                   fontSize: 15.0,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ]),
//                           TableRow(children: [
//                             const Text(
//                               'Birthday',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               rabbit.birthday.toString().substring(0, 10),
//                               style: const TextStyle(
//                                   fontSize: 15.0,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ]),
//                           TableRow(children: [
//                             const Text(
//                               'Breed',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               rabbit.breed,
//                               style: const TextStyle(
//                                   fontSize: 15.0,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ]),
//                           TableRow(children: [
//                             const Text(
//                               'Father',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               rabbit.father,
//                               style: const TextStyle(
//                                   fontSize: 15.0,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ]),
//                           TableRow(children: [
//                             const Text(
//                               'Mother',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               rabbit.mother,
//                               style: const TextStyle(
//                                   fontSize: 15.0,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ]),
//                           TableRow(children: [
//                             const Text(
//                               'Sex',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               rabbit.sex,
//                               style: const TextStyle(
//                                   fontSize: 15.0,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ]),
//                           TableRow(children: [
//                             const Text(
//                               'Cage No',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               rabbit.cage,
//                               style: const TextStyle(
//                                   fontSize: 15.0,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ]),
//                           TableRow(children: [
//                             const Text(
//                               'Comments',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               rabbit.comments,
//                               style: const TextStyle(
//                                   fontSize: 15.0,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ]),
//                           TableRow(children: [
//                             const Text(
//                               'Diseases',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               rabbit.diseases,
//                               style: const TextStyle(
//                                   fontSize: 15.0,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ]),
//                           TableRow(children: [
//                             const Text(
//                               'Origin',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               rabbit.origin,
//                               style: const TextStyle(
//                                   fontSize: 15.0,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ]),
//                           TableRow(children: [
//                             const Text(
//                               'Price sold',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               rabbit.priceSold,
//                               style: const TextStyle(
//                                   fontSize: 15.0,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ]),
//                           TableRow(children: [
//                             const Text(
//                               'Weight',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               rabbit.weight,
//                               style: const TextStyle(
//                                   fontSize: 15.0,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ]),
//                         ]),

//                     // Add more details here based on your requirements
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
