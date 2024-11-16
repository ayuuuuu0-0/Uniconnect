import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:uniconnect/ChatPage/ChatPage.dart';
import 'package:uniconnect/HomeScreen/HomeScreen.dart';
import 'package:uniconnect/Widgets/global_var.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageSliderScreen extends StatefulWidget {

  final String title, urlImage1, urlImage2, urlImage3, urlImage4,
      //urlImage5;
  itemColor, userNumber, description, userEmail,
      //address,
      itemPrice;
  //final double lat, lng;

  ImageSliderScreen({
    required this.title,
    required this.urlImage1,
    required this.urlImage2,
    required this.urlImage3,
    required this.urlImage4,
    //required this.urlImage5,
    required this.itemColor,
    required this.userNumber,
    required this.userEmail,
    required this.description,
    //required this.address,
    required this.itemPrice,
    //required this.lat,
    //required this.lng,
});

  @override
  State<ImageSliderScreen> createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> with SingleTickerProviderStateMixin {

  static List<String> links = [];
  TabController? tabController;

  getLinks() {
    links.add(widget.urlImage1);
    links.add(widget.urlImage2);
    links.add(widget.urlImage3);
    links.add(widget.urlImage4);
    //links.add(widget.urlImage5);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLinks();
    tabController = TabController(length: 4, vsync: this);
  }

  String? url;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.black
            ),
          ),
          title: Text(
            widget.title,
            style: const TextStyle(fontFamily: 'Varela', letterSpacing: 2.0,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen())
              );
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white,),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 6.0, right: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //const Icon(Icons.location_pin, color: Colors.white,),
                    //const SizedBox(width: 4.0,),
                    // Expanded(
                    //   child: Text(
                    //     widget.address,
                    //     textAlign: TextAlign.justify,
                    //     overflow: TextOverflow.fade,
                    //     style: const TextStyle(
                    //       fontFamily: 'Varela',
                    //       letterSpacing: 2.0,
                    //       color: Colors.blueGrey,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0,),
              SizedBox(
                height: size.height * 0.5,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Carousel(
                    indicatorBarColor: Colors.white.withOpacity(0.2),
                    autoScrollDuration: const Duration(seconds: 2),
                    animationPageDuration: const Duration(milliseconds: 500),
                    activateIndicatorColor: Colors.white,
                    animationPageCurve: Curves.easeIn,
                    indicatorBarHeight: 30,
                    indicatorHeight: 10,
                    unActivatedIndicatorColor: Colors.grey,
                    stopAtEnd: false,
                    autoScroll: true,
                    items: [
                      Image.network(widget.urlImage1,),
                      Image.network(widget.urlImage2,),
                      Image.network(widget.urlImage3,),
                      Image.network(widget.urlImage4,),
                      //Image.network(widget.urlImage5,),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Center(
                  child: Text(
                    '\₹ ${widget.itemPrice}',
                    style: const TextStyle(
                        fontFamily: "DMSerifText",
                        fontSize: 24,
                        letterSpacing: 2.0,
                        color: Colors.white54
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.color_lens_rounded,
                          color: Colors.white60
                          ,),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(widget.itemColor,
                              style: const TextStyle(
                                fontFamily: "DMSerifText",
                                color: Colors.white60,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewChatPage(otherUserEmail: widget.userEmail,)
                              ),
                          );
                        }, icon: Icon(Icons.message_rounded)),
                        //Icon(Icons.phone, color: Colors.white60,),
                        Padding(padding: EdgeInsets.only(left: 5.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewChatPage(otherUserEmail: widget.userEmail,)
                                  ),
                                );
                              },
                              child: Text('Message',
                                style: const TextStyle(
                                  fontFamily: "DMSerifText",
                                  color: Colors.white60,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0,),
              Padding(padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  widget.description,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontFamily: "DMSerifText",
                    color: Colors.white60,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              // Center(
              //   child: ConstrainedBox(
              //     constraints: BoxConstraints.tightFor(width: 368),
              //     child: ElevatedButton(
              //       onPressed: ()
              //       async
              //       {
              //         //double latitude = widget.lat;
              //         //double longitude = widget.lng;
              //         url = 'https://www.google.com/maps/search/?api=1&query=$latitude, $longitude';
              //         if(await canLaunchUrl(Uri.parse(url!)))
              //           {
              //             await launchUrl(Uri.parse(url!));
              //           }
              //         else
              //           {
              //             throw 'Could not open the map';
              //           }
              //       },
              //       style: ButtonStyle(
              //         backgroundColor: MaterialStateProperty.all(Colors.black54),
              //       ),
              //       child: Text('Check Seller Location'),
              //     ),
              //   ),
              // ),
              SizedBox(height: 20.0,),
            ],
          ),
        ),
      ),
    );
  }
}
