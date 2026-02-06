import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/lib/view/mainsection/booking/bookings.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:http/http.dart' as http;
import 'package:progressive_image/progressive_image.dart';

class MyGallery extends StatefulWidget {
  String type;
  MyGallery({super.key, required this.type});

  @override
  State<MyGallery> createState() => _MyGalleryState();
}

class _MyGalleryState extends State<MyGallery> {
  // List<File> images = [];
  File? images;

  Future<void> _pickSalonLo() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        images = File(pickedImage.path);

        // generatePDF(images!);
      } else {
        print('No image selected.');
      }
    });
  }
  // List<File> images = [];

  // Future<void> _pickSalonLo() async {
  //   List<Asset> resultList = [];
  //   try {
  //     resultList = await MultiImagePicker.pickImages();
  //   } on Exception catch (e) {
  //     print(e.toString());
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     images.clear(); // Clear the existing list of files
  //     images = resultList.map((Asset asset) {
  //       return File(asset.identifier); // Convert Asset to File
  //     }).toList();
  //   });
  // }

  Future<File> generatePDF(File imageFile) async {
    final output = await getTemporaryDirectory();
    final htmlContent = '<img src="${imageFile.path}" />';

    // final pdf = await FlutterHtmlToPdf.convertFromHtmlContent(
    //   htmlContent,

    //   output.toString(),
    //   'output.pdf', // Specify the name of the output PDF file
    // );

    final pdfDocument = pdfLib.Document();

    //  final pdfDocument = pdfLib.Document();

    // Read image file as bytes
    final Uint8List imageData = await imageFile.readAsBytes();
    final image = pdfLib.MemoryImage(imageData);

    pdfDocument.addPage(
      pdfLib.Page(
        build: (pdfLib.Context context) {
          return pdfLib.Center(
            child: pdfLib.Image(image, fit: pdfLib.BoxFit.fill),
          );
        },
      ),
    );

    final pdfFile = await pdfDocument.save();

    final pdfPath = output.toString();
    final file = File(pdfPath);
    await file.writeAsBytes(pdfFile);
    return file;
  }

  //Select Multiple Images

  final ImagePicker _imagePicker = ImagePicker();
  List _getBusinessFileImages = [];
  List _businessImagePaths = [];

  Future<void> toggleSelectMultipleImages() async {
    final List<XFile>? selectedImages = await _imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      bool imagesAdded = false;
      for (XFile image in selectedImages) {
        if (_businessImagePaths.length >= 10) {
          // Check if the limit has been reached
          break;
        }
        String imagePath = image.path;
        print('Checking image path: $imagePath');
        if (!_businessImagePaths.contains(imagePath)) {
          _businessImagePaths.add(imagePath); // Storing unique image paths
          File file = File(imagePath); // Convert XFile to File
          _getBusinessFileImages.add(file);
          imagesAdded = true;
        } else {
          print(
              'Image already selected: $imagePath'); // Notify that image is already selected
        }
      }

      if (imagesAdded) {
        showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          context: context,
          builder: (BuildContext context) {
            return getImagesFile();
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      getImagessss();
      // getImages();
    });
  }

  uploadImage() {
    addImageees(context, _businessImagePaths, (response) async {
      setState(() {});
      EasyLoading.showSuccess("Images added");
      await getImagessss();
      // getImages();
      Navigator.pop(context);
    });
  }

  // getImages() {
  //   print('$accessToken');
  //   getImagesGall(context, (response) {
  //     setState(() {
  //       galleryData = response;
  //     });
  //   });
  // }

  getImagesFile() {
    PageController pagCon = PageController();
    int selectedInd = 0;
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
          color: white,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: 4,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: primaryColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: PageView.builder(
              controller: pagCon,
              itemCount: _getBusinessFileImages.length,
              onPageChanged: (ind) {
                setState(() {
                  selectedInd = ind;
                });
                print(selectedInd);
              },
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Align(
                    child: Container(
                      height: 500,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_getBusinessFileImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Bounce(
                          onTap: () {
                            if (_getBusinessFileImages.length > 1) {
                              EasyLoading.showToast("Image Removed");
                              _getBusinessFileImages.removeAt(index);
                              _businessImagePaths.removeAt(index);
                              setState(() {
                                selectedInd = 0;
                                pagCon.animateToPage(
                                  selectedInd,
                                  duration: Duration(
                                      milliseconds:
                                          500), // Adjust duration as needed
                                  curve: Curves
                                      .easeInOut, // Choose an appropriate curve
                                );
                              });
                            } else {
                              EasyLoading.showError(
                                  "Please add images first to upload to gallery");
                              _getBusinessFileImages.removeAt(index);
                              _businessImagePaths.removeAt(index);
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10, right: 10),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              color: white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.25),
                                  offset: Offset(1, 4),
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(.0),
                                  offset: Offset(1, 1),
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.delete_forever,
                              color: red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )),
            Container(
              height: 170,
              color: black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Align(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedInd = index;
                                });
                                pagCon.animateToPage(
                                  selectedInd,
                                  duration: Duration(
                                      milliseconds:
                                          500), // Adjust duration as needed
                                  curve: Curves
                                      .easeInOut, // Choose an appropriate curve
                                );
                                print(selectedInd);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: selectedInd == index ? 65 : 60,
                                width: selectedInd == index ? 55 : 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: selectedInd == index
                                        ? Colors.white
                                        : Colors.grey.withOpacity(0.6),
                                    width: selectedInd == index ? 2 : 0,
                                  ),
                                  image: DecorationImage(
                                    image: FileImage(
                                      _getBusinessFileImages[index],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _getBusinessFileImages.length,
                      shrinkWrap: true,
                    ),
                  ),
                  Bounce(
                    onTap: () {
                      uploadImage();
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: white,
                      ),
                      child: Center(
                        child: Text(
                          "Upload Images",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: black,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Future getImagessss() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/vendor/gallery/getimages'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("hit");
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        galleryData = decodedMap;
        imagesID.clear();
      });
    } else {
      imagesID.clear();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        galleryData = decodedMap;
        imagesID.clear();
      });
      // failed(mesg: decodedMap['message'], context: context);
      print(response.reasonPhrase);
    }
  }

  Future deleteImages() async {
    EasyLoading.show();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request(
        'DELETE', Uri.parse('$BASE_URL/vendor/gallery/deletegallery'));
    request.body = json.encode({"ids": imagesID});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      success(mesg: "Images deleted", context: context);

      getImagessss();
      print(await response.stream.bytesToString());
    } else {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      failed(mesg: decodedMap['message'], context: context);
      print(response.reasonPhrase);
      print(response.reasonPhrase);
    }
  }

  List imagesID = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: widget.type == "mainsection"
            ? AppBar(
                backgroundColor: white,
                centerTitle: true,
                title: InkWell(
                  onTap: () {
                    log(accessToken);
                  },
                  child: Text(
                    "My Gallery",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
              )
            : null,
        floatingActionButton: widget.type == "mainsection"
            ? imagesID.isNotEmpty
                ? Bounce(
                    onTap: () {
                      deleteImages();
                    },
                    child: FloatingActionButton(
                      splashColor: Colors.grey,
                      hoverColor: Colors.grey,
                      focusColor: Colors.grey,
                      onPressed: () {
                        deleteImages();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.red,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Icon(
                              Icons.delete_forever,
                              size: 28,
                              color: white,
                            ),
                          ),
                        ),
                      ),
                      backgroundColor: white,
                    ),
                  )
                : Bounce(
                    onTap: () {
                      success(
                          mesg: "You can add only 10 images at time",
                          context: context);
                      Future.delayed(Duration(seconds: 1), () {
                        toggleSelectMultipleImages();
                      });
                    },
                    child: FloatingActionButton(
                      splashColor: Colors.grey,
                      hoverColor: Colors.grey,
                      focusColor: Colors.grey,
                      onPressed: () {
                        success(
                            mesg: "You can add only 10 images at time",
                            context: context);
                        Future.delayed(Duration(seconds: 1), () {
                          toggleSelectMultipleImages();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: primaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Icon(
                              Icons.add,
                              size: 28,
                              color: white,
                            ),
                          ),
                        ),
                      ),
                      backgroundColor: white,
                    ),
                  )
            : null,
        // body: images == null ? SizedBox() : Image.file(images!)
        body: galleryData.isEmpty
            ? ShimmerList()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: galleryData['data'].isEmpty
                    ? Center(child: Text('No images found'))
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          mainAxisSpacing: 2.0,
                          crossAxisSpacing: 2.0,
                          childAspectRatio:
                              1.0, // Adjust based on your requirements
                        ),
                        itemCount: galleryData['data'].length,
                        itemBuilder: (context, index) {
                          final imageUrl = IMAGE_BASE_URL +
                              galleryData['data'][index]['image'];
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onLongPress: () {
                                if (imagesID.contains(
                                    galleryData['data'][index]['_id'])) {
                                  imagesID.remove(
                                      galleryData['data'][index]['_id']);
                                  setState(() {});
                                } else {
                                  imagesID
                                      .add(galleryData['data'][index]['_id']);
                                  setState(() {});
                                }
                              },
                              onTap: () {
                                if (imagesID.contains(
                                    galleryData['data'][index]['_id'])) {
                                  imagesID.remove(
                                      galleryData['data'][index]['_id']);
                                  setState(() {});
                                } else {
                                  imagesID
                                      .add(galleryData['data'][index]['_id']);
                                  setState(() {});
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 2.0,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            Image.asset(
                                                'assets/images/logo.png'),
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                        width: 220,
                                        height: 220,
                                        fadeInDuration:
                                            Duration(milliseconds: 500),
                                      ),
                                    ),
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(20),
                                    //   child: ProgressiveImage(
                                    //     placeholder: AssetImage(
                                    //         'assets/images/logo.png'),
                                    //     thumbnail: NetworkImage(
                                    //         imageUrl + '?w=100&h=100&fit=blur'),
                                    //     image: CachedNetworkImageProvider(
                                    //         imageUrl),
                                    //     fit: BoxFit.cover,
                                    //     fadeDuration:
                                    //         Duration(milliseconds: 500),
                                    //     blur: 5,
                                    //     width: 220,
                                    //     height: 220,
                                    //   ),
                                    // ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          onTap: () {
                                            showModalBottomSheet<void>(
                                              backgroundColor:
                                                  Colors.transparent,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(30),
                                                ),
                                              ),
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Padding(
                                                  padding:
                                                      MediaQuery.of(context)
                                                          .viewInsets,
                                                  child: getData(
                                                      imageUrl, context),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: white, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(90),
                                              color: black.withOpacity(0.2),
                                            ),
                                            child: Icon(
                                              Icons.open_in_full,
                                              color: white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (imagesID.contains(
                                        galleryData['data'][index]['_id']))
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: white, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(90),
                                              color: primaryColor,
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              color: white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                // : GridView.custom(
                //     gridDelegate: SliverQuiltedGridDelegate(
                //       crossAxisCount: 3,
                //       mainAxisSpacing: 2,
                //       crossAxisSpacing: 2,
                //       repeatPattern: QuiltedGridRepeatPattern.inverted,
                //       pattern: [
                //         QuiltedGridTile(2, 2),
                //         QuiltedGridTile(1, 1),
                //         QuiltedGridTile(2, 1),
                //         QuiltedGridTile(1, 2),
                //       ],
                //     ),
                //     childrenDelegate: SliverChildBuilderDelegate(
                //       (context, index) {
                //         final imageUrl = IMAGE_BASE_URL +
                //             galleryData['data'][index]['image'];
                //         return Padding(
                //           padding: const EdgeInsets.all(2.0),
                //           child: InkWell(
                //             borderRadius: BorderRadius.circular(90),
                //             onLongPress: () {
                //               if (imagesID.contains(
                //                   galleryData['data'][index]['_id'])) {
                //                 imagesID.remove(
                //                     galleryData['data'][index]['_id']);
                //                 setState(() {});
                //               } else {
                //                 imagesID
                //                     .add(galleryData['data'][index]['_id']);
                //                 setState(() {});
                //               }
                //             },
                //             onTap: () {
                //               if (imagesID.contains(
                //                   galleryData['data'][index]['_id'])) {
                //                 imagesID.remove(
                //                     galleryData['data'][index]['_id']);
                //                 setState(() {});
                //               } else {
                //                 imagesID
                //                     .add(galleryData['data'][index]['_id']);
                //                 setState(() {});
                //               }
                //             },
                //             child: Container(
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(10),
                //                 boxShadow: [
                //                   BoxShadow(
                //                     color: Colors.black.withOpacity(0.1),
                //                     blurRadius: 2.0,
                //                   ),
                //                 ],
                //               ),
                //               child: Stack(
                //                 children: [
                //                   ClipRRect(
                //                     borderRadius: BorderRadius.circular(20),
                //                     child: ProgressiveImage(
                //                       placeholder: AssetImage(
                //                           'assets/images/logo.png'),
                //                       thumbnail: NetworkImage(imageUrl +
                //                           '?w=100&h=100&fit=blur'),
                //                       image: CachedNetworkImageProvider(
                //                           imageUrl),
                //                       fit: BoxFit.cover,
                //                       fadeDuration:
                //                           Duration(milliseconds: 500),
                //                       blur: 5,
                //                       width: 220,
                //                       height: 220,
                //                     ),
                //                   ),
                //                   Align(
                //                     alignment: Alignment.bottomLeft,
                //                     child: Padding(
                //                       padding: const EdgeInsets.all(8.0),
                //                       child: InkWell(
                //                         borderRadius:
                //                             BorderRadius.circular(90),
                //                         onTap: () {
                //                           showModalBottomSheet<void>(
                //                               backgroundColor:
                //                                   Colors.transparent,
                //                               isScrollControlled: true,
                //                               shape: RoundedRectangleBorder(
                //                                   borderRadius:
                //                                       BorderRadius.vertical(
                //                                           top: Radius
                //                                               .circular(
                //                                                   30))),
                //                               context: context,
                //                               builder:
                //                                   (BuildContext context) {
                //                                 return Padding(
                //                                     padding: MediaQuery.of(
                //                                             context)
                //                                         .viewInsets,
                //                                     child:
                //                                         getData(imageUrl));
                //                               });
                //                         },
                //                         child: Container(
                //                           height: 25,
                //                           width: 25,
                //                           decoration: BoxDecoration(
                //                             border: Border.all(
                //                                 color: white, width: 1),
                //                             borderRadius:
                //                                 BorderRadius.circular(90),
                //                             color: black.withOpacity(0.2),
                //                           ),
                //                           child: Icon(
                //                             Icons.open_in_full,
                //                             color: white,
                //                             size: 16,
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                   imagesID.contains(
                //                           galleryData['data'][index]['_id'])
                //                       ? Align(
                //                           alignment: Alignment.topRight,
                //                           child: Padding(
                //                             padding:
                //                                 const EdgeInsets.all(8.0),
                //                             child: Container(
                //                               height: 25,
                //                               width: 25,
                //                               decoration: BoxDecoration(
                //                                 border: Border.all(
                //                                     color: white, width: 1),
                //                                 borderRadius:
                //                                     BorderRadius.circular(
                //                                         90),
                //                                 color: primaryColor,
                //                               ),
                //                               child: Icon(
                //                                 Icons.check,
                //                                 color: white,
                //                                 size: 16,
                //                               ),
                //                             ),
                //                           ),
                //                         )
                //                       : SizedBox(),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         );
                //       },
                //       childCount: galleryData['data'].length,
                //     ),
                //   ),
                ));
  }
}

getData(url, context) {
  return Container(
    height: 700,
    width: double.infinity,
    child: Column(
      children: [
        Align(
          child: Container(
            height: 60,
            width: double.infinity,
            color: Colors.transparent,
            child: Align(
              child: InkWell(
                borderRadius: BorderRadius.circular(90),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: white,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              color: white,
            ),
            child: Stack(
              children: [
                Opacity(
                    opacity: 0.2,
                    child: Center(
                        child: Image.asset('assets/images/doodles.jpg'))),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: ProgressiveImage(
                        placeholder: AssetImage('assets/images/logo.png'),
                        thumbnail: NetworkImage(url + '?w=100&h=100&fit=blur'),
                        image: CachedNetworkImageProvider(url),
                        fit: BoxFit.contain,
                        fadeDuration: Duration(milliseconds: 500),
                        blur: 5,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}





// //=========================================================================//
// //=============================MULTIPLE IMAGES=============================//
// //=========================================================================//

// class PickersScreen extends StatelessWidget {
//   const PickersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<InstaPickerInterface> pickers = [
//       const SinglePicker(),
//       const MultiplePicker(),
//       const RestorablePicker(),
//       CameraPicker(camera: _cameras.first),
//       const WeChatCameraPicker(),
//     ];

//     return Scaffold(
//       appBar: AppBar(title: const Text('Insta pickers')),
//       body: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemBuilder: (BuildContext context, int index) {
//           final PickerDescription description = pickers[index].description;

//           return Card(
//             child: ListTile(
//               leading: Text(description.icon),
//               title: Text(description.label),
//               subtitle: description.description != null
//                   ? Text(description.description!)
//                   : null,
//               trailing: const Icon(Icons.chevron_right_rounded),
//               onTap: () => Navigator.of(context).push(
//                 MaterialPageRoute(builder: (context) => pickers[index]),
//               ),
//             ),
//           );
//         },
//         separatorBuilder: (_, __) => const SizedBox(height: 4),
//         itemCount: pickers.length,
//       ),
//     );
//   }
// }