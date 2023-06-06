import 'package:campus_assistant/colors.dart';
import 'package:campus_assistant/firebase_code/database.dart';
import 'package:campus_assistant/vendor_ratings.dart';
import 'package:flutter/material.dart';
import 'package:campus_assistant/widgets.dart';

class VendorDetailMenuState extends StatefulWidget {
  const VendorDetailMenuState({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VendorDetailMenuState();
}

class _VendorDetailMenuState extends State<VendorDetailMenuState> {
  bool _isLoading = false;
  List<Map<String, dynamic>> vendorData = [];
  List<Map<String, dynamic>> subsetVendorData = [];
  final TextEditingController _reviewController = TextEditingController();
  @override
  void initState() {
    _isLoading = true;
    super.initState();
    getVendorRawData();
  }

  void getVendorRawData() async {
    await DatabaseFunct().getAllFoodStores().then((value) {
      setState(() {
        vendorData = value;
        subsetVendorData = vendorData;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGray,
      drawer: drawerWidget(context),
      appBar: appBarWidget(context, Icons.food_bank),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: backgroundBlue,
            ))
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: ListTile(
                      trailing: GestureDetector(
                          onTap: () {
                            _searchVendors();
                          },
                          child: const CircleAvatar(
                            backgroundColor: backgroundBlue,
                            radius: 30,
                            child: Icon(Icons.search,
                                color: Colors.white, size: 30),
                          )),
                      // left right top bottom are the parameters
                      title: SizedBox(
                          height: 100,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: backgroundBlue, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: backgroundBlue, width: 2)),
                            ),
                            maxLines: null,
                            controller: _reviewController,
                            style: const TextStyle(color: Colors.black),
                          ))),
                ),
                (_isLoading == true)
                    ? const CircularProgressIndicator(color: backgroundBlue)
                    : (subsetVendorData.isEmpty)
                        ? const Center(
                            child: Text(
                            "No Vendor Found",
                            style: TextStyle(fontSize: 20),
                          ))
                        : Expanded(child: _vendorList(subsetVendorData))
              ],
            ),
      floatingActionButton: backButtonWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void _searchVendors() {
    subsetVendorData = List<Map<String, dynamic>>.from(vendorData);
    subsetVendorData.removeWhere((element) => !(element['name']
        .toString()
        .toLowerCase()
        .contains(_reviewController.text.toLowerCase())));
    // the above removes elements where textbox info not in the prof name
    setState(() {
      subsetVendorData; // reloads page
    });
  }

  ListView _vendorList(List<Map<String, dynamic>> data) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          child: ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return VendorRatingsPage(context, vendorId: data[index]['id']);
              }));
            },
            title: Text(data[index]['name'] as String,
                style: const TextStyle(fontFamily: "Times New Roman")),
            trailing: CircleAvatar(
              backgroundColor: backgroundBlue,
              child: Text(
                  (data[index]['avg_rating'] == 0)
                      ? '?'
                      : data[index]['avg_rating'].toString(),
                  style: const TextStyle(
                      fontFamily: "Times New Roman",
                      color: Colors.white,
                      fontSize: 16)),
            ),
            //subtitle: Text(data[index]['department'] as String,style: const TextStyle(fontFamily: "Times New Roman")),
          ),
        );
      },
    );
  }
}
