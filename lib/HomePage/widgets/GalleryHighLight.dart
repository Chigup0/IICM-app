// // ignore_for_file: file_names

// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:iism/DashBoard/pages/dashboard.dart';
// import 'package:iism/utils.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../widgets/widgets.dart';

// class GalleryHighLight extends StatelessWidget {
//   GalleryHighLight({super.key, required this.onTap});
//   final Function() onTap;
//   double height = 80;
//   double width = 80;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
//           child: customText("Gallery", 28, FontWeight.w600, dark? Colors.grey.shade100:Colors.grey.shade900, 1),
//         ),
//         StreamBuilder<QuerySnapshot>(
//          // stream: FirebaseFirestore.instance.collection('gallery').limit(6).snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (snapshot.hasData) {
//               var documents = snapshot.data!.docs;

//               return SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: documents.asMap().entries.map((entry) {
//                     int index = entry.key; // Current index
//                     var doc = entry.value; // Current document

//                     var imageUrl = doc['ImageUrl']; // Assuming 'ImageUrl' is the field name in Firestore

//                     return Padding(
//                       padding: const EdgeInsets.only(right: 4),
//                       child: (index != 5)
//                           ? ClipRRect(
//                         borderRadius: BorderRadius.circular(16),
//                         child: Stack(
//                           children: [
//                             // Shimmer loading effect
//                             Shimmer.fromColors(
//                               baseColor: dark? Colors.grey[800]! : Colors.grey[300]!,
//                               highlightColor: dark? Colors.grey[300]! : Colors.grey[100]!,
//                               child: Container(
//                                 width: width,
//                                 height: height,
//                                 color: Colors.grey[300],
//                               ),
//                             ),
//                             Image.network(
//                               imageUrl,
//                               width: width,
//                               height: height,
//                               fit: BoxFit.cover,
//                               loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//                                 if (loadingProgress == null) {
//                                   return child; // When image has loaded, return the actual image
//                                 } else {
//                                   return Shimmer.fromColors(
//                                     baseColor: Colors.grey[300]!,
//                                     highlightColor: Colors.grey[100]!,
//                                     child: Container(
//                                       width: width,
//                                       height: height,
//                                       color: Colors.grey[300],
//                                     ),
//                                   ); // Return shimmer effect while loading
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       )
//                           : Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(16),
//                             child: Image.network(
//                               imageUrl,
//                               width: width,
//                               height: height,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           Opacity(
//                             opacity: 0.93,
//                             child: InkWell(
//                               onTap: onTap,
//                               child: Container(
//                                 width: width,
//                                 height: height,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade300,
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.add,
//                                       color: Colors.grey.shade700,
//                                       size: 30,
//                                     ),
//                                     customText("See more", 13, FontWeight.w500, Colors.grey.shade700, 1),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               );
//             } else {
//               return const Center(child: Text('No Images Available'));
//             }
//           },
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';

class GalleryHighLight extends StatelessWidget {
  final Function() onTap;
  final double height = 80;
  final double width = 80;

  const GalleryHighLight({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Placeholder image data
    final List<Map<String, dynamic>> placeholderImages = List.generate(6, (index) {
      return {
        'ImageUrl': '', // empty for now
        'Caption': 'Placeholder #$index',
      };
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
          child: customText(
            "Gallery",
            28,
            FontWeight.w600,
            dark ? Colors.grey.shade100 : Colors.grey.shade900,
            1,
          ),
        ),

        // Horizontal scroll of images
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: placeholderImages.asMap().entries.map((entry) {
              int index = entry.key;

              // for first 5 images show placeholders
              if (index != 5) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // shimmer loading placeholder
                        Shimmer.fromColors(
                          baseColor: dark ? Colors.grey[800]! : Colors.grey[300]!,
                          highlightColor: dark ? Colors.grey[300]! : Colors.grey[100]!,
                          child: Container(
                            width: width,
                            height: height,
                            color: Colors.grey[300],
                          ),
                        ),
                        Container(
                          width: width,
                          height: height,
                          color: Colors.grey[900],
                          child: const Icon(
                            Icons.image_outlined,
                            color: Colors.white30,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // last one -> "See more" button
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: width,
                          height: height,
                          color: Colors.grey[900],
                          child: const Icon(
                            Icons.image_outlined,
                            color: Colors.white24,
                            size: 40,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.93,
                        child: InkWell(
                          onTap: onTap,
                          child: Container(
                            width: width,
                            height: height,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.grey.shade700,
                                  size: 30,
                                ),
                                customText(
                                  "See more",
                                  13,
                                  FontWeight.w500,
                                  Colors.grey.shade700,
                                  1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }).toList(),
          ),
        ),
      ],
    );
  }
}
