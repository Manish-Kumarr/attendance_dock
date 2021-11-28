//  Widget _dropdown() {
//   return Container(
//     width: double.infinity,
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           FontAwesomeIcons.userAlt,
//           color: mainColor,
//         ),
//         SizedBox(
//           width: 20,
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width * .80,
//           child: DropdownButton(
//             items: _teachers
//                 .map(
//                   (value) => DropdownMenuItem(
//                     child: Text(value),
//                     value: value,
//                   ),
//                 )
//                 .toList(),
//             onChanged: (e) {
//               setState(() {
//                 selected = e;
//               });
//             },
//             value: selected,
//             hint: Text('Select Teacher'),
//             isExpanded: true,
//           ),
//         )
//       ],
//     ),
//   );
// }

// QuerySnapshot teachers;

// Widget updateList() {
//   return teachers != null
//       ? ListView.builder(
//           itemCount: teachers.documents.length,
//           shrinkWrap: true,
//           itemBuilder: (context, index) {
//             return SearchTile(name: teachers.documents[index].data['name']);
//           },
//         )
//       : CircularProgressIndicator();
// }

// final userRef = Firestore.instance.collection('teachers');
// get() {
//   userRef.getDocuments().then((value) {
//     value.documents.forEach((element) {
//       print(element.data['fullName']);
//       print(element.documentID);
//     });
//   });
// }
