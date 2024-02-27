// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';




Widget shimmerWidget({double? width, double? height, ShapeBorder? shape}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[200]!,
    child: Container(
      width: width ?? 80,
      height: height ?? double.infinity,
      decoration: ShapeDecoration(
        color: Colors.grey,
        shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
  );
}

class InfoCard extends StatefulWidget {
  const InfoCard({Key? key}) : super(key: key);

  @override
  InfoCardState createState() => InfoCardState();
}

class InfoCardState extends State<InfoCard> {
  String? personName;
  String? jobTitle;
  String? description;
  String? description2;

  bool isEditingPersonName = false;
  bool isEditingJobTitle = false;
  bool isEditingDescription = false;
  bool isEditingDescription2 = false;

  void updateInfo(String? newName, String? newJobTitle, String? newDescription,
      String? newDescription2) {
    setState(() {
      personName = newName;
      jobTitle = newJobTitle;
      description = newDescription;
      description2 = newDescription2;
    });
  }

  void resetState() {
    setState(() {
      personName = null;
      jobTitle = null;
      description = null;
      description2 = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 9, 20, 9),
      child: Card(
        color: Colors.white.withOpacity(0.9),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Row(
            children: [
              Icon(Icons.person, size: 60),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (personName == null)
                      shimmerWidget(width: 150, height: 25, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)))
                    else if (isEditingPersonName)
                      TextField(
                        autofocus: true,
                        controller: TextEditingController(text: personName),
                        onSubmitted: (newValue) {
                          setState(() {
                            personName = newValue;
                            isEditingPersonName = false;
                          });
                        },
                      )
                    else
                      GestureDetector(
                        onTap: () => setState(() => isEditingPersonName = true),
                        child: Text(
                          personName!,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    SizedBox(height: 8),

                    if (jobTitle == null)
                      shimmerWidget(width: 150, height: 25, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)))
                    else if (isEditingJobTitle)
                      TextField(
                        autofocus: true,
                        controller: TextEditingController(text: jobTitle),
                        onSubmitted: (newValue) {
                          setState(() {
                            jobTitle = newValue;
                            isEditingJobTitle = false;
                          });
                        },
                      )
                    else
                      GestureDetector(
                        onTap: () => setState(() => isEditingJobTitle = true),
                        child: Text(
                          jobTitle!,
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16 ,color: Colors.grey,),
                        ),
                      ),
                    SizedBox(height: 8),

                    if (description == null)
                      shimmerWidget(width: double.infinity, height: 25, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)))
                    else if (isEditingDescription)
                      TextField(
                        autofocus: true,
                        controller: TextEditingController(text: description),
                        onSubmitted: (newValue) {
                          setState(() {
                            description = newValue;
                            isEditingDescription = false;
                          });
                        },
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                      )
                    else
                      GestureDetector(
                        onTap: () => setState(() => isEditingDescription = true),
                        child: Text(
                          description!,
                          style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w300),
                        ),
                      ),

                    if (description2 != null && description2!.isNotEmpty)
                      if (isEditingDescription2)
                        TextField(
                          autofocus: true,
                          controller: TextEditingController(text: description2),
                          onSubmitted: (newValue) {
                            setState(() {
                              description2 = newValue;
                              isEditingDescription2 = false;
                            });
                          },
                          style: TextStyle(fontSize: 16),
                        )
                      else
                        GestureDetector(
                          onTap: () => setState(() => isEditingDescription2 = true),
                          child: Text(
                            description2!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}



class InfoTile extends StatefulWidget {
  const InfoTile({Key? key}) : super(key: key);

  @override
  InfoTileState createState() => InfoTileState();
}

class InfoTileState extends State<InfoTile> {
  String? phoneNumber;
  String? phoneNumber2;
  String? address;
  String? email;
  String? url;

  void updateInfo(String? newPhoneNumber,
      String? newPhoneNumber2,
      String? newAddress,
      String? newEmail,
      String? newUrl,) {
    setState(() {
      phoneNumber = newPhoneNumber;
      phoneNumber2 = newPhoneNumber2;
      address = newAddress;
      email = newEmail;
      url = newUrl;
    });
  }

  void resetState() {
    setState(() {
      phoneNumber = null;
      phoneNumber2 = null;
      address = null;
      email = null;
      url = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (phoneNumber != "")
                buildInfoOrShimmerContainer(Icons.phone, phoneNumber),

              SizedBox(height: phoneNumber != "" ? 16 : 0),

              if (phoneNumber2 != "")
                buildInfoOrShimmerContainer(Icons.phone, phoneNumber2),

              SizedBox(height: phoneNumber2 != "" ? 16 : 0),

              if (address != "")
                buildInfoOrShimmerContainer(Icons.location_on, address),

              SizedBox(height: address != "" ? 16 : 0),

              if (email != "")
                buildInfoOrShimmerContainer(Icons.email, email),

              SizedBox(height: email != "" ? 16 : 0),

              if (url != "")
                buildInfoOrShimmerContainer(Icons.public, url),
            ].where((element) => element != null).toList(), //remove null elements that might result from conditionals
          ),
        ),
      ),
    );
  }

// build info container or display a shimmer
  Widget buildInfoOrShimmerContainer(IconData icon, String? text) {
    return text == null ? Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(6),
      ),
      height: 40,
      child: shimmerWidget(width: double.infinity, height: 20, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
    ) : Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(6),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.grey),
          Expanded(child: Text(text, textAlign: TextAlign.right, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
  }









